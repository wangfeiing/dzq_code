//
//  PlayViewController.m
//  Play
//
//  Created by chentianyu on 16/5/8.
//  Copyright © 2016年 chentianyu. All rights reserved.
//

#define UseNoteCursor // define this to make the cursor move to each note as it plays, else it moves to the current bar
//#define PrintPlayData // define this to print play data in the console when play is pressed
//#define ColourPlayedNotes // define this to colour played notes green
#define ColourTappedItem // define this to colour any item tapped in the score for 0.5s
//#define PrintXMLForTappedBar // define this to print the XML for the bar in the console (contents licence needed)

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SSScrollView.h"
#include <dispatch/dispatch.h>
#import <Masonry/Masonry.h>

static const float kDefaultMagnification = 1;
static const float kMinTempoScaling = 0.3;
static const float kMaxTempoScaling = 3.0;
static const int kMinTempo = 10;
static const int kMaxTempo = 360;
static const int kDefaultTempo = 80;
static const float kStartPlayDelay = 1.0;//s
static const float kRestartDelay = 0.2;//s

#define WhiteKeyWidth   [[UIScreen mainScreen] bounds].size.width/54
static const float WhiteKeyHeight = 150;
#define BlackKeyWidth   WhiteKeyWidth*2/3
#define BlackKeyHeight  WhiteKeyHeight*0.6

//static const int 

//																	name,	baseFile,	extn,	lowestMidi, numFiles, volume, attack_ms, decay_ms, overlap_ms);
static const sscore_sy_sampledinstrumentinfo kPianoSamplesInfo = {"Piano", "Piano.mf", "m4a",23, 86,	1.0, 4, 10, 10, "piano,pianoforte,klavier", 0};
// 3 metronome ticks are currently supported (tickpitch = 0, 1 or 2):
static const sscore_sy_synthesizedinstrumentinfo kTick1Info = {"Tick1", 0, 1.0};

static float limit(float val, int min, int max)
{
    if (val < min)
        return min;
    else if (val > max)
        return max;
    else
        return val;
}

@interface PlayViewController ()
{
    SSScore *score;
    UIPopoverController *popover;
    UITapGestureRecognizer *tapRecognizer;
    UILongPressGestureRecognizer *pressRecognizer;
    
    bool showingSinglePart; // is set when a single part is being displayed
    
    NSMutableArray *showingParts;
    SSLayoutOptions *layOptions; // set of options for layout
    
    int loadFileIndex; // increment to load next file in directory
    
    SSSynth *synth;
    
    unsigned instrumentId;
    unsigned metronomeInstrumentId;
    
    UIBarButtonItem *linkePinaoItem;
    
    bool isPlaying;
    
}

@property(nonatomic,strong)UIBarButtonItem *playItem;


@property(nonatomic,strong)UIView *key_view;

-(void)moveNoteCursor:(NSArray*)notes;

@end


/********** Event Handlers ***********/

@interface BarChangeHandler : NSObject <SSEventHandler>
{
    PlayViewController *svc;
    int lastIndex;
}
@end

@implementation BarChangeHandler

-(instancetype)initWith:(PlayViewController *)vc
{
    self = [super init];
    if (self)
    {
        svc = vc;
        lastIndex=-100;
    }
    return self;
}

-(void)event:(int)index countIn:(bool)countIn
{
#ifdef ColourPlayedNotes
    bool startRepeat = index < lastIndex;
    if (startRepeat)
    {
        sscore_barrange br;
        br.startbarindex = index;
        br.numbars = svc.score.numBars - index;
        [svc.theScrollView clearColouringForBarRange:&br];
    }
#endif
#ifdef UseNoteCursor
    [svc.theScrollView setCursorAtBar:index type:cursor_line scroll:scroll_bar];
#else
    [svc.theScrollView setCursorAtBar:index
                                 type:(countIn) ? cursor_line : cursor_rect
                               scroll:scroll_bar];
#endif
    svc.cursorBarIndex = index;
    lastIndex = index;
}
@end

@interface BeatHandler : NSObject <SSEventHandler>
{ PlayViewController *svc; }
@end

@implementation BeatHandler

-(instancetype)initWith:(PlayViewController *)vc
{
    self = [super init];
    if (self)
    { svc = vc;	}
    return self;
}

-(void)event:(int)index countIn:(bool)countIn
{
    svc.countInLabel.hidden = !countIn;
    if (countIn)
        svc.countInLabel.text = [NSString stringWithFormat:@"%d", index + 1]; // show count-in
}
@end

@interface EndHandler : NSObject <SSEventHandler>
{ PlayViewController *svc; }
@end

@implementation EndHandler

-(instancetype)initWith:(PlayViewController *)vc
{
    self = [super init];
    if (self)
    { svc = vc;	}
    return self;
}

-(void)event:(int)index countIn:(bool)countIn
{
    [svc.theScrollView hideCursor];
    svc.countInLabel.hidden = true;
    svc.cursorBarIndex = 0;
    [svc stopPlaying];
#ifdef ColourPlayedNotes
    [svc.theScrollView clearAllColouring];
#endif
}
@end

@interface NoteHandler : NSObject <SSNoteHandler>
{ PlayViewController *svc; }
@end

@implementation NoteHandler

-(instancetype)initWith:(PlayViewController *)vc
{
    self = [super init];
    if (self)
    { svc = vc;}
    return self;
}

-(void)startNotes:(NSArray *)pnotes
{
    assert(pnotes.count > 0);
    [svc moveNoteCursor:pnotes];
#ifdef ColourPlayedNotes
    // convert array of SSPDPartNote to array of SSPDNote
    NSMutableArray *notes = NSMutableArray.array;
    for (SSPDPartNote *n in pnotes)
        [notes addObject:n.note];
    [svc colourPDNotes:notes];
#endif
}

-(void) endNote:(SSPDPartNote *)note
{/*unused*/}
@end


@implementation PlayViewController

+(NSString*)defaultDirectoryPath
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [searchPaths objectAtIndex: 0];
}

+(NSString*)copyBundleFileToDocuments:(NSURL *)srcURL
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *urls = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *dstURL = [[urls objectAtIndex:0] URLByAppendingPathComponent:[srcURL lastPathComponent]];
    NSLog(@"path:-------%@+\n+destUrl:%@",urls,dstURL);
    NSError *error;
    [fileManager copyItemAtURL:srcURL
                         toURL:dstURL
                         error:&error];
    // ignore error
    return [dstURL path];
}

-(bool)loadableFile:(NSString*)filename
{
    return ([[filename pathExtension] isEqualToString:@"xml"]
            ||[[filename pathExtension] isEqualToString:@"mxl"]);
}

#pragma mark -Audio Session Route Change Notification

- (void)handleRouteChange:(NSNotification *)notification
{
    UInt8 reasonValue = [[notification.userInfo valueForKey:AVAudioSessionRouteChangeReasonKey] intValue];
    //AVAudioSessionRouteDescription *routeDescription = [notification.userInfo valueForKey:AVAudioSessionRouteChangePreviousRouteKey];
    
    switch (reasonValue) {
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            if (synth && synth.isPlaying)
                [synth reset];
            break;
    }
}

-(bool)setupAudioSession
{
    NSError *error = nil;
    AVAudioSession *sessionInstance = [AVAudioSession sharedInstance];
    [sessionInstance setCategory:AVAudioSessionCategoryPlayback error:&error];
    [sessionInstance setActive:YES error:&error];
    // watch for audio route change
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleRouteChange:)
                                                 name:AVAudioSessionRouteChangeNotification
                                               object:[AVAudioSession sharedInstance]];
    return YES;
}

-(void)clearAudioSession
{
    AVAudioSession *sessionInstance = [AVAudioSession sharedInstance];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSError *error = nil;
    [sessionInstance setActive:NO error:&error];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sl_nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = left;
    
    
    //play
    isPlaying = false;
    self.playItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"slcd_play"] style:UIBarButtonItemStylePlain target:self action:@selector(playXML)];
  
    
 
    linkePinaoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"slcd_stop"] style:UIBarButtonItemStylePlain target:self action:@selector(linkPiano)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.playItem,linkePinaoItem, nil];
    
    
    if([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    

    [self addTheKeyView];
    [self addScrollView];
    [self addCountLabel];
    
    layOptions = [[SSLayoutOptions alloc] init];
    showingSinglePart = false;
    //	self.theScrollView.scrollDelegate = self.barControl;
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.theScrollView addGestureRecognizer:tapRecognizer];
    pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.theScrollView addGestureRecognizer:pressRecognizer];
    loadFileIndex = 0;
    self.cursorBarIndex = 0;
    [self loadNextFile:nil];
    //	sscore_version version = [SSScore version];
    //	self.versionLabel.text = [NSString stringWithFormat:@"SeeScore V%d.%02d", version.major, version.minor];
    // test setting of background colour programmatically
    self.theScrollView.backgroundColor = [UIColor colorWithRed:1.F green:1.F blue:0.95F alpha:1.F];
    
    NSLog(@"test -----");
    
    
    
    
    self.title = self.titleOfMusic;
    self.navigationController.navigationBar.barTintColor = ThemeColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    
}

//- (UIBarButtonItem *)
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
}

- (void)addTheKeyView
{
//    UIView *key_view_super_view = [[UIView alloc] init];
//    key_view_super_view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:key_view_super_view];
    self.key_view = [[UIView alloc] init];
    [self.view addSubview:self.key_view];
    self.key_view.backgroundColor = [UIColor whiteColor];
    [self.key_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@150);
        make.left.mas_equalTo(self.view.mas_left).with.offset(0);
        make.right.mas_equalTo(self.view.mas_right).with.offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(0);
    }];
    
//    self.key_view = [[UIView alloc] initWithFrame:CGRectMake(WhiteKeyWidth, 0, key_view_super_view.frame.size.width-2*WhiteKeyWidth, key_view_super_view.frame.size.height)];
//    [key_view_super_view addSubview:self.key_view];
//    self.key_view.backgroundColor = [UIColor whiteColor];
    
    [self generateButtons];
    self.sampler = [[YYSampler alloc] init];
    [self loadSamplerPath:2];
}
- (void)loadSamplerPath:(int)pathId {
    NSURL *presetURL;
    presetURL = [[NSBundle mainBundle] URLForResource:@"GeneralUser GS SoftSynth v1.44"
                                        withExtension:@"sf2"];
    [_sampler loadFromDLSOrSoundFont:presetURL withPatch:pathId];
}

- (void)addCountLabel
{
    self.countInLabel = [[UILabel alloc] init];
    [self.view addSubview:self.countInLabel];
    [self.countInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view.frame.size.width/2);
        make.height.mas_equalTo(self.view.frame.size.height/2);
    }];
    self.countInLabel.textAlignment = NSTextAlignmentCenter;
    self.countInLabel.font = [UIFont fontWithName:@"Georgia" size:300.0];
    self.countInLabel.textColor = [UIColor colorWithRed:1.0f green:0 blue:0 alpha:0.49];
    self.countInLabel.text = @"1";
    self.countInLabel.hidden = YES;
}
- (void)addScrollView
{
    self.theScrollView = [[SSScrollView alloc] init];
    self.theScrollView.showsHorizontalScrollIndicator = NO;
    self.theScrollView.showsVerticalScrollIndicator = YES;
    self.theScrollView.scrollEnabled = YES;
    self.theScrollView.bouncesZoom = YES;
    self.theScrollView.delegate = self;
    self.theScrollView.alpha = 1;
    [self.view addSubview:self.theScrollView];
    [self.theScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(0);
        make.left.mas_equalTo(self.view.mas_left).with.offset(0);
        make.right.mas_equalTo(self.view.mas_right).with.offset(0);
        make.bottom.mas_equalTo(self.key_view.mas_top).with.offset(0);
    }];
    self.theScrollView.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:0.95f alpha:1.0f];
    
}

- (void)back
{
    [self stopPlaying];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.theScrollView abortBackgroundProcessing:^{
        [self.theScrollView clearAll];
        score = nil;
    }];
}

-(void)dealloc
{
    [self clearAudioSession];
    score = nil;
}

-(SSScore*)score
{
    return score;
}

-(void)loadFile:(NSString*)filePath
{
    bool loadable = [self loadableFile:filePath];
    bool readable = [[NSFileManager defaultManager] isReadableFileAtPath:filePath];
    if (loadable && readable)
    {
        [self.theScrollView abortBackgroundProcessing:^{ // empty dispatch queues
            [self.theScrollView clearAll];
            score = nil;
            //[self.ignoreXMLLayoutSwitch setOn:NO animated:NO];
            //			self.stepper.value = 0;
            //			self.transposeLabel.text = [NSString stringWithFormat:@"%+d", 0];
            showingSinglePart = false;
            [showingParts removeAllObjects];
            self.cursorBarIndex = 0;
            //			SSLoadOptions *loadOptions = [[SSLoadOptions alloc] initWithKey:sscore_libkey];
            SSLoadOptions *loadOptions = [[SSLoadOptions alloc] init];
            loadOptions.checkxml = true;
            sscore_loaderror err;
            score = [SSScore scoreWithXMLFile:filePath options:loadOptions error:&err];
            
            if (score)
            {
                //				self.titleLabel.text = [filePath lastPathComponent];
                int numParts = score.numParts;
                showingParts = [NSMutableArray arrayWithCapacity:numParts];
                for (int i = 0; i < numParts; ++i)
                {
                    [showingParts addObject:[NSNumber numberWithBool:YES]];// display all parts
                }
                showingSinglePart = false;
                [self.theScrollView setupScore:score openParts:showingParts mag:kDefaultMagnification opt:layOptions];
                //				self.barControl.delegate = self.theScrollView;
                // show the required tempo slider
                //				if (score.scoreHasDefinedTempo)
                //				{
                ////					self.tempoSlider.minimumValue = kMinTempoScaling;
                ////					self.tempoSlider.maximumValue = kMaxTempoScaling;
                ////					self.tempoSlider.value = 1.0F;
                ////					sscore_pd_tempo tempo = score.tempoAtStart;
                ////					if (tempo.bpm > 0)
                ////						self.tempoLabel.text = [NSString stringWithFormat:@"%1.0f", self.tempoSlider.value * tempo.bpm];
                ////					else
                ////						self.tempoLabel.text = [NSString stringWithFormat:@"%1.1f", self.tempoSlider.value];
                //				}
                //				else
                //				{
                //					self.tempoSlider.minimumValue = kMinTempo;
                //					self.tempoSlider.maximumValue = kMaxTempo;
                //					self.tempoSlider.value = kDefaultTempo;
                //					self.tempoLabel.text = [NSString stringWithFormat:@"%d", (int)self.tempoSlider.value];
                //				}
            }
            else
            {
                //				switch (err.err)
                //				{
                //					case sscore_OutOfMemoryError:	NSLog(@"out of memory");break;
                //
                //					case sscore_XMLValidationError:
                //						NSLog(@"XML validation error line:%d col:%d %s", err.line, err.col, err.text?err.text:"");
                //						break;
                //
                //					case sscore_NoBarsInFileError:	NSLog(@"No bars in file error");break;
                //					case sscore_NoPartsError:		NSLog(@"NoParts Error"); break;
                //					default:
                //					case sscore_UnknownError:		NSLog(@"Unknown error");break;
                //				}
            }
        }];
    }
}

- (void)loadNextFile:(id)sender
{
//    	[self stopPlaying];
//    NSArray *sampleFileUrls = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"xml" subdirectory:@""];
//    NSURL *loadSampleUrl = sampleFileUrls[loadFileIndex];
//    NSString *localFilePath = [PlayViewController copyBundleFileToDocuments:loadSampleUrl]; // copy sample file to Documents directory
//    self.xmlFilePath = @"/Users/chentianyu/Library/Developer/CoreSimulator/De;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;p;pppppppp;;=lvices/3FF21769-E7A5-4FAA-9D7C-2E6413BD0A1E/data/Containers/Data/Application/43A225E9-85D4-4B75-AA33-C24E763D23D8/Documents/aaa.xml";
//    self.xmlFilePath= [[NSBundle mainBundle] pathForResource:@"aaa" ofType:@"xml"];
//    if ([self.xmlFilePath hasPrefix:@"file"]) {
//        NSLog(@"---");
//        self.xmlFilePath = [self.xmlFilePath substringFromIndex:7];
//    }
    [self loadFile:self.xmlFilePath];
    //	++loadFileIndex;
//    if (loadFileIndex >= sampleFileUrls.count)
//        loadFileIndex = 0;
}

-(void)tap
{
//    NSLog(@"tap");
	self.countInLabel.hidden = true;
	CGPoint p = [tapRecognizer locationInView:self.theScrollView];
	int barIndex = [self.theScrollView barIndexForPos:p];
	if (barIndex >= 0)
	{
		self.cursorBarIndex = barIndex;
		[self.theScrollView setCursorAtBar:barIndex
									  type:cursor_rect
									scroll:scroll_bar];
	}
	else
		[self.theScrollView hideCursor];

	if (barIndex >= 0)
	{
		int partIndex = [self.theScrollView partIndexForPos:p];
		NSLog(@"tap: partindex:%d barindex:%d", partIndex, barIndex);
#ifdef PrintXMLForTappedBar
		enum sscore_error err;
		NSString *xml = [score xmlForPart:partIndex bar:barIndex err:&err];
		if (xml.length > 0)
			NSLog(@"XML for bar %@", xml);
#endif
		if (synth && synth.isPlaying)
		{
			dispatch_time_t playRestartTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kStartPlayDelay * NSEC_PER_SEC));
			[synth setNextBarToPlay:barIndex at:playRestartTime];
		}
		else
		{
#ifdef ColourTappedItem
			SystemPoint sysPt = [self.theScrollView systemAtPos:p];
			SSSystem *sys = [self.theScrollView systemAtIndex:sysPt.systemIndex];
			if (sys)
			{
				NSArray *components = [sys hitTest:sysPt.posInSystem];
				if (components.count > 0)
				{
					unsigned elementTypes = 0;
					SSComponent *comp = [components objectAtIndex:0];
					switch (comp.type)
					{
						case sscore_comp_clef:		elementTypes |= sscore_dopt_colour_clef; break;
						case sscore_comp_timesig:	elementTypes |= sscore_dopt_colour_timesig; break;
						case sscore_comp_keysig:	elementTypes |= sscore_dopt_colour_keysig; break;
						case sscore_comp_notehead:	elementTypes |= sscore_dopt_colour_notehead; break;
						case sscore_comp_accidental: elementTypes |= sscore_dopt_colour_accidental; break;
						case sscore_comp_note_stem:	elementTypes |= sscore_dopt_colour_stem; break;
						case sscore_comp_note_dots:	elementTypes |= sscore_dopt_colour_dot; break;
						case sscore_comp_lyric:		elementTypes |= sscore_dopt_colour_lyric; break;
						case sscore_comp_beam:
						case sscore_comp_beamgroup:	elementTypes |= sscore_dopt_colour_beam; break;
						default:					elementTypes |= sscore_dopt_colour_all; break;
					}
					[self.theScrollView colourComponents:components colour:UIColor.cyanColor elementTypes:elementTypes];
					//  remove colour after 0.5s
					double delayInSeconds = 0.5;
					dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
					dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
						[self.theScrollView clearAllColouring];
					});
				}
			}
#endif
		}
	}
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//	[self stopPlaying];
//	if (popover)
//	{
//		[popover dismissPopoverAnimated:NO];
//		popover = nil;
//	}
//	if ([segue.identifier isEqualToString:@"info"])
//	{
//		InfoViewController *ivc = (InfoViewController*)segue.destinationViewController;
//		[ivc showHeaderInfo:score];
//	}
//	else if ([segue.identifier isEqualToString:@"settings"])
//	{
//		SettingsViewController *svc = (SettingsViewController*)segue.destinationViewController;
//		[svc setPartNames:!layOptions.hidePartNames barNumbers:!layOptions.hideBarNumbers dlg:self];
//	}
//	if ([segue isKindOfClass:UIStoryboardPopoverSegue.class])
//	{
//		popover = ((UIStoryboardPopoverSegue *)segue).popoverController;
//	}
//}
//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)stopPlaying
{
    if (synth && synth.isPlaying)
    {
        [synth reset];
        self.countInLabel.hidden = true;
        [self clearAudioSession];
    }
    isPlaying = false;
    [self resetRightBarButtonItems];

}

- (void)longPress:(id)sender {
    //	[self stopPlaying];
    //	if (pressRecognizer.state == UIGestureRecognizerStateEnded && score)
    //	{
    //		if (showingSinglePart) // flip to showing all parts
    //		{
    //			showingSinglePart = false;
    //			showingParts = [NSMutableArray array];
    //			for (int i = 0; i < score.numParts; ++i)
    //			{
    //				[showingParts addObject:[NSNumber numberWithBool:YES]];
    //			}
    //			[self.theScrollView displayParts:showingParts];
    //		}
    //		else // flip to showing a single part
    //		{
    //			CGPoint p = [pressRecognizer locationInView:self.theScrollView];
    //			int partIndex = [self.theScrollView partIndexForPos:p];
    //			if (partIndex >= 0)
    //			{
    //				assert(partIndex < score.numParts);
    //				showingParts = [NSMutableArray array];
    //				for (int i = 0; i < score.numParts; ++i)
    //				{
    //					[showingParts addObject:[NSNumber numberWithBool:(i == partIndex)]];
    //				}
    //				[self.theScrollView displayParts:showingParts];
    //				showingSinglePart = true;
    //			}
    //		}
    //	}
}

- (void)transpose:(id)sender
{
    //	[self stopPlaying];
    //	UIStepper *stepper = (UIStepper*)sender;
    //	if (stepper.value < -8) // demonstrate change treble clefs to bass clef for transpose more than 8 semitones down
    //	{
    //		sscore_tr_clefchangedef clefchange;
    //		memset(&clefchange, 0, sizeof(clefchange));
    //		clefchange.num = 1;
    //		clefchange.staffchange[0].partindex = sscore_tr_kAllPartsPartIndex;
    //		clefchange.staffchange[0].staffindex = sscore_tr_kAllStaffsStaffIndex;
    //		clefchange.staffchange[0].conv.fromclef = sscore_tr_trebleclef;
    //		clefchange.staffchange[0].conv.toclef = sscore_tr_bassclef;
    //		sscore_tr_setclefchange(score.rawscore, &clefchange);
    //	}
    //	else
    //		sscore_tr_clearclefchange(score.rawscore);
    //	[score setTranspose:stepper.value];
    //	self.transposeLabel.text = [NSString stringWithFormat:@"%+d", score.transpose];
    //	[self.theScrollView setLayoutOptions:layOptions];
}

// return xpos of centre of notehead of note or 0
-(float)noteXPos:(SSPDNote*)note
{
    SSSystem *system = [self.theScrollView systemContainingBarIndex:note.startBarIndex];
    if (system)
    {
        NSArray *comps = [system componentsForItem:note.item_h];
        // find centre of notehead
        for (SSComponent *comp in comps)
        {
            if (comp.type == sscore_comp_notehead)
            {
                return comp.rect.origin.x + comp.rect.size.width / 2;
            }
        }
        return 0;
    }
    else
        return 0;
}

-(void)moveNoteCursor:(NSArray*)notes
{
    for (SSPDPartNote *note in notes) // normally this will not need to iterate over the whole chord, but will exit as soon as it has a valid xpos
    {
        if (note.note.start >= 0) // ignore cross-bar tied notes
        {
            float xpos = [self noteXPos:note.note];
            if (xpos > 0) // noteXPos returns 0 if the note isn't found in the layout (it might be in a part which is not shown)
            {
                [self.theScrollView setCursorAtXpos:xpos barIndex:note.note.startBarIndex scroll:scroll_bar];
                return; // abandon iteration
            }
        }
    }
}

-(int)numBars
{
    return score.numBars;
}
//
-(void)colourPDNotes:(NSArray*)notes
{
    UIColor *kPlayedNoteColour = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];// green
    [self.theScrollView colourPDNotes:notes colour:kPlayedNoteColour];
}
//
//
-(void)displaynotes:(SSPData*) playData
{
#ifdef PrintPlayData
    for (SSPDBar *bar in playData.bars)
    {
        NSLog(@"bar:%d", bar.index);
        for (int partIndex = 0; partIndex < score.numParts; ++partIndex)
        {
            SSPDPart *part = [bar part:partIndex];
            for (SSPDNote *note in part.notes)
            {
                NSLog(@"part %d %s pitch:%d startbar:%d start:%dms duration:%dms at x=%1.0f",
                      partIndex, note.grace?"grace":"note",
                      note.midiPitch, note.startBarIndex,
                      note.start, note.duration,
                      [self noteXPos:note]);
            }
        }
    }
#endif
}

-(void)error:(NSString*)message
{
    //	self.warningLabel.text = message;
    //	self.warningLabel.hidden = (message.length == 0);
}

- (void)resetRightBarButtonItems
{
    if (isPlaying) {    //如果正在播放
        self.playItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"slcd_stop"] style:UIBarButtonItemStylePlain target:self action:@selector(stopPlaying)];
    }else{
        self.playItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"slcd_play"] style:UIBarButtonItemStylePlain target:self action:@selector(playXML)];
    }
    NSArray *barButtonItems = [NSArray arrayWithObjects:self.playItem,linkePinaoItem, nil];
    [self.navigationItem setRightBarButtonItems:barButtonItems animated:YES];
        
    
}

- (void)playXML {
    //	[self error:@""]; // clear any error message
    	self.countInLabel.hidden = true;
//    playItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"slcd_stop"] style:UIBarButtonItemStylePlain target:self action:@selector(stopPlaying)];
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:playItem,linkePinaoItem, nil];
//    if (isPlaying)
//    {
//        self.playItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"slcd_stop"] style:UIBarButtonItemStylePlain target:self action:@selector(stopPlaying)];
//        isPlaying = false;
//    }else{
        isPlaying = true;
        [self resetRightBarButtonItems];
//    }
    
    
    if (score)
    {
#ifdef ColourPlayedNotes
        [self.theScrollView clearAllColouring];
#endif
        if (!synth)
        {
            synth = [SSSynth createSynth:self score:score];
            if (synth)
            {
                instrumentId = [synth addSampledInstrument:&kPianoSamplesInfo];
                metronomeInstrumentId = [synth addSynthesizedInstrument:&kTick1Info];
            }
        }
        if (synth)
        {
            SSPData *playData = [SSPData createPlayDataFromScore:score tempo:self];
            if (synth.isPlaying)
            {
                [synth reset]; // stop playing if playing
            }
            else // start playing if not playing
            {
                if ([self setupAudioSession])
                {
                    // display notes to play in console
                    [self displaynotes:playData];
                    // setup bar change notification to move cursor
                    int cursorAnimationTime_ms = [CATransaction animationDuration]*1000;
                    //[self.theScrollView setCursorAtBar:self.cursorBarIndex type:cursor_line scroll:scroll_bar];
#ifdef UseNoteCursor
                    [synth setNoteHandler:[[NoteHandler alloc] initWith:self] delay:-cursorAnimationTime_ms];
#endif
                    [synth setBarChangeHandler:[[BarChangeHandler alloc] initWith:self] delay:-cursorAnimationTime_ms];
                    [synth setEndHandler:[[EndHandler alloc] initWith:self] delay:0];
                    [synth setBeatHandler:[[BeatHandler alloc] initWith:self] delay:0];
                    enum sscore_error err = [synth setup:playData];
                    if (err == sscore_NoError)
                    {
                        double delayInSeconds = 2.0;
                        dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        static const bool countIn = true;
                        err = [synth startAt:startTime bar:self.cursorBarIndex countIn:countIn]; // start synth
                    }
                    if (err == sscore_UnlicensedFunctionError)
                    {
                        [self error:@"synth license expired!"];
                    }
                    else if (err != sscore_NoError)
                    {
                        [self error:@"synth failed to start!"];
                    }
                }
            }
        }
        else
            NSLog(@"No licence for synth");
    }
}


- (void)tempoChanged:(id)sender {
    //	UISlider *slider = (UISlider*)sender;
    //	if (score)
    //	{
    //		if (score.scoreHasDefinedTempo)
    //		{
    //			sscore_pd_tempo tempo = score.tempoAtStart;
    //			if (tempo.bpm > 0)
    //				self.tempoLabel.text = [NSString stringWithFormat:@"%1.0f", slider.value * tempo.bpm];
    //			else
    //				self.tempoLabel.text = [NSString stringWithFormat:@"%1.1f", slider.value];
    //		}
    //		else
    //			self.tempoLabel.text = [NSString stringWithFormat:@"%d", (int)slider.value];
    //
    //		// we have to do this to avoid the scroll view freezing after setting the tempo label text!
    //		CGPoint p = self.theScrollView.contentOffset;
    //		p.y += 1;
    //		self.theScrollView.contentOffset = p;
    //
    //		if (synth && synth.isPlaying)
    //		{
    //			dispatch_time_t playRestartTime = dispatch_time(DISPATCH_TIME_NOW, kRestartDelay*NSEC_PER_SEC);
    //			[synth updateTempoAt:playRestartTime];
    //		}
    //	}
}

- (void)metronomeSwitched:(id)sender {
    //	if (synth && synth.isPlaying)
    //	{
    //		[synth changedControls];
    //	}
}

- (void)switchInstrument:(id)sender {
    //	if (synth && synth.isPlaying)
    //	{
    //		[synth reset];
    //	}
}

- (void)switchIgnoreLayout:(id)sender {
    //	layOptions.ignoreXMLPositions = ((UISwitch*)sender).on;
    //	[self.theScrollView setLayoutOptions:layOptions];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //[self.theScrollView setLayoutOptions:layOptions];
}

//@protocol ChangeSettingsProtocol <NSObject>
//
//-(void)showPartNames:(bool)pn
//{
////	layOptions.hidePartNames = !pn;
////	[self.theScrollView setLayoutOptions:layOptions];
//}
//
//-(void)showBarNumbers:(bool)bn
//{
//	layOptions.hideBarNumbers = !bn;
//	[self.theScrollView setLayoutOptions:layOptions];
//}

//@end

//@protocol SSSyControls
/*
 SynthControlsImpl is the interface between the synth and the UI elements which control
 instruments for parts and metronome
 */
-(bool)partEnabled:(int)partIndex
{
    return true;
}
//
-(unsigned)partInstrument:(int)partIndex
{
    return instrumentId;
}

-(float)partVolume:(int)partIndex
{
    return 1.0;
}
//
-(bool)metronomeEnabled
{
    return true;
}

-(unsigned)metronomeInstrument
{
    return metronomeInstrumentId;
}

-(float)metronomeVolume
{
    return 1.0;
}
//@end

//@protocol SSUTempo <NSObject>

-(int)bpm
{
    return limit(100, kMinTempo, kMaxTempo);
}

-(float)tempoScaling
{
    return limit(100, kMinTempoScaling, kMaxTempoScaling);
}
//
//@end


#pragma mark - 连接钢琴
- (void)linkPiano
{
    
}



//
#pragma mark - the Key
- (void)generateButtons {
    
    //    int whiteWidth = 56;
    //    int whiteHeight = 400;
    //    int blackWidth = 40;
    //    int blackHeight = 270;
    
    // Middle C is 60 (MIDI note C4)
    int startNote = 21;
    int totalNote = 88; //total 88 keyboards
    
    NSMutableArray *whiteBtns = [NSMutableArray array];
    NSMutableArray *blackBtns = [NSMutableArray array];
    
    for (int note = startNote; note < startNote + totalNote; note++) {  //21~109=88(21+88=109)
        int octave = note / 12 - 1; //八度，判断是第几个八度，共0~7个八度，8个八度
        int indexInOctave = note % 12;  //八度中的12个中的第几个
        int indexKbdInOctave = -1;  //
        BOOL isWhite = YES;
        switch (indexInOctave) {
            case 0: case 2: case 4: case 5: case 7: case 9: case 11:    //白键
                indexKbdInOctave = (indexInOctave + 1) / 2;
                break;
            default:
                indexKbdInOctave = indexInOctave / 2;   //黑键
                isWhite = NO;
        }
        
        //keyboard offset
//        NSLog(@"%d",WhiteKeyHeight);
//        NSLog(@"%f",WhiteKeyWidth);
//        NSLog(@"%f",BlackKeyHeight);
//        NSLog(@"%f",BlackKeyWidth);
        
        
        int x = (octave * 7 + indexKbdInOctave - 5) * WhiteKeyWidth + (isWhite ? 0 : WhiteKeyWidth - BlackKeyWidth / 2);
        CGRect rect = CGRectMake(x+WhiteKeyWidth, 0, isWhite ? WhiteKeyWidth : BlackKeyWidth, isWhite ? WhiteKeyHeight : BlackKeyHeight);
        UIButton *btn = [self getBtn:rect isWhite:isWhite tag:note];
        [isWhite ? whiteBtns : blackBtns addObject:btn];
    }
    
    for (UIButton *btn in whiteBtns) {
        [self.key_view addSubview:btn];
    }
    for (UIButton *btn in blackBtns) {
        [self.key_view addSubview:btn];
    }
    
    
    UIView *frontPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WhiteKeyWidth, WhiteKeyHeight)];
    frontPaddingView.backgroundColor = [UIColor blackColor];
    [self.key_view addSubview:frontPaddingView];
    
    UIView *endPaddingView = [[UIView alloc] initWithFrame:CGRectMake(((UIButton *)whiteBtns.lastObject).frame.origin.x+WhiteKeyWidth, 0, WhiteKeyWidth, WhiteKeyHeight)];
    endPaddingView.backgroundColor = [UIColor blackColor];
    [self.key_view addSubview:endPaddingView];
    
//    _kbdScrollView.contentSize = CGSizeMake(((UIButton *)whiteBtns.lastObject).frame.origin.x + WhiteKeyWidth, _kbdScrollView.frame.size.height);
}

- (UIButton *)getBtn:(CGRect)rect isWhite:(BOOL)isWhite tag:(int)tag {
    UIButton *btn;
    if (!isWhite) {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[self getImageFromColor:[UIColor blackColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self getImageFromColor:[UIColor colorWithRed:218/255.0 green:100/255.0 blue:99/255.0f alpha:1.0f]] forState:UIControlStateHighlighted];
    } else {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.borderWidth = 0.5f;
        btn.layer.borderColor = [[UIColor blackColor] CGColor];
        [btn setBackgroundImage:[self getImageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self getImageFromColor:[UIColor colorWithRed:218/255.0 green:100/255.0 blue:99/255.0f alpha:1.0f]] forState:UIControlStateHighlighted];
    }
    btn.layer.masksToBounds = YES;

    btn.frame = rect;
    btn.tag = tag;
    [btn addTarget:self action:@selector(triggleOn:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(triggleOff:) forControlEvents:UIControlEventTouchUpInside];
    [btn addTarget:self action:@selector(triggleOff:) forControlEvents:UIControlEventTouchCancel];
    [btn addTarget:self action:@selector(triggleOff:) forControlEvents:UIControlEventTouchDragOutside];
    return btn;
}

- (void)triggleOn:(UIButton *)btn {
    [_sampler triggerNote:btn.tag isOn:YES];
}

- (void)triggleOff:(UIButton *)btn {
    [_sampler triggerNote:btn.tag isOn:NO];
}
- (UIImage *)getImageFromColor:(UIColor *)color {
    CGSize imageSize = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImg;
}
@end

//
//  SSScrollView
//  SeeScore for iOS
//
// No warranty is made as to the suitability of this for any purpose
//
// This is the main scrollable view which displays a MusicXML file

#import <UIKit/UIKit.h>

//#import "SSBarControlProtocol.h"
//#import "SSUpdateScrollProtocol.h"

#import <SeeScoreLib/SSScore.h>

/*!
 * @protocol SSUpdateProtocol
 * @abstract for notification of clear systems and add system
 */
@protocol SSUpdateProtocol

/*!
 * @method cleared
 * @abstract called (on main queue) on clear of systems (eg on pinch)
 */
-(void)cleared;

/*!
 * @method newLayout
 * @abstract called (on main queue) when a new layout of the SSScrollView is complete.
 * @discussion This can be called whenever a new system is shown, such as when scrolling
 */
-(void)newLayout;

@end

/*!
 * @interface SSScrollView
 * @abstract A scrollable view to display a MusicXML score as a vertical sequence of rectangular system views
 */
@interface SSScrollView : UIScrollView //<SSBarControlProtocol>
{
    
    UIView *containedView;
}

/*!
 * @property magnification
 * @abstract the current magnification. Pinch zoom changes this
 */
@property (nonatomic) float magnification;

/*!
 * @property startBarIndex
 * @abstract index of the bar wholly visible at the top left of the window
 */
@property (nonatomic,readonly) int startBarIndex;

/*!
 * @property scrollDelegate
 * @abstract for SSBarControl update
 */
//@property (nonatomic,assign) id<SSUpdateScrollProtocol> scrollDelegate;

/*!
 * @property isProcessing
 * @abstract true while processing layout
 */
@property (readonly) bool isProcessing;

/*!
 * @property updateDelegate
 * @abstract for notification of change to number of systems displayed
 */
//@property (nonatomic,assign) id<SSUpdateProtocol> updateDelegate;

/*!
 * @method initWithFrame:
 * @abstract initialise this SSScrollView
 * @param aRect the frame of this UIView
 */
- (instancetype)initWithFrame:(CGRect)aRect;

/*!
 * @method setupScore:
 * @abstract setup the score
 * @param score the score
 * @param parts array indexed by part. Element is boolean NSNumber. True to display part, false to hide it
 * @param mag the magnification (1.0 is nominal standard size, ie approximately 7mm staff height). Pinch zoom changes this
 * @param options the layout options
 */
-(void)setupScore:(SSScore*)score
        openParts:(NSArray*)parts
              mag:(float)mag
              opt:(SSLayoutOptions *)options;

/*!
 * @method displayParts
 * @abstract set which parts to display
 * @param parts array indexed by part. Array element is boolean NSNumber. True to display part, false to hide it
 */
-(void)displayParts:(NSArray*)parts;

/*!
 * @method setLayoutOptions:
 * @abstract set new layout options, triggers a relayout
 */
-(void)setLayoutOptions:(SSLayoutOptions*)layOptions;

/*!
 * @typedef handler_t
 * @abstract a generic handler function
 */
typedef void (^handler_t)(void);

/*!
 * @method abortBackgroundProcessing:
 * @abstract abort all multi-threaded (layout and draw) action. Safe to call when no activity
 * @discussion completionHandler is called on main queue when all activity is complete and queues are empty
 */
-(void)abortBackgroundProcessing:(handler_t)completionHandler;

/*!
 * @function clearAll
 * @abstract clear everything - need to call setupScore after calling this
 */
-(void)clearAll;

// clear and relayout systems
-(void)relayout;

// return YES if the first system in the score is currently (fully) displayed
-(BOOL)isDisplayingStart;

// return YES if the last system in the score is currently (fully) displayed
-(BOOL)isDisplayingEnd;

// return true if the entire score is currently visible on the screen (not scrollable in this case)
-(BOOL)isDisplayingWhole;

// return the bar index at the specified point
-(int)barIndexForPos:(CGPoint)pos;

// return the part index at the specified point
-(int)partIndexForPos:(CGPoint)pos;

/*!
 * @struct SystemPoint
 * @abstract return value from systemAtYPos
 */
typedef struct SystemPoint
{
    // The index of this system
    int systemIndex;
    
    // the position in the coordinates of the system
    CGPoint posInSystem;
    
    // the 0-based part index
    int partIndex;
    
    // the 0-based bar index
    int barIndex;
    
} SystemPoint;

/*!
 * @method systemAtPos
 * @abstract return the system index and location within it for a point in the SSScrollView
 * @discussion use systemAtIndex: to get the SSSystem from the systemIndex
 * @param p the point within the SSScrollView
 * @return the SystemPoint defining the system index, and part and bar indices at p
 */
-(SystemPoint)systemAtPos:(CGPoint)p;

/*!
 * @method systemAtIndex
 * @return return the system at the given index (0-based, top to bottom)
 */
-(SSSystem*)systemAtIndex:(int)index;

/*!
 * @method systemContainingBarIndex
 * @return the system containing the given 0-based bar index
 */
-(SSSystem*)systemContainingBarIndex:(int)barIndex;

/*!
 * @method numSystems
 * @abstract return the number of systems currently displayed
 */
-(int)numSystems;

/*!
 * @method systemRect
 * @abstract the bounds of a given system
 * @return CGRect outline of system by index [0..numSystems-1]
 */
-(CGRect)systemRect:(int)systemIndex;

/*!
 * @enum CursorType_e
 * @abstract define the type of cursor, vertical line or rectangle around the bar
 */
enum CursorType_e {cursor_line, cursor_rect};

/*!
 * @enum ScrollType_e
 * @abstract define the scroll required when setting the cursor
 * @discussion scroll_off is no scroll, scroll_system to scroll to centre the system containing the bar,
 * scroll_bar (smoother than scroll-system) is set to minimise the scroll distance between adjacent bars in
 * different systems
 */
enum ScrollType_e {scroll_off, scroll_system, scroll_bar};

/*!
 * @method setCursorAtBar
 * @abstract set the cursor at the given bar
 * @param barIndex the 0-based bar index in which to set the cursor
 * @param type the type of cursor (box or vertical line)
 * @param scroll the type of scroll to reveal the given bar or no scroll
 */
-(void)setCursorAtBar:(int)barIndex
                 type:(enum CursorType_e)type
               scroll:(enum ScrollType_e)scroll;

/*!
 * @method setCursorAtXpos
 * @abstract set the vertical line cursor to an x position within the system containing the given bar index
 * @param xpos the x position within the system to set the cursor
 * @param barIndex the bar in which the cursor is displayed
 * @param scroll the type of scroll to reveal the given bar or no scroll
 */
-(void)setCursorAtXpos:(float)xpos
              barIndex:(int)barIndex
                scroll:(enum ScrollType_e)scroll;

/*!
 * @method hideCursor
 * @abstract hide the cursor
 */
-(void)hideCursor;

/*!
 * @method scroll
 * @abstract scroll the display by a percentage of the screen height from the current position
 * @param percent a percentage of the screen height,  +100 to scroll down 1 page, -100 to scroll up 1 page
 */
-(void)scroll:(int)percent;

/*!
 * @method didRotate
 * @abstract called to notify a screen orientation change
 */
-(void)didRotate;

/*!
 * @method enablePinch
 * @abstract enable pinch-zoom
 */
-(void)enablePinch;

/*!
 * @method disablePinch
 * @abstract disable pinch-zoom
 */
-(void)disablePinch;

//
/*!
 * @method colourPDNotes
 * @abstract colour the given set of notes in the given system
 * @param notes array elements are of type SSPDNote*
 * @param colour the colour to use for the components
 */
-(void)colourPDNotes:(NSArray*)notes colour:(UIColor*)colour;

/*!
 * @method colourComponents
 * @abstract colour the components with the given colour
 * @param components array elements are of type SSComponent*
 * @param colour the colour to use for the components
 * @param elementTypes use sscore_dopt_colour_render_flags_e to define exactly what part of an item should be coloured
 */
-(void)colourComponents:(NSArray*)components colour:(UIColor *)colour elementTypes:(unsigned)elementTypes;

/*!
 * @method clearColouringForBarRange
 * @abstract clear all draw option colouring setup by setDrawOptions in specified bar range
 * @discussion requires contents-detail licence
 */
-(void)clearColouringForBarRange:(const sscore_barrange*)barrange;

/*!
 * @method clearAllColouring
 * @abstract clear all draw option colouring setup by setDrawOptions
 */
-(void)clearAllColouring;


@end

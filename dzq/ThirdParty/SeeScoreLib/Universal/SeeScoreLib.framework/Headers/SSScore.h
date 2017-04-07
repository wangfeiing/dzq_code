//
//  SSScore.h
//  SeeScoreLib
//
//  Copyright (c) 2015 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

/*!
 @header	SSScore.h
 @abstract	SSScore is the main interface to SeeScore.
 */

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#include "sscore.h"
#include "sscore_contents.h"
#include "sscore_playdata.h"

@class SSSystem;
@class SSGraphics;


/*!
 @interface SSLoadOptions
 @abstract options for loading the XML file is a parameter to scoreWithXMLData and scoreWithXMLFile
 */
@interface SSLoadOptions : NSObject

/*! set to point to the key which allows access to locked features
 */
@property const sscore_libkeytype *key;

/*! set to load compressed .mxl data (automatic when loading a .mxl file)
 */
@property bool compressed;

/*! set to return information about non-fatal faults (warnings) in the XML file in err.warn[]
 */
@property bool checkxml;

/*!
 */
-(instancetype)initWithKey:(const sscore_libkeytype *)key;

@end


/*!
 @interface SSPartName
 @abstract full and abbreviated names for a part defined in XML
 */
@interface SSPartName : NSObject

/*!
 @property abbreviated_name
 @abstract the abbreviated part name
 */
@property NSString *abbreviated_name;

/*!
 @property full_name
 @abstract the full part name
 */
@property NSString *full_name;

@end


/*!
 @interface SSDisplayedItem
 @abstract information about a displayed item (note,rest,clef etc) in the score
 */
@interface SSDisplayedItem : NSObject

/*!
 @property type
 @abstract type the type of the item
 */
@property enum sscore_item_type_e type;

/*!
 @property staff
 @abstract the index of the staff within the part (0 or 1) if there are 2 staves
 */
@property int staff;

/*!
 @property item_h
 @abstract the unique handle for the item
 */
@property sscore_item_handle item_h;

@end


/*!
 @interface SSTimedItem
 @abstract timing information about a displayed item (note,rest,clef etc) in the score
 */
@interface SSTimedItem : SSDisplayedItem

/*!
 @property start
 @abstract the start time of the item within its bar in divisions
 */
@property int start;

/*!
 @property duration
 @abstract the duration time of a note or rest in divisions (0 for all other item types)
 */
@property int duration;

@end


/*!
 @interface SSNoteItem
 @abstract detailed information about a displayed note in the score
 */
@interface SSNoteItem : SSTimedItem

/*!
 @property midipitch
 @abstract The MIDI pitch of this note ie 60 = C4; 0 => rest
 */
@property int midipitch;

/*!
 @property noteType
 @abstract The value of the note 2 = minim, 4 = crochet etc.
 */
@property int noteType;

/*!
 @property numdots
 @abstract number of dots on the note. 1 if dotted, 2 if double-dotted
 */
@property int numdots;

/*!
 @property accidentals
 @abstract any accidentals defined ie +1 = 1 sharp, -1 = 1 flat etc.
 */
@property int accidentals;

/*!
 @property ischord
 @abstract True if this is a chord note (not set for first note of chord)
 */
@property bool ischord;

/*!
 @property notations
 @abstract array of sscore_notations_type_e
 */
@property NSArray *notations;

/*!
 @property tied
 @abstract If this is a tied note this contains information about the tie
 */
@property sscore_tied tied;

/*!
 @property grace
 @abstract true if this is a grace note
 */
@property bool grace;
@end


/*!
 @interface SSClefItem
 @abstract detailed information about a clef
 */
@interface SSClefItem : SSTimedItem

/*!
 @property clef
 @abstract the type of the clef
 */
@property enum sscore_clef_type_e clef;
@end


/*!
 @interface SSTimeSigItem
 @abstract detailed information about a (conventional) time signature
 */
@interface SSTimeSigItem : SSTimedItem

/*!
 @property beats
 @abstract the number at the top of the time signature
 */
@property int beats;

/*!
 @property beatType
 @abstract the number at the bottom
 */
@property int beatType;
@end


/*!
 @interface SSKeySigItem
 @abstract detailed information about a key signature
 */
@interface SSKeySigItem : SSTimedItem

/*!
 @property fifths
 @abstract if -ve is number of flats, +ve is number of sharps, 0 is no flats or sharps
 */
@property int fifths;
@end


/*!
 @interface SSDirectionItem
 @abstract detailed information about a direction
 */
@interface SSDirectionItem : SSTimedItem

/*!
 @property directions
 @abstract array of int = enum sscore_direction_type
 */
@property NSArray *directions;

/*!
 @property hassound
 @abstract true if info in sound
 */
@property bool hassound;

/*!
 @property sound
 @abstract defined if hassound = true
 */
@property sscore_sound sound;
@end


/*!
 @interface SSBarGroup
 @abstract detailed information about a group of items in a bar
 */
@interface SSBarGroup : NSObject

/*!
 @property partindex
 @abstract the 0-based index of the part containing this group
 */
@property int partindex;

/*!
 @property barindex
 @abstract the 0-based index of the bar containing this group
 */
@property int barindex;

/*!
 @property items
 @abstract the array of all items (derived from SSTimedItem) in the bar
 */
@property NSArray *items;

/*!
 @property divisions
 @abstract the divisions per quarter note (crotchet) in the bar
 */
@property int divisions;

/*!
 @property divisions_in_bar
 @abstract the total number of divisions in the bar
 */
@property int divisions_in_bar;

@end


/*!
 @interface SSHeader
 @abstract the MusicXML header containing info about the score - title, composer etc.
 */
@interface SSHeader : NSObject

/*!
 @property work_number
 @abstract the work_number in the MusicXML header
 */
@property  NSString *work_number;

/*!
 @property work_title
 @abstract the work_title in the MusicXML header
 */
@property  NSString *work_title;

/*!
 @property movement_number
 @abstract the movement_number in the MusicXML header
 */
@property  NSString *movement_number;

/*!
 @property movement_title
 @abstract the movement_title in the MusicXML header
 */
@property  NSString *movement_title;

/*!
 @property composer
 @abstract the composer of this work in the MusicXML header
 */
@property  NSString *composer;

/*!
 @property lyricist
 @abstract the lyricist of this work in the MusicXML header
 */
@property  NSString *lyricist;

/*!
 @property arranger
 @abstract the arranger of this work in the MusicXML header
 */
@property  NSString *arranger;

/*!
 @property credit_words
 @abstract array of NSString
 */
@property  NSArray *credit_words;

/*!
 @property parts
 @abstract array of SSPartName
 */
@property  NSArray *parts;

@end


/*!
 @interface SSLayoutOptions
 @abstract options for layout of System(s)
 */
@interface SSLayoutOptions : NSObject

/*!
 @property hideBarNumbers
 @abstract set if the bar numbers should not be displayed
 */
@property bool hideBarNumbers;

/*!
 @property hidePartNames
 @abstract set if the part names should not be displayed
 */
@property bool hidePartNames;

/*!
 @property simplifyHarmonyEnharmonicSpelling
 @abstract set this flag so F-double-sharp appears in a harmony as G
 */
@property bool simplifyHarmonyEnharmonicSpelling;

/*!
 @property ignoreXMLPositions
 @abstract set if the default-x, default-y, relative-x, relative-y values in the XML should be ignored
 */
@property bool ignoreXMLPositions;
@end


/*!
 @typedef sslayout_callback_block_t
 @abstract definition of the block which is called on adding a system in layoutWithWidth:
 */
typedef bool (^sslayout_callback_block_t)(SSSystem*);


/*!
@interface SSScore
@abstract the main Objective-C interface to SeeScore
@discussion The main class of the SeeScore API, this encapsulates all information about the score loaded from a MusicXML file. You will
 find it more convenient and much simpler to use this interface from your Objective-C app rather than the pure C interface in
 sscore.h etc.
 <p>
 loadXMLFile() or loadXMLData() should be used to load a file and create a SScore object
 <p>
 layout() should be called on a background thread to create a layout, and SSystems are generated sequentially from
 the top and can be added to the display as they are produced, but you should ensure you do any UI operations on the foreground
 thread (using dispatch_after). This is all handled by SSView supplied as part of the sample app
 <p>
 numBars, numParts, getHeader(), getPartNameForPart(), getBarNumberForIndex() all return basic information about the score.
 <p>
 setTranspose() allows you to transpose the score.
 <p>
 Other methods return detailed information about items in the score and require a contents or contents-detail licence.

 */
@interface SSScore : NSObject

/*!
@property rawscore
@abstract the low level C API to the score
 */
@property (readonly) sscore* rawscore;

/*!
@property numParts
@abstract the total number of parts in the score.
 */
@property (readonly) int numParts;

/*!
@property numBars
@abstract the total number of bars in the score.
 */
@property (readonly) int numBars;

/*!
@property header
@abstract the MusicXML header information
 */
@property (readonly) SSHeader *header;

/*!
@property scoreHasDefinedTempo
@abstract true if there is a metronome or sound tempo defined in the XML
 */
@property (readonly) bool scoreHasDefinedTempo;

/*!
@method version
@abstract the version of the SeeScore library
@return the version hi.lo
 */
+(sscore_version)version;

/*!
 @method headerFromXMLFile
 @abstract get the MusicXML header information quickly from the file without loading the whole file
 @return the header strings only (empty credits/parts). Return nil on error
 */
+(SSHeader*)headerFromXMLFile:(NSString*)filePath;

/*!
 @method scoreWithXMLData:
 @abstract load the XML in-memory data and return a SSScore or null if error
 Any warnings are returned in err.warn[] if SSLoadOptions.checkxml was set
 @discussion Swift signature SSScore(XMLData:data : NSData, options: loadOptions : SSLoadOptions, error: err : sscore_loaderror)
 @param data the NSData containing the MusicXML
 @param loadOptions the options for load including the licence key
 @param err pointer to a struct to be filled with the errors and warnings
 @return the SSScore or NULL if error with the error returned in err
 */
+(SSScore*)scoreWithXMLData:(NSData *)data
					options:(SSLoadOptions*)loadOptions
					  error:(sscore_loaderror*)err;

/*!
 @method scoreWithXMLFile:
 @abstract load the XML file and return a SSScore or null if error
 Any warnings are returned in err.warn[] if SSLoadOptions.checkxml was set
 @discussion Swift signature SSScore(XMLFile: xmlFilePath : String, options: loadOptions : SSLoadOptions, error: err : sscore_loaderror)
 @param filePath the full pathname of the file to load
 @param loadOptions the options for load including the licence key
 @param err pointer to a struct to be filled with the errors and warnings
 @return the SSScore or NULL if error with the error returned in err
 */
+(SSScore*)scoreWithXMLFile:(NSString *)filePath
					options:(SSLoadOptions*)loadOptions
					  error:(sscore_loaderror*)err;

/*!
 @method partNameForPart:
 @abstract return the name for the part.
 @param partindex the index of the part [0..numparts-1]
 @return PartName (full + abbreviated)
 */
-(SSPartName*)partNameForPart:(int)partindex;

/*!
 @method instrumentNameForPart:
 @abstract return the name for the instrument for the part.
 @discussion This is often not defined in the XML, in which case the part name is probably the instrument name
 @param partindex the index of the part [0..numparts-1]
 @return instrument name, empty if not defined
 */
-(NSString*)instrumentNameForPart:(int)partindex;

/*!
 @method updateHeader
 @abstract change a field in the header
 @param fieldId defines which field to change
 @param val defines the new value
 */
-(void)updateHeader:(enum sscore_header_fieldid)fieldId val:(NSString*)val;

/*!
 @method saveToFile
 @abstract save the score to a MusicXML file
 @param filePath the pathname of the file to save
 @return any error
 */
-(enum sscore_error)saveToFile:(NSString*)filePath;

/*!
 @method layout1SystemWithContext:
 @abstract Layout a single system with a single part.
 @discussion You specify a start bar index and a width and magnification and it will display
 as many bars as will fit into this width, up to a limit of maxBars if > 0.
 <p>Useful for display of individual parts for part selection.
 @param ctx a graphics context only for measurement of text (eg a bitmap context)
 @param startbarindex the index of the first bar in the system (usually 0)
 @param maxBars the maximum number of bars to include in the system, 0 to fit as  many as possible
 @param width the width to display the system within
 @param max_height the maximum height available to display the system to control truncation. =0 for no truncation
 @param partindex the index of the single part to layout [0..numparts-1]
 @param magnification the scale at which to display this (1.0 for normal size)
 @return the system
 */
-(SSSystem*)layout1SystemWithContext:(CGContextRef)ctx
							startbar:(int)startbarindex
							 maxBars:(int)maxBars
							   width:(float)width
						   maxheight:(float)max_height
								part:(int)partindex
					   magnification:(float)magnification;

/*!
 @method layoutWithContext:
 @abstract Layout a set of systems and return them through a callback function.
 @discussion This should be called on a background thread and it will call cb for each system laid out,
 from top to bottom. cb will normally add the system to a list and schedule an update on the
 foreground (gui event dispatch) thread to allow the UI to remain active during concurrent layout.
 cb can return false to abort the layout.
 @param ctx a graphics context only for measurement of text (eg a bitmap context)
 @param width the width available to display the systems in screen coordinates
 @param max_system_height the maximum height available to display each system to control truncation. =0 for no truncation
 @param parts array of boolean, 1 per part, true to include, false to exclude
 @param magnification the scale at which to display this (1.0 is default)
 @param layoutOptions the SSLayoutOptions
 @param callback the callback function to be called for each completed system
 */
-(enum sscore_error)layoutWithContext:(CGContextRef)ctx
								width:(float)width
							maxheight:(float)max_system_height
								parts:(NSArray*)parts
						magnification:(float)magnification
							  options:(SSLayoutOptions*)layoutOptions
							 callback:(sslayout_callback_block_t)callback;

/*!
 @method barNumberForIndex:
 @abstract Get the bar number (String) given the index.
 @param barindex integer index [0..numBars-1]
 @return the score-defined number String (usually "1" for index 0)
 */
-(NSString*)barNumberForIndex:(int)barindex;

/*!
 The transpose methods
 */

/*!
 @method setTranspose:
 @abstract Set a transposition for the score.
 @discussion Call layout() after calling setTranspose for a new transposed layout.
 <p>Requires the transpose licence.
 @param semitones (- for down, + for up)
 */
-(enum sscore_error)setTranspose:(int)semitones;

/*!
 @method transpose Get the current transpose value set with setTranspose.
 @abstract
 @return the current transpose
 */
-(int)transpose;

/*!
 The contents methods are available if we have a contents licence
 */

/*!
 @method itemForPart:bar:handle:err
 @abstract return detailed information about an item in the score.
 @discussion Requires contents-detail licence.
 @param partindex 0-based part index - 0 is the top part
 @param barindex 0-based bar index
 @param item_h unique id for item eg from SSBarGroup
 @param err pointer to a sscore_error to receive any error
 @return SSTimedItem which can be cast to the specific derived type - NoteItem/DirectionItem etc.
 */
-(SSTimedItem*)itemForPart:(int)partindex
					   bar:(int)barindex
					handle:(sscore_item_handle)item_h
					   err:(enum sscore_error*)err;

/*!
 @method xmlForPart:bar:handle:err:
 @abstract Return the XML for the item in the part/bar.
 @discussion Requires contents licence.
 @param partindex the 0-based part index - 0 is top
 @param barindex the 0-based bar index
 @param item_h the unique id of the item eg from SSBarGroup
 @param err pointer to a sscore_error to receive any error
 @return the XML as a NSString
 */
-(NSString*)xmlForPart:(int)partindex
				   bar:(int)barindex
				handle:(sscore_item_handle)item_h
				   err:(enum sscore_error*)err;

/*!
 @method barContentsForPart:bar:err:
 @abstract Get information about the contents of a particular part/bar.
 @discussion Requires contents licence.
 @param partindex the 0-based part index - 0 is top
 @param barindex the 0-based bar index
 @param err pointer to a sscore_error to receive any error
 @return the SSBarGroup containing an array of SSDisplayedItem.
 To get more information call itemForPart:bar:handle:err: using the item_h field 
 */
-(SSBarGroup*)barContentsForPart:(int)partindex
							 bar:(int)barindex
							 err:(enum sscore_error*)err;


/*!
 @method xmlForPart:bar:err:
 @abstract Return the raw XML for this given part/bar index as a String.
 @discussion Requires contents-detail licence.
 @param partindex the 0-based part index - 0 is top
 @param barindex the 0-based bar index
 @param err pointer to a sscore_error to receive any error
 @return the XML as a NSString
 */
-(NSString*)xmlForPart:(int)partindex
				   bar:(int)barindex
				   err:(enum sscore_error*)err;


/*!
 @method barTypeForBar:
 @abstract is the bar a full bar?
 @param barindex the 0-based bar index
 @return the type of bar (full or partial/anacrusis)
 */
-(enum sscore_bartype_e)barTypeForBar:(int)barIndex;

/*!
 @method timeSigForBar:
 @abstract return any time signature actually defined in a particular bar in the score, or zero if none
 @discussion actualBeatsForBar: is more useful to find the operating time signature in a bar
 @param barindex the 0-based bar index
 @return the time signature in the bar - return beats = 0 if there is none
 */
-(sscore_timesig)timeSigForBar:(int)barIndex;

/*!
 @method actualBeatsForBar:
 @abstract return the time signature operating in a particular bar in the score
 @param barindex the 0-based bar index
 @return the time signature in operation in the bar
 */
-(sscore_timesig)actualBeatsForBar:(int)barIndex;

/*!
 @method metronomeForBar:
 @abstract get the metronome if defined in a bar
 @param barindex the 0-based bar index
 @return any metronome defined in the bar
 */
-(sscore_pd_tempo)metronomeForBar:(int)barIndex;

/*!
 @method tempoAtStart:
 @abstract get the tempo at the start of the score if defined
 @return information about the tempo to use at the start of the piece
 */
-(sscore_pd_tempo)tempoAtStart;

/*!
 @method tempoAtBar:
 @abstract get the tempo at a particular bar
 @param barindex the 0-based bar index
 @return information about the tempo in the bar
 */
-(sscore_pd_tempo)tempoAtBar:(int)barIndex;

/*!
 @method convertTempoToBpm:
 @abstract convert a tempo value into a beats-per-minute value using the time signature
 @param tempo a tempo eg from tempoAtBar
 @param timesig a time signature eg from timeSigForBar
 @return beats per minute value
 */
-(int)convertTempoToBpm:(sscore_pd_tempo) tempo timeSig:(sscore_timesig)timesig;

/*!
 @method getBarBeats:
 @abstract get information about beats in a bar
 @param barindex the 0-based bar index
 @param bpm the beats per minute value
 @param bartype the type of bar (full or partial)
 @return information about number of beats and the beat time in ms for a bar
 */
-(sscore_pd_barbeats)getBarBeats:(int)barindex bpm:(int)bpm barType:(enum sscore_bartype_e) bartype;

/*!
 The information required for playing the score is available through the SSPData class
 (only if a playdata licence is available)
 */

// internal use
@property (readonly) const sscore_libkeytype *key;

@end

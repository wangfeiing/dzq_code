//
//  sscore.h
//  SeeScoreLib
//
//  Copyright (c) 2015 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#ifndef SeeScoreLib_sscore_h
#define SeeScoreLib_sscore_h

#include "sscore_graphics.h"

#ifdef __cplusplus
extern "C" {
#else
#include <stdbool.h>
#endif

#ifndef EXPORT
#if WIN32
#define EXPORT	__declspec( dllexport )
#else
#define EXPORT
#endif
#endif

/*!
 @header	sscore.h
 
 @abstract	The base C interface to SeeScoreLib<br>
 
 This interface provides functions to read a MusicXML file and create a score layout consisting
 of a set of systems to be displayed one above the next.<br>
 
 Important Types:<br>
 <ul>
 <li>sscore (opaque) defines the whole score.</li>

 <li>sscore_system (opaque) defines a single system with 1 or more parts, and a range of bars. Reference-counted</li>

 <li>sscore_systemlist (opaque) is convenient (not required) for handling a set of systems</li>
 
 <li>sscore_libkeytype is defined in a key file, either evaluation_key.c which is supplied with the SDK or
  a special key file provided by Dolphin Computing for a fee to unlock specific features and remove the
 'watermark'</li>
 </ul>

 Important Functions:<br>
 <ul>
<li>sscore_getversion() return the version number of the library</li>
 
<li>sscore_loadxmlfile loads a MusicXML file (.xml or .mxl) and returns type sscore*</li>

<li>sscore_loadxmldata loads in-memory MusicXML text data and returns type sscore*. It will read .mxl data if sscore_loadoptions.compressed is set</li>
 
<li>sscore_dispose releases the memory allocated in the sscore*</li>
 
<li>sscore_numparts returns the total number of parts available in the score.</li>
 
<li>sscore_numbars returns the total number of bars (measures) in the score</li>
 
<li>sscore_getheader returns information in the MusicXML header - title, composer etc</li>
 
<li>sscore_layout1system returns a single part sscore_system, useful for displaying
 the first few bars of a part (eg for part selection UI)</li>

<li>sscore_layout lays out all systems in the entire score. Since this function takes appreciable time for a large score it is designed to be called on a background
 thread, with regular updates to the UI for each new complete system using sscore_layout_callback_fn, which is 
 passed as an argument. Sample code is provided with the SDK to demonstrate the thread handling.</li>
 
<li>sscore_system_retain, sscore_system_release used to increment and decrement the reference-count for
 a sscore_system, which is automatically disposed when the reference count becomes 0</li>
	
<li>sscore_system_index the index of the system</li>

<li>sscore_system_numbars returns the start bar index and the number of bars in a system.</li>
	
<li>sscore_system_bounds returns the (width,height) of the system</li>
	
<li>sscore_system_draw draws the system</li>
	
<li>sscore_system_getcursorrect return the rectangle for a particular bar in a system which can be used for drawing
 a rectangular bar cursor</li>

<li>sscore_system_partindexforypos() and sscore_system_barindexforxpos() can be used to identify the location
 of a tap or mouse in a system</li>
 
<li>sscore_systemlist_create, sscore_systemlist_dispose,sscore_systemlist_clear, sscore_systemlist_size,
 sscore_systemlist_add,sscore_systemlist_at, sscore_systemlist_bounds,sscore_systemlist_sysforbar
	various convenient functions provided for handling sscore_systemlist</li>
 
<li>sscore_compressxml, sscore_decompressxml are convenience functions for converting between .xml and .mxl files</li>
 </ul>

 Coordinates:	In all coordinates x increases to the left and y increases downwards
 
 Bar indices:	The first bar in the score has always index 0, and the bars are indexed sequentially to
 the end.
 
 System indices: The top system has index 0, and other systems are indexed sequentially downwards.
	 
Thread Info:	All functions in this interface must be called from a single thread (probably the main thread)
EXCEPT for sscore_layout.<br>
NB The callback function sscore_layout_callback_fn is called on the same thread as sscore_layout,
but it must still call other functions in this interface in the normal thread
*/

#define sscore_kMaxCredits 10
#define sscore_kMaxParts 50

#define sscore_kMinMagnification 0.05F
#define sscore_kMaxMagnification 20.0F
	
#define sscore_kMinWidth 200
	
#define sscore_kMaxErrorTextChars 256

#define sscore_kNumCapabilityWords 2
#define sscore_kNumKeyWords 15

#define sscore_kMaxWarnings 64
	
#define sscore_kMiniHeaderNumberSize 4
#define sscore_kMiniHeaderStringSize 32
#define sscore_kMiniHeaderPartNameSize 16
#define sscore_kMiniHeaderMaxCredits 4
#define sscore_kMiniHeaderMaxParts 10
	
/*! @class sscore
	@abstract the score
 */
typedef struct sscore sscore;

/*! @class sscore_system
	@abstract a single laid out system with all parts and a number of bars
*/
typedef struct sscore_system sscore_system;

/*! @class sscore_systemlist
	@abstract the list of systems
	@discussion this is provided for convenience only. If this is used it handles the
	sscore_system_retain/release reference counting
 */
typedef struct sscore_systemlist sscore_systemlist;

/*! @abstract a unique handle for an item (note,rest,clef etc) in the score
 */
typedef unsigned long sscore_item_handle;

/*! @enum sscore_error
	@abstract all errors
 */
enum sscore_error
{
	sscore_NoError = 0,
	sscore_OutOfMemoryError,
	sscore_FileOpenFailedError,
	sscore_XMLValidationError,
	sscore_NoBarsInFileError,
	sscore_WidthTooSmallError,
	sscore_NullGraphicsError,
	sscore_MagnificationTooSmallError,
	sscore_MagnificationTooLargeError,
	sscore_NoPartsError,
	sscore_NoPartsToDisplayError,
	sscore_UnknownError,
	sscore_BadHeightError,
	sscore_WidthTooLargeForIphoneError, // the system width is limited on the iPhone-only licensed framework
	sscore_HeightTooLargeForIphoneError, // the system height is limited on the iPhone-only licensed framework
	sscore_NullScoreError,
	sscore_NoBufferError,			// the buffer point supplied to a function is NULL or the buffersize is too small
	sscore_BadPartIndexError,
	sscore_BadBarIndexError,
	sscore_UnlicensedFunctionError, // a function has been called with an invalid license
	sscore_NoImplError,	// a function or feature is not currently implemented
	sscore_InternalFault,
	sscore_ItemNotFoundError,
	sscore_ArgumentError,
	sscore_SoundSampleLoadFailedError,
	sscore_SoundSetupFailedError,
	sscore_SynthStartFailedError,
	sscore_SaveFailed
};

/*! @enum sscore_savetype
	@abstract save compressed or uncompressed
*/
enum sscore_savetype {
	sscore_savetype_uncompressed,
	sscore_savetype_compressed,
	sscore_savetype_default // use this to save as same type as source file (if there is a source file), else compressed
};
	
/*! @enum sscore_layoutOptionsFlagBits
	@abstract bit flags for layout options flags field
 */
enum sscore_layoutOptionsFlagBits
{
	sscore_simplifyHarmonyEnharmonicSpelling_bit = 1, // set this flag so F-double-sharp appears in a harmony as G
	sscore_layoutopt_ignorexmlpositions_bit = 2,	// set this flag to ignore default-x,default-y,relative-x,relative-y positions
	sscore_layoutopt_expandrepeat_bit = 4		// not yet implemented
};

/*! @enum sscore_warning
	@abstract all warnings
 */
enum sscore_warning
{
	sscore_warning_none,
	sscore_warning_missingelement,	// <accidental> or <stem> elements are not defined in the file and will be reconstructed by SeeScore
    sscore_warning_measurecount,	// different parts do not have the same number of measures
	sscore_warning_beamcount,		// a note has the wrong number of beams defined for the note type
	sscore_warning_consistency,		// an error in ordering of beam,slur,tied,tuplet begin/start,continue,end/stop
    sscore_warning_unexpectedStart,		// beam/slur/tie/tuplet.. 2nd start
    sscore_warning_unexpectedContinue,	// beam/slur continue without start
    sscore_warning_unexpectedStop,		// beam/slur/tie/tuplet stop without start
    sscore_warning_unclosed,		// beam/slur/tied/tuplet unclosed at end of score/measure
	sscore_warning_unpaired,		// half of paired type (start/stop) is missing or extra
	sscore_warning_badlevel			// level number is > 6
};
    
enum sscore_element_type // used for warnings
{
    sscore_element_none,
    sscore_element_beam,
    sscore_element_slur,
	sscore_element_tied,
	sscore_element_lyric,
	sscore_element_bracket,
    sscore_element_tuplet,
	sscore_element_slide,
	sscore_element_glissando,
	sscore_element_wedge,
	sscore_element_dashes,
	sscore_element_pedal,
	sscore_element_octave_shift,
	sscore_element_principal_voice,
    sscore_element_part,
	sscore_element_accidental,
	sscore_element_stem,
	sscore_element_tremolo,
	sscore_element_unknown
};

enum sscore_loadopt_flagbits
{
	sscore_loadopt_checkxml_bit = 1,	// when set various logical tests will be performed after loading and results reported as warnings
	sscore_loadopt_generatebeams_bit = 2
};

enum sscore_texttype
{
	sscore_lyricText,		// to define font for lyrics
	sscore_directionText,	// ..directions
	sscore_metronomeText,	// ..metronome marking
	sscore_barNumberText,	// ..bar numbers
	sscore_repeatBarText,	// ..repeat bar text
	sscore_octaveShiftText,	// ..octave shift
	sscore_slideText,		// text over slide
	sscore_tupletText,		// .. text over tuplets
	sscore_harmonyText,		// ..harmony text
	sscore_harmonyFrameText,	// .. guitar frame text
	sscore_tabStaffText,	// ..tab staff text
	sscore_fingeringText,	// .. fingering text
	sscore_rehearsalText,	// ..rehearsal marking text (eg A,B etc)
	sscore_partNameText,	// .. part name text
	sscore_partGroupNameText,	// .. part group name text
};

/*! @struct sscore_point
	@abstract a point
 */
typedef struct sscore_point
{
	float x,y;
} sscore_point;

/*! @struct sscore_size
	@abstract a size
*/
typedef struct sscore_size
{
	float width,height;
} sscore_size;
	
/*! @struct sscore_rect
	@abstract coords for a rectangle
*/
typedef struct sscore_rect
{
	float xorigin,yorigin,width,height;
} sscore_rect;

/*! @struct sscore_colour
	@abstract a colour
*/
typedef struct sscore_colour
{
	float r,g,b;
} sscore_colour;

/*! @struct sscore_colour_alpha
	@abstract a colour with alpha (opacity)
 */
typedef struct sscore_colour_alpha
{
	float r,g,b,a;
} sscore_colour_alpha;
	
/*! @struct sscore_version
	@abstract a version number
*/
typedef struct sscore_version
{
	int major;
	int minor;
} sscore_version;

/*! @struct sscore_loaderror
	@abstract a description of any error or warnings from sscore_load
*/
typedef struct sscore_loaderror
{
	enum sscore_error err; // any error on load

	int line; // line in the xml file of the (first) error (0 if none)
	int col; // file column in the line (0 if none)
	char text[sscore_kMaxErrorTextChars]; // any more information on the error
	
	int numwarnings; // the number of warnings
	struct {
		enum sscore_warning w; // a warning value
		int partindex;	// -1 for all parts
		int barindex;	// -1 for all bars
        enum sscore_element_type element;
		unsigned dummy; // for future
	} warn[sscore_kMaxWarnings]; // any warnings on load

	unsigned dummy[16]; // for future
} sscore_loaderror;

/*! @struct sscore_timesig
	@abstract a conventional time signature
*/
typedef struct sscore_timesig
{
	int numbeats; // number of beats in bar
	int beattype; // 8 = quaver; 4 = crochet; 2 = minim etc
} sscore_timesig;

/*! @struct sscore_libkeytype
	@abstract a key obtained from Dolphin Computing for unlocking the SeeScoreLib capabilities
*/
typedef struct sscore_libkeytype
{
	const char *identity;			// C-style string associated with the application using the SeeScoreLib
	unsigned capabilities[sscore_kNumCapabilityWords];	// encoded capabilities for this identity
	unsigned key[sscore_kNumKeyWords];	// key associated with identity and capabilities
} sscore_libkeytype;

/*! @struct sscore_loadoptions
	@abstract options for sscore_load
*/
typedef struct sscore_loadoptions
{
	const sscore_libkeytype *key;	// use NULL for evaluation of SeeScoreLib
	bool compressed;
	unsigned flags; // bit set of sscore_loadopt_flagbits
	unsigned dummy[15];	// for future. set to zero
} sscore_loadoptions;

/*! sscore_layoutoptions
	@abstract options for sscore_layout
*/
typedef struct sscore_layoutoptions
{
	bool hidepartnames; // set this so that part names are not displayed in the layout
	bool hidebarnumbers; // set this so that bar numbers are not displayed
	unsigned flags;		// bit flags defined in enum sscore_layoutOptionsFlagBits. default set 0.
	unsigned dummy[15]; // for future. set to zero
} sscore_layoutoptions;

/*!
	 @struct sscore_header
	 @abstract information in the score-header element of the xml file
	 @discussion all are null-terminated c-style strings or 0
*/
typedef struct sscore_header
{
	const char *work_number;
	const char *work_title;
	const char *movement_number;
	const char *movement_title;
	const char *composer;
	const char *lyricist;
	const char *arranger;
	
	int num_credits;
	struct {
		const char *credit_words;
	} credits[sscore_kMaxCredits];
	
	int num_parts;
	struct {
		const char *name;
		const char *abbrev;
	} parts[sscore_kMaxParts];
	
}sscore_header;

/*!
 @struct sscore_miniheader
 @abstract information in the score-header element of the xml file
 @discussion all space in this struct is allocated by the client and
 strings are copied into this for quick read of file header and no explicit dealloc
 */
typedef struct sscore_miniheader
{
	char work_number[sscore_kMiniHeaderNumberSize];
	char work_title[sscore_kMiniHeaderStringSize];
	char movement_number[sscore_kMiniHeaderNumberSize];
	char movement_title[sscore_kMiniHeaderStringSize];
	char composer[sscore_kMiniHeaderStringSize];
	char lyricist[sscore_kMiniHeaderStringSize];
	char arranger[sscore_kMiniHeaderStringSize];
	
	int num_credits;
	struct {
		char credit_words[sscore_kMiniHeaderStringSize];
	} credits[sscore_kMiniHeaderMaxCredits];

	int num_parts;
	struct {
		char name[sscore_kMiniHeaderPartNameSize];
	} parts[sscore_kMiniHeaderMaxParts];
}sscore_miniheader;

enum sscore_header_fieldid
{
	sscore_header_field_work_number_e,
	sscore_header_field_work_title_e,
	sscore_header_field_movement_number_e,
	sscore_header_field_movement_title_e,
	sscore_header_field_composer_e,
	sscore_header_field_lyricist_e,
	sscore_header_field_arranger_e
};

/*!
	 @struct sscore_barrange
	 @abstract the range of bars in a system from sscore_system_numbars
 */
typedef struct sscore_barrange
{
	int startbarindex;
	int numbars;
}sscore_barrange;
	
/*!
	 @struct sscore_cursor
	 @abstract information about the cursor from sscore_system_getcursorrect
*/
typedef struct sscore_cursor
{
	bool bar_in_system;
	sscore_rect rect;
} sscore_cursor;

/*!
 @function sscore_unionrect
 @abstract return the union of 2 rectangles
 @param r1 a rectangle
 @param r2 a rectangle
 @return the rectangular union of r1 and r2
*/
EXPORT sscore_rect sscore_unionrect(const sscore_rect *r1, const sscore_rect *r2);

/*!
	@function sscore_layout_callback_fn
	@abstract The type of a callback called from sscore_layout
	@discussion The callback is called by sscore_layout on a background thread for each system when it is laid out.
	This allows the ui to update while the layout is in progress
	The callback returns false to abort the layout, else true.
	@param sys the system laid out
	@param arg the context argument passed to sscore_layout
 */
typedef bool (*sscore_layout_callback_fn)(sscore_system *sys, void *arg);

	
/*! @functiongroup The main sscore interface
	@abstract obtain information about the score
 */

/*!
	@function sscore_loadheaderfromfile
	@abstract load only some header metadata quickly from file without loading the rest of the score
	@param filepath the full pathname of the MusicXML file
	@param header should be allocated by the caller and is returned with the header data if the function returns true
	@return true if succeeded
 */
EXPORT bool sscore_loadheaderfromfile(const char *filepath, sscore_miniheader *header);

/*!
	@function sscore_loadxmlfile
	@abstract load xml or mxl file and return score
	@param filepath the full pathname of the file
	@param opt the options for load, or NULL for default options
	@param err pointer to a struct to take error (and warning) information. May be NULL if info not required
	@return the score
*/
EXPORT sscore *sscore_loadxmlfile(const char *filepath,
								  const sscore_loadoptions *opt,
								  sscore_loaderror *err);

/*!
	@function sscore_loadxmldata
	@abstract load in-memory xml or mxl data and return score
	@param data a pointer to the data in memory
	@param len the number of bytes of data
	@param opt the options for load, or NULL for default options
	@param err pointer to a struct to take error (and warning) information. May be NULL if info not required
	@return the score
*/
EXPORT sscore *sscore_loadxmldata(const char *data, int len,
								  const sscore_loadoptions *opt,
								  sscore_loaderror *err);

/*!
	@function sscore_savefile
	@abstract save the score to a file
	@param sc the sscore pointer returned from sscore_load*
	@param filepath the full pathname of the file to save to without extension
	@param savetype compressed (.mxl) or uncompressed (.xml) or default (same as before if defined, else compressed)
	@return any error
*/
EXPORT enum sscore_error sscore_savefile(sscore *sc, const char *filepath, enum sscore_savetype savetype);

/*!
	@function sscore_ismodified
	@abstract test for changed score eg to determine whether to save
	@param sc the sscore pointer returned from sscore_load*
	@return true if score is modified
*/
EXPORT bool sscore_ismodified(const sscore *sc);
	
/*!
	@function sscore_dispose
	@abstract free the score memory, and any undisposed systems
	@param sc the sscore pointer returned from sscore_load*
*/
EXPORT void sscore_dispose(sscore *sc);

/*!
	@function sscore_numbars
	@abstract return the total number of bars in the score
	@param sc the sscore pointer returned from sscore_load*
	@return the number of bars in the score
*/
EXPORT int sscore_numbars(const sscore *sc);

/*!
	@function sscore_numparts
	@abstract return the number of parts in the score
	@param sc the sscore pointer returned from sscore_load*
	@return the number of parts in the score
*/
EXPORT int sscore_numparts(const sscore *sc);

/*!
    @function sscore_barnumberforindex
    @abstract return the number of the bar for the given bar index [0..numbars-1]
    @param sc the sscore pointer returned from sscore_load*
    @return the (string) bar number
 */
EXPORT const char *sscore_barnumberforindex(const sscore *sc, int barindex);

/*!
	@function sscore_fullpartnameforpart
	@abstract return the partname for the part
	@param sc the sscore pointer returned from sscore_load*
	@param partindex the index of the part [0..numparts-1]
	@return pointer to char NULL-terminated C-style string
*/
EXPORT const char *sscore_fullpartnameforpart(const sscore *sc, int partindex);

/*!
	@function sscore_abbrevpartnameforpart
	@abstract return the abbreviated partname for the part
	@param sc the sscore pointer returned from sscore_load*
	@param partindex the index of the part [0..numparts-1]
	@return pointer to char NULL-terminated C-style string
*/
EXPORT const char *sscore_abbrevpartnameforpart(const sscore *sc, int partindex);

/*!
	 @function sscore_instrumentnameforpart
	 @abstract return the first non-empty instrument name for the part
	 @param sc the sscore pointer returned from sscore_load*
	 @param partindex the index of the part [0..numparts-1]
	 @return pointer to char NULL-terminated C-style string
*/
EXPORT const char *sscore_instrumentnameforpart(const sscore *sc, int partindex);

	/*!
	@function sscore_layout1system
	@abstract layout a single system with a single part.
	@discussion useful for display of a single part for part selection
	@param sc the sscore pointer returned from sscore_load*
	@param graphics the sscore_graphics returned from sscore_graphics_create or sscore_graphics_create_from_bitmap
		is used to measure bounds of items, particularly text.
	@param startbarindex the index of the first bar in the system (usually 0)
	@param width the width available to display the system in screen coordinates
	@param max_height the maximum height available to display the system to control truncation. =0 for no truncation
	@param partindex the index of the single part to layout [0..numparts-1]
	@param magnification the scale at which to display this (1.0 is default)
	@param maxBars the maximum number of bars in the system (0 is no maximum)
	@return the system
*/
EXPORT sscore_system *sscore_layout1system(sscore *sc, sscore_graphics *graphics,
										   int startbarindex, float width, float max_height,
										   int partindex, float magnification,
										   int maxBars);

/*!
	@function sscore_layout
	@abstract layout a set of systems and return them through a callback function
	@discussion This should be called on a background thread and it will call cb for each system laid out, from top to bottom.
	cb will normally add the system to a sscore_systemlist on the foreground (gui event dispatch) thread.
	systems are stored in sc as they are produced
	@param sc the sscore pointer returned from sscore_load*
	@param graphics the sscore_graphics returned from sscore_graphics_create or sscore_graphics_create_from_bitmap
		is used to measure bounds of items, particularly text.
	@param width the width available to display the systems in screen coordinates
	@param max_system_height the maximum height available to display each system to control truncation. =0 for no truncation
	@param parts array of bool, 1 per part, true to include, false to exclude
	@param cb the callback function to be called for each completed system
	@param arg the context argument to be passed to cb
	@param magnification the scale at which to display this (1.0 is default)
	@param opt pointer to options or NULL for default
	@return any error
*/
EXPORT enum sscore_error sscore_layout(sscore *sc, sscore_graphics *graphics,
									   float width, float max_system_height,
									   const bool *parts,
									   sscore_layout_callback_fn cb, void *arg,
									   float magnification,
									   const sscore_layoutoptions *opt);	

/*!
	@function sscore_getheader
	@abstract get the xml score-header information
	@discussion NB The returned pointers inside header are owned by sc. The caller should copy any required data
	@param sc the sscore pointer returned from sscore_load*
	@param header pointer to a struct of type sscore_header to receive the data
*/
EXPORT void sscore_getheader(const sscore *sc, sscore_header *header);

/*!
	@function sscore_updateheader
	@abstract change the xml score-header information
	@param sc the sscore pointer returned from sscore_load*
	@param hid id of a header field
	@param val the value to write
*/
EXPORT void sscore_updateheader(sscore *sc, enum sscore_header_fieldid hid, const char *val);

/*!
	@functiongroup The sscore_system interface
	@abstract functions accessing the system - a range of bars and parts to display in a rectangle
 */

/*!
	@function sscore_system_retain
	@abstract increment the retain count of the system
	@discussion The caller must retain the system when it stores its pointer
	@param sc the sscore pointer returned from sscore_load*
	@param sys the system to be retained
*/
EXPORT void sscore_system_retain(sscore *sc, sscore_system *sys);

/*!
	@function sscore_system_release
	@abstract decrement the retain count of the system
	@discussion The caller must release the system when it release its pointer
	@param sc the sscore pointer returned from sscore_load*
	@param sys the system to be retained
*/
EXPORT void sscore_system_release(sscore *sc, sscore_system *sys);
	
/*!
	@function sscore_system_index
	@abstract return the index (from the top of the score) of the system
	@param sys the system
	@return the index of the system
*/
EXPORT int sscore_system_index(const sscore_system *sys);

/*!
	@function sscore_system_numbars
	@abstract return the start bar index and number of bars for the given system
	@param sys the system
	@return the start bar and number of bars in the system
*/
EXPORT sscore_barrange sscore_system_numbars(const sscore_system *sys);

/*!
	@function sscore_system_includesbar
	@abstract return true if this system includes the given bar index
	@param sys the system
	@param barindex index of the bar in the score
	@return return true if this system includes the given bar index
 */
EXPORT bool sscore_system_includesbar(const sscore_system *sys, int barindex);

/*!
	@function sscore_system_bounds
	@abstract return the bounding box of the system
	@param sys the system
	@return the size of the system
*/
EXPORT sscore_size sscore_system_bounds(const sscore_system *sys);

/*!
	@function sscore_system_draw
	@abstract draw the system at the given point
	@param graphics the graphics context returned from sscore_graphics_create
	@param sys the system to draw
	@param tl the top left point of the system rectangle
	@param magnification the scale to draw at. NB This is normally 1, except during active zooming. The
	overall magnification is set in sscore_layout
*/
EXPORT void sscore_system_draw(sscore_graphics *graphics, const sscore_system *sys, const sscore_point *tl, float magnification);
	
/*!
	@function sscore_system_print
	@abstract draw the system at the given point optimised for printing or pdf generation
	@param graphics the graphics context returned from sscore_graphics_create
	@param sys the system to draw
	@param tl the top left point of the system rectangle
	@param magnification the scale to draw at. The layout magnification is set in sscore_layout
*/
EXPORT void sscore_system_print(sscore_graphics *graphics, const sscore_system *sys, const sscore_point *tl, float magnification);

/*!
	@function sscore_system_getcursorrect
	@abstract return the cursor rectangle for a particular system and bar
	@param graphics the graphics context returned from sscore_graphics_create
	@param sys the system
	@param barIndex the index of the bar in the system
	@return the cursor info
*/
EXPORT sscore_cursor sscore_system_getcursorrect(sscore_graphics *graphics, const sscore_system *sys, int barIndex);
	
/*!
	@function sscore_system_partindexforypos
	@abstract return  the part index for a y-coord in  the system
	@param sys the system
	@param ypos the y coord
	@return the part index in the system containing this y coord
*/
EXPORT int sscore_system_partindexforypos(const sscore_system *sys, float ypos);
	
/*!
	 @function sscore_system_barindexforxpos
	 @abstract return the bar index for a x-coord in  the system
	 @param sys the system
	 @param xpos the x coord
	 @return the bar index in the system containing this x coord, or -1 if outside the system
*/
EXPORT int sscore_system_barindexforxpos(const sscore_system *sys, float xpos);

/*!
	 @function sscore_system_defaultspacing
	 @abstract return a default system spacing
	 @param sys the system
	 @return the default inter-system spacing
*/
EXPORT float sscore_system_defaultspacing(const sscore_system *sys);


/*!
	@functiongroup The sscore_systemlist interface
	@abstract functions to access a simple list of system
 */

/*!
	@function sscore_systemlist_create
	@abstract create a new sscore_systemlist
	@discussion the returned value should be disposed with sscore_systemlist_dispose
	@return the new sscore_systemlist
*/
EXPORT sscore_systemlist *sscore_systemlist_create();

/*!
	@function sscore_systemlist_dispose
	@abstract clear all systems from the list and dispose it
	@discussion If any system is still retained (may need to await completion on other threads)
 it will be deleted on disposal of sscore
	@param ss the sscore_systemlist returned from sscore_systemlist_create
*/
EXPORT void sscore_systemlist_dispose(sscore *sc, sscore_systemlist *ss);

/*!
	@function sscore_systemlist_clear
	@abstract clear all sytems from the list
	@param sc the score
	@param ss the sscore_systemlist returned from sscore_systemlist_create
*/
EXPORT void sscore_systemlist_clear(sscore *sc, sscore_systemlist *ss);

/*!
	@function sscore_systemlist_size
	@abstract return the number of systems held in ss
	@param ss the sscore_systemlist returned from sscore_systemlist_create
	@return the number of systems held in ss
*/
EXPORT int sscore_systemlist_size(const sscore_systemlist *ss);

/*!
	@function sscore_systemlist_add
	@abstract add a system to the end of ss
	@discussion usually called from sscore_layout_callback_fn. sys retain count is incremented
	@param ss the sscore_systemlist returned from sscore_systemlist_create
	@param sys the system to add to ss
*/
EXPORT void sscore_systemlist_add(sscore_systemlist *ss, sscore_system *sys);

/*!
	@function sscore_systemlist_at
	@abstract get a system by index
	@param ss the sscore_systemlist returned from sscore_systemlist_create
	@param sysindex the index of the system (usually from the top of the score)
	@return the system in the systemlist indexed by sysindex (indexed in order of add)
*/
EXPORT sscore_system *sscore_systemlist_at(const sscore_systemlist *ss, int sysindex);

/*!
	@function sscore_systemlist_bounds
	@abstract return the bounds of the score
	@param ss the sscore_systemlist returned from sscore_systemlist_create
	@param systemspacing the spacing between systems (0 = use default)
	@return the (width,height) of the score with the given systemspacing
*/
EXPORT sscore_size sscore_systemlist_bounds(const sscore_systemlist *ss,
											float systemspacing);

/*!
	@function sscore_systemlist_sysforbar
	@abstract return the system index for the bar index in the systemlist
	@param ss the sscore_systemlist returned from sscore_systemlist_create
	@param barindex the index of the bar in the system
	@return return the system index for the bar index, or -1 if barindex invalid
*/
EXPORT int sscore_systemlist_sysforbar(const sscore_systemlist *ss, int barindex);

/*!
	 @function sscore_systemlist_defaultspacing
	 @abstract return the default inter-system spacing
	 @param ss the sscore_systemlist returned from sscore_systemlist_create
	 @return the default inter-system spacing
*/
EXPORT float sscore_systemlist_defaultspacing(const sscore_systemlist *ss);

/*!
    @function sscore_stringforelementtype
    @abstract get a string for enum sscore_element_type
*/
EXPORT const char *sscore_stringforelementtype(enum sscore_element_type tp);

	
/*! @functiongroup General utility Functions
 */

/*!
	 @function sscore_getversion
	 @abstract return the version number of the library
 */
EXPORT sscore_version sscore_getversion();

/*!
	@function sscore_compressxml
	@abstract convert xml file to mxl
	@param xmlfilepath the full pathname for the xml source file
	@param dest_path the full pathname for the directory to receive the file to be created
	@param mxlfilename a buffer of size fnsize to receive the filename of the new file
	@param fnsize the size of the mxlfilename buffer
	@return true if success
*/
EXPORT bool sscore_compressxml(const char *xmlfilepath, const char *dest_path,  char *mxlfilename, int fnsize);

/*!
	@function sscore_decompressmxl
	@abstract convert mxl file to xml
	@param mxlfilepath the full pathname for the mxl source file
	@param dest_path the full pathname for the directory to receive the file to be created
	@param xmlfilename a buffer of size fnsize to receive the filename of the new file
	@param fnsize the size of the xmlfilename buffer
	@return return true if success
*/
EXPORT bool sscore_decompressmxl(const char *mxlfilepath, const char *dest_path,  char *xmlfilename, int fnsize);

/*!
	@function sscore_setfontnamefortext
	@abstract set the registered font name for a text type
	@param text the type of text in the score
	@param fontname the (platform-dependent) font name to be used for the type of text in the score
*/
EXPORT void sscore_setfontnamefortext(enum sscore_texttype text, const char *fontname);
	
/*!
	@function sscore_fontnamefortext
	@abstract get the registered font name for a text type
	@param text the type of text in the score
	@return the (platform-dependent) font name which will be used for the text type
*/
EXPORT const char *sscore_fontnamefortext(enum sscore_texttype text);
	
/*!
	@function sscore_defaultfontnamefortext
	@abstract the name of the font that will be registered by default for the text type
	@param text the type of text in the score
	@return the (platform-dependent) font name which will be used by default for the text type
		if it is not overridden using sscore_setfontnamefortext
*/
EXPORT const char *sscore_defaultfontnamefortext(enum sscore_texttype text);

/*!
	@function sscore_extractfilesection
	@abstract extract a section of a text file around a given line number into a buffer
	@discussion useful for displaying a section of an XML file around a given line where there is an error
	@param filepath the pathname of the file
	@param line the centre line number
	@param numlines the number of lines to extract
	@param buffer pointer to a byte buffer
	@param buffersize the size of the buffer in bytes
	@return the number of bytes added to the buffer
 */
EXPORT int sscore_extractfilesection(const char *filepath, int line, int numlines, char *buffer, int buffersize);

#ifdef __cplusplus
}
#endif

#endif

//
//  sscore_contents.h
//  SeeScoreLib
//
//  Copyright (c) 2015 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#ifndef SeeScoreLib_sscore_contents_h
#define SeeScoreLib_sscore_contents_h

#include "sscore.h"

#ifdef __cplusplus
extern "C" {
#endif

/*! @header
	The C interface to the MusicXML data in the score
 NB LICENCING:
 Some functions here require contents_capable licence, and some require contents_detail_capable.
 The contents_detail_capable licence normally includes the contents_capable licence.
 */
	
#define sscore_kMaxDirections	10
#define sscore_kMaxNotations	10
#define sscore_kMaxHarmonyChords 10
#define sscore_kMaxFrameNotes	10
#define sscore_kMaxItemsInBar	100
#define sscore_kMaxComponentsInGroup 32


/*!
	@enum sscore_item_type_e
	@abstract base type of item
 */
enum sscore_item_type_e
{
	sscore_type_noitem, // no item found for handle
	sscore_type_note,
	sscore_type_rest,
	sscore_type_direction,
	sscore_type_timesig,
	sscore_type_keysig,
	sscore_type_clef,
	sscore_type_harmony,
	sscore_type_sound,
	sscore_type_unknown,
	sscore_type_barline
};

/*!
	@enum sscore_component_type_e
	@abstract type of component which might be clicked on
 */
enum sscore_component_type_e
{
	sscore_comp_notehead,
	sscore_comp_rest,
	sscore_comp_accidental,
	sscore_comp_note_stem,
	sscore_comp_timesig,
	sscore_comp_keysig,
	sscore_comp_clef,
	sscore_comp_note_dots,
	sscore_comp_lyric,
	sscore_comp_ledgers,
	sscore_comp_beamgroup,
	sscore_comp_beam,
	sscore_comp_tremolo,
	sscore_comp_direction_text,
	sscore_comp_direction_dynamics,
	sscore_comp_direction_pedal,
	sscore_comp_direction_metro,
	sscore_comp_direction_reh,
	sscore_comp_direction_segnocoda,
	sscore_comp_notation_slur,
	sscore_comp_notation_tied,
	sscore_comp_notation_slide,
	sscore_comp_notation_glissando,
	sscore_comp_notation_tuplet,
	sscore_comp_direction_wedge,
	sscore_comp_direction_dashes,
	sscore_comp_direction_bracket,
	sscore_comp_direction_oshift,
	sscore_comp_note_ornament,
	sscore_comp_note_articulation,
	sscore_comp_note_dynamics,
	sscore_comp_note_fermata,
	sscore_comp_note_arpeggiate,
	sscore_comp_note_tech,
	sscore_comp_note_tech_fingering,
	sscore_comp_note_tech_string,
	sscore_comp_note_tech_fret,
	sscore_comp_note_tech_hammerpull,
	sscore_comp_harmony,
	sscore_comp_harmony_frame,
	sscore_comp_repeat_brace,
	sscore_comp_multiple,
	sscore_comp_parent,
	sscore_comp_undefined
};
	
/*! @abstract a unique handle for an item in the layout
 * The layout item is created from the score item and they have distinct identities
 */
typedef unsigned long sscore_layout_handle;

/*!
	@enum sscore_notations_type_e
	@abstract notation type
 */
enum sscore_notations_type_e {
	sscore_notat_unset,
	sscore_notat_tied,
	sscore_notat_slur,
	sscore_notat_tuplet,
	sscore_notat_glissando,
	sscore_notat_slide,
	sscore_notat_ornaments,
	sscore_notat_technical,
	sscore_notat_articulations,
	sscore_notat_dynamics,
	sscore_notat_fermata,
	sscore_notat_arpeggiate,
	sscore_notat_non_arpeggiate,
	sscore_notat_accidental_mark,
	sscore_notat_other,
	sscore_notat_unknown
};

/*!
	 @enum sscore_startstop_e
	 @abstract start and stop type
 */
enum sscore_startstop_e
{
	sscore_ss_undef,
	sscore_ss_start,
	sscore_ss_stop,
	sscore_ss_unknown
};

/*!
	 @enum sscore_placement_e
	 @abstract placement type
 */
enum sscore_placement_e
{
	sscore_place_undef,
	sscore_place_above,
	sscore_place_below,
	sscore_place_unknown
};

/*!
	 @enum sscore_orientation_type_e
	 @abstract orientation type
 */
enum sscore_orientation_type_e {
	sscore_orient_undef,
	sscore_orient_over,
	sscore_orient_under,
	sscore_orient_unknown};

/*!
	 @struct sscore_tied
	 @abstract tie info
*/
typedef struct sscore_tied
{
	enum sscore_startstop_e startstop;
	enum sscore_placement_e placement;
	enum sscore_orientation_type_e orientation;
	unsigned dummy[8]; // future
} sscore_tied;

/*!
	 @struct sscore_note
	 @abstract simplified note info
*/
typedef struct sscore_note
{
	int midipitch; // 60 = C4; 0 => rest
	int type; // 2 = minim, 4 = crochet etc.
	int numdots; // 1 if dotted, 2 if double-dotted
	int duration; // divisions
	int accidentals; // +1 = sharp, -1 = flat
	bool ischord; // true if this is a chord note (not set for first note of chord)
	int num_notations;
	enum sscore_notations_type_e notations[sscore_kMaxNotations];
	sscore_tied tied;
	bool grace;
	unsigned dummy[32]; // future
} sscore_note;

/*!
	 @enum sscore_direction_type
	 @abstract direction type
 */
enum sscore_direction_type
{
	sscore_dir_rehearsal,
	sscore_dir_segno,
	sscore_dir_words,
	sscore_dir_coda,
	sscore_dir_wedge,
	sscore_dir_dynamics,
	sscore_dir_dashes,
	sscore_dir_bracket,
	sscore_dir_pedal,
	sscore_dir_metronome,
	sscore_dir_octave_shift,
	sscore_dir_harp_pedals,
	sscore_dir_damp,
	sscore_dir_damp_all,
	sscore_dir_eyeglasses,
	sscore_dir_string_mute,
	sscore_dir_scordatura,
	sscore_dir_image,
	sscore_dir_principal_voice,
	sscore_dir_accordion_registration,
	sscore_dir_percussion,
	sscore_dir_other
};

/*!
	 @struct sscore_sound
	 @abstract sound info
	 @description See the MusicXML v3.0 spec for interpretation of these values.
	 All values are 0, false or NULL if undefined
*/
typedef struct sscore_sound
{
	int offset;
	int tempo;
	float dynamics;
	bool dacapo;
	const char *segno;
	const char *dalsegno;
	const char *coda;
	const char *tocoda;
	bool forward_repeat;
	float divisions;
	const char *fine;
	const char *timeonly;
	bool pizz;
	const char *damper_pedal;
	const char *soft_pedal;
	const char *sostenuto_pedal;
	unsigned dummy[8]; // future
} sscore_sound;
	

/*!
	 @struct sscore_direction
	 @abstract list of directions
 */
typedef struct sscore_direction
{
	int num_dirs;
	enum sscore_direction_type dirs[sscore_kMaxDirections];
	bool hassound;
	sscore_sound sound; // defined if hassound = true
	unsigned dummy[32]; // future
} sscore_direction;

/*!
	 @struct sscore_keysig
	 @abstract key info
 */
typedef struct sscore_keysig // support conventional only
{
	int fifths; // + = number of sharps, - = number of flats
	unsigned dummy[7]; // future
} sscore_keysig;

/*!
	 @enum sscore_clef_type_e
	 @abstract type of clef
 */
enum sscore_clef_type_e
{
	sscore_clef_treble,
	sscore_clef_treble_sub8,	// treble clef with 8 below
	sscore_clef_alto,
	sscore_clef_tenor,
	sscore_clef_bass,
	sscore_clef_percussion,
	sscore_clef_TAB,
	sscore_clef_none,
	sscore_clef_unknown,
	sscore_clef_treble_super8,	// treble clef with 8 above
	sscore_clef_bass_sub8,		// bass clef with 8 below
	sscore_clef_bass_super8		// bass clef with 8 above
};

/*!
	 @struct sscore_clef
	 @abstract clef info
 */
typedef struct sscore_clef
{
	enum sscore_clef_type_e tp;
	unsigned dummy[8]; // future
} sscore_clef;

/*!
	 @enum sscore_step_e
	 @abstract pitch step
 */
enum sscore_step_e
{
	sscore_step_A,
	sscore_step_B,
	sscore_step_C,
	sscore_step_D,
	sscore_step_E,
	sscore_step_F,
	sscore_step_G,
	sscore_step_undef
};
	
/*!
	 @enum sscore_harmony_type_e
	 @abstract type of harmony
 */
enum sscore_harmony_type_e
{
	sscore_harm_unset,
	sscore_harm_explicit,
	sscore_harm_implied,
	sscore_harm_alternate
};


/*!
	 @struct sscore_harmony
	 @abstract harmony info
 */
typedef struct sscore_harmony
{
	int num_harmonychords; // number of items in chords array
	struct
	{
		struct
		{
			enum sscore_step_e step;
			int alter; // semitones
		} root;
		struct kind
		{
			int value; // see values in MusicXML spec
			bool use_symbols;
			const char *text;
			bool stack_degrees;
			bool parentheses_degrees;
			bool bracket_degrees;
		} kind;
		int inversion;
		struct
		{
			enum sscore_step_e step;
			int alter; // semitones
		} bass;

		unsigned dummy[4]; // future
	} chords[sscore_kMaxHarmonyChords];

	struct
	{
		int strings;
		int frets;
		int firstfret; // 0 if undefined in xml
		int num_framenotes; // number of items in framenotes array
		struct {
			int string;
			int fret;
			const char *fingering; // NULL  if undefined
			enum sscore_startstop_e barre; // 0 if undefined
		} framenotes[sscore_kMaxFrameNotes];
		unsigned dummy[4]; // future
	} frame;

	float offset;
	
	enum sscore_harmony_type_e type;
	
	bool print_object;
	bool print_frame;
	
	unsigned dummy[8]; // future
} sscore_harmony;

enum sscore_bl_barstyle_e {sscore_bl_barline_unset,sscore_bl_barline_regular,sscore_bl_barline_heavy,sscore_bl_barline_double,sscore_bl_barline_none};
enum sscore_bl_loc_e {sscore_bl_loc_unset,sscore_bl_loc_right,sscore_bl_loc_left,sscore_bl_loc_middle};
enum sscore_bl_ending_startstop_e {sscore_bl_ending_start,sscore_bl_ending_stop,sscore_bl_ending_undefined};
enum sscore_bl_repeat_direction_e {sscore_bl_repeat_backward,sscore_bl_repeat_forward,sscore_bl_repeat_undefined};

/*!
	 @struct sscore_barline
	 @abstract special (repeat) barline info
 */
typedef struct sscore_barline
{

	enum sscore_bl_barstyle_e barstyle;
	enum sscore_bl_loc_e location;
	bool fermata;
	const char *ending_numbers; // eg "1", "2" or "1,2" or NULL
	
	enum sscore_bl_ending_startstop_e ending_type;
	enum sscore_bl_repeat_direction_e repeat_type;
	int repeat_times; // 0 if undefined
	bool segno;
	bool coda;
	unsigned dummy[8]; // future
} sscore_barline;

/*!
	@struct sscore_item
	@abstract detailed info about item
 */
typedef struct sscore_item
{
	enum sscore_item_type_e tp;
	int staff;
	sscore_item_handle item_h;
	int start; // divisions
	int duration; // divisions
	union
	{
		sscore_note note; // note or rest
		sscore_direction dir;
		sscore_timesig timesig;
		sscore_keysig keysig;
		sscore_clef clef;
		sscore_harmony harm;
		sscore_sound sound;
		sscore_barline barline;
	} u;
	unsigned dummy[8]; // future
} sscore_item;

/*!
	@struct sscore_conciseitem
	@abstract minimal information about item
	@description use sscore_itemforhandle to convert this to a full sscore_item
*/
typedef struct sscore_conciseitem
{
	enum sscore_item_type_e tp;
	int staff;
	sscore_item_handle item_h;
	unsigned dummy[5]; // future
} sscore_conciseitem;


/*!
	 @struct sscore_bargroup
	 @abstract information about all items in part/bar
 */
typedef struct sscore_bargroup
{
	int partindex; // index of part containing this group
	int barindex; // index of bar containing this group
	int num; // number of items in array
	sscore_conciseitem items[sscore_kMaxItemsInBar]; // items in bar
	int divisions; // divisions per quarter note (crotchet)
	int divisions_in_bar; // total divisions in bar
	unsigned dummy[8]; // future
} sscore_bargroup;

/*!
	 @struct sscore_component
	 @abstract information about item in sscore_componentgroup
 */
typedef struct sscore_component
{
	enum sscore_component_type_e tp;
	int partindex;
	int barindex;
	sscore_rect rect;
	sscore_layout_handle layout_h; // identifier of parent item in system layout
	sscore_item_handle item_h; // identifier of parent item in score (note/rest etc)
	unsigned dummy[7]; // future
} sscore_component;


/*!
	 @struct sscore_componentgroup
	 @abstract list of sscore_component
*/
typedef struct sscore_componentgroup
{
	int num;
	sscore_component components[sscore_kMaxComponentsInGroup];
	unsigned dummy[15]; // future
} sscore_componentgroup;


/*!
	@functiongroup sscore contents access functions
 */

/*!
	@function sscore_con_systemhittest
	@abstract return information (in result) about components in system which intersect point
	@discussion licence contents_capable is required to use this function
	@param sc the score
	@param sys the system being interrogated
	@param p the coordinates of the point
	@param result pointer to client-allocated sscore_componentgroup description (array) of components which intersect point
	@return sscore_error = sscore_NoError and result filled in, or an appropriate error value
*/
EXPORT enum sscore_error sscore_con_systemhittest(const sscore *sc, const sscore_system *sys, const sscore_point *p,
												  sscore_componentgroup *result);

/*!
	@function sscore_con_componentsforitem
	@abstract return information (in result) about drawn components in system which are part of a score item
	@discussion licence contents_capable is required to use this function
	@param sc the score
	@param sys the system being interrogated
	@param item_h the unique handle for the score item
	@param result pointer to client-allocated sscore_componentgroup description (array) of components which intersect point
	@return sscore_error = sscore_NoError if item found and result filled in, or an appropriate error value
*/
EXPORT enum sscore_error sscore_con_componentsforitem(const sscore *sc, const sscore_system *sys, sscore_item_handle item_h,
													  sscore_componentgroup *result);

/*!
	@function sscore_con_boundsforitem
	@abstract return rectangular bounds of all drawn components in system which are part of a score item
	@discussion licence contents_capable is required to use this function
	@param sc the score
	@param sys the system being interrogated
	@param item_h the unique handle for the score item
	@param result pointer to client-allocated rect which will contain the union of all rectangular components of the score items on return
	@return sscore_error = sscore_NoError and result filled in, or an appropriate error value
*/
EXPORT enum sscore_error sscore_con_boundsforitem(const sscore *sc, const sscore_system *sys, sscore_item_handle item_h,
												  sscore_rect *result);

/*!
	@function sscore_con_itemforhandle
	@abstract get sscore_item for the given unique handle
	@discussion licence contents_detail_capable is required to use this function
	@param sc the score
	@param partindex the index of the part in the score
	@param barindex the index of the bar in the score
	@param item_h the unique handle of the item
	@param result the sscore_item description of the item for the given handle
	@return sscore_error = sscore_NoError if item found and item returned in result, or an appropriate error value
*/
EXPORT enum sscore_error sscore_con_itemforhandle(const sscore *sc, int partindex, int barindex, sscore_item_handle item_h,
												  sscore_item *result);

/*!
	@function sscore_con_xmlforitem
	@abstract for the given unique item handle return the XML string describing the item in the file
	@discussion The xml is regenerated, so is not necessarily identical to the corresponding file section
	On return the XML is a C-style NULL-terminated sequence of UTF-8 characters in the buffer
	@discussion licence contents_capable is required to use this function
	@param sc the score
	@param partindex the index of the part in the score [0..num parts-1] containing the item
	@param barindex the index of the bar in the score [0..num bars-1] containing the item
	@param item_h the unique handle for the item
	@param buffer pointer to buffersize writeable bytes
	@param buffersize the total allocated size of the buffer
	@return sscore_error = sscore_NoError if item found and XML returned in buffer, or an appropriate error value
*/
EXPORT enum sscore_error sscore_con_xmlforitem(const sscore *sc, int partindex, int barindex, sscore_item_handle item_h,
											   char *buffer, int buffersize);


/*!
	@function sscore_con_barcontents
	@abstract return information about all the items in the bar
	@discussion licence contents_detail_capable is required to use this function
	@param sc the score
	@param partindex the part index [0..num parts-1]
	@param barindex the bar index [0..num bars-1]
	@param result pointer to client-allocated struct to be filled with a description of all items in bar
	@return sscore_error = sscore_NoError if item found and sscore_bargroup returned in result, or an appropriate error value
*/
EXPORT enum sscore_error sscore_con_barcontents(const sscore *sc, int partindex, int barindex,
												sscore_bargroup *result);

/*!
	@function sscore_con_xmlforbar
	@abstract return the xml description of the bar (<measure>) in the part
	@discussion The xml is regenerated, so is not necessarily identical to the corresponding file section.
	On return the XML is a C-style NULL-terminated sequence of UTF-8 characters in the buffer
	@discussion licence contents_capable is required to use this function
	@param sc the score
	@param partindex the part index [0..num parts-1]
	@param barindex the bar index [0..num bars-1]
	@param buffer pointer to buffersize writeable bytes
	@param buffersize the total allocated size of the buffer
	@return sscore_error = sscore_NoError if item found and XML returned in buffer, or an appropriate error value
 */
EXPORT enum sscore_error sscore_con_xmlforbar(const sscore *sc, int partindex, int barindex,
											  char *buffer, int buffersize);


/*!
 @functiongroup descriptive string functions for debugging
 */

/*!
 @function sscore_stringforitemtype
 @abstract get a debugging string describing enum sscore_item_type_e
 */
EXPORT const char *sscore_stringforitemtype(enum sscore_item_type_e tp);
/*!
 @function sscore_stringforcomponenttype
 @abstract get a debugging string describing enum sscore_component_type_e
 */
EXPORT const char *sscore_stringforcomponenttype(enum sscore_component_type_e tp);
/*!
 @function sscore_stringfornotationstype
 @abstract get a debugging string describing enum sscore_notations_type_e
 */
EXPORT const char *sscore_stringfornotationstype(enum sscore_notations_type_e tp);
/*!
 @function sscore_stringfornote
 @abstract get a string describing sscore_note for debugging
 @discussion buffer should point to a read-write area of size buffersize
 */
EXPORT enum sscore_error sscore_stringfornote(const sscore_note *note, char *buffer, int buffersize);
/*!
 @function sscore_stringfordirectiontype
 @abstract get debugging string for enum sscore_direction_type
 */
EXPORT const char *sscore_stringfordirectiontype(enum sscore_direction_type tp);
/*!
 @function sscore_stringforkeysig
 @abstract get a string describing sscore_keysig for debugging
 @discussion buffer should point to a read-write area of size buffersize
 */
EXPORT enum sscore_error sscore_stringforkeysig(const sscore_keysig *ks, char *buffer, int buffersize);
/*!
 @function sscore_stringfortimesig
 @abstract get a string describing sscore_timesig for debugging
 @discussion buffer should point to a read-write area of size buffersize
 */
EXPORT enum sscore_error sscore_stringfortimesig(const sscore_timesig *ts, char *buffer, int buffersize);
/*!
 @function sscore_stringforcleftype
 @abstract get a debugging string for enum sscore_clef_type_e
 */
EXPORT const char *sscore_stringforcleftype(enum sscore_clef_type_e tp);
/*!
 @function sscore_stringforclef
 @abstract get a string describing sscore_clef for debugging
 @discussion buffer should point to a read-write area of size buffersize
 */
EXPORT enum sscore_error sscore_stringforclef(const sscore_clef *clef, char *buffer, int buffersize);
/*!
 @function sscore_stringforstep
 @abstract get a debugging string for enum sscore_step_e
 */
EXPORT const char *sscore_stringforstep(enum sscore_step_e tp);
/*!
 @function sscore_stringforharmony
 @abstract get a string describing sscore_harmony for debugging
 @discussion buffer should point to a read-write area of size buffersize
 */
EXPORT enum sscore_error sscore_stringforharmony(const sscore_harmony *harmony, char *buffer, int buffersize);
/*!
 @function sscore_stringforsound
 @abstract get a string describing sscore_sound for debugging
 @discussion buffer should point to a read-write area of size buffersize
 */
EXPORT enum sscore_error sscore_stringforsound(const sscore_sound *sound, char *buffer, int buffersize);
/*!
@function sscore_stringforbarline
@abstract get a string describing sscore_barline for debugging
@discussion buffer should point to a read-write area of size buffersize
*/
EXPORT enum sscore_error sscore_stringforbarline(const sscore_barline *barline, char *buffer, int buffersize);
/*!
 @function sscore_stringforitem
 @abstract get a string describing sscore_item for debugging
 @discussion buffer should point to a read-write area of size buffersize
 */
EXPORT enum sscore_error sscore_stringforitem(const sscore_item *item, char *buffer, int buffersize);
/*!
 @function sscore_stringfordirection
 @abstract get a string describing sscore_direction for debugging
 @discussion buffer should point to a read-write area of size buffersize
 */
EXPORT enum sscore_error sscore_stringfordirection(const sscore_direction *dir, char *buffer, int buffersize);

#ifdef __cplusplus
	}
#endif

#endif

//
//  sscore_playdata.h
//  SeeScoreLib
//
//  Copyright (c) 2015 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#ifndef SeeScoreLib_sscore_playdata_h
#define SeeScoreLib_sscore_playdata_h

#include "sscore.h"

#ifdef __cplusplus
extern "C" {
#endif

	/*! @header
	 The C interface to play information in SeeScoreLib
	 
	 The barindex parameter is zero-based. ie 0 is the first bar in the score.
	 All times are in milliseconds
	 */

	/*!
	 @abstract special value to indicate beyond the last bar in the piece
	 */
	#define sscore_pd_kAfterEndBarIndex (0x7FFFFFFF)

	#define sscore_pd_MaxNoteSamples 128

	/*!
	 @enum sscore_bartype_e
	 @abstract categorise partial bars
	 */
	enum sscore_bartype_e {
		sscore_bartype_full_bar,			// normal full bar
		sscore_bartype_partial_first_bar,	// partial bar is first bar in score (ie anacrusis)
		sscore_bartype_partial_bar_start,	// partial bar including beat 1 (ie before repeat mark)
		sscore_bartype_partial_bar_end,		// partial bar missing beat 1 (ie after repeat mark)
		sscore_bartype_default				// for default argument
	};

	enum sscore_pd_grace_e {
		sscore_pd_grace_no,
		sscore_pd_grace_appoggiatura,
		sscore_pd_grace_acciaccatura
	};

	/*!
	 @struct sscore_pd_note
	 @discussion NB The right-hand note of a tie is included in the duration of the left hand note and omitted from the list
	 @abstract midi-type information about a note for playing
	 */
	typedef struct sscore_pd_note
	{
		int midipitch;	// 60 = C4. 0 = unpitched (eg percussion) (also used as beat index for metronome)
		int startbarindex; // index of bar in which this note starts (may be tied)
		int start;		// start time from start of bar (milliseconds)
		int duration;	// (ms) may be longer than a bar if tied
		int dynamic;	// [0..100] value of the last dynamic
		enum sscore_pd_grace_e grace;	// set for grace note
		sscore_item_handle item_h;	// item handle used in sscore_contents
		int midi_start; // midi start time (24 ticks per crotchet/quarter note)
		int midi_duration; // midi duration (24 ticks per crotchet/quarter note)
		unsigned dummy[6]; // future
	} sscore_pd_note;
	
	/*!
	 @struct sscore_pd_notesample
	 @abstract information required for pre-loading a note sample
	 */
	typedef struct sscore_pd_notesample
	{
		int midipitch;	// 60 = C4. 0 = unpitched (eg percussion)
		int duration;	// (ms) may be longer than a bar if tied
		unsigned dummy[2];
	} sscore_pd_notesample;

	/*!
	 @struct sscore_pd_notesamples
	 @abstract information required for pre-loading note samples
	 */
	typedef struct sscore_pd_notesamples
	{
		int num;
		sscore_pd_notesample samples[sscore_pd_MaxNoteSamples];
		unsigned dummy[8];
	} sscore_pd_notesamples;

	/*!
	 @struct sscore_pd_tempo
	 @abstract tempo information
	 */
	typedef struct sscore_pd_tempo
	{
		int bpm;
		int beattype;
		bool dot;
		bool usebeattype; // set if this is a beat type from a metronome mark and should be displayed, else it is a standard 4 for a sound tempo and is irrelevant to the beat
		unsigned dummy[8];
	} sscore_pd_tempo;
		
	/*!
	 @struct sscore_barbeats
	 @abstract number and duration of beats in a bar 
	 */
	typedef struct sscore_pd_barbeats
	{
		int beatsinbar;
		int beattime; // ms
	} sscore_pd_barbeats;

	/*!
	 @struct sscore_pd_partset
	 @abstract define playing parts
	 */
	typedef struct sscore_pd_partset
	{
		int num;						// the number of parts
		bool parts[sscore_kMaxParts];	// play value per part
	} sscore_pd_partset;
	
	typedef int (*sscore_pd_int_fn)(void *context);
	typedef float (*sscore_pd_float_fn)(void *context);

	/*!
	 @struct sscore_pd_usertempo
	 @abstract define realtime user tempo specification
	 */
	typedef struct sscore_pd_usertempo
	{
		/*!
		 get_user_bpm
		 an explicit bpm value specified by the user
		 (to use only if no tempo is defined in the score)
		 */
		sscore_pd_int_fn get_user_bpm;
		
		/*!
		 get_user_tempo_scaling
		 a scaling value defined by the user to multiply
		 tempo values specified in the score
		 */
		sscore_pd_float_fn get_user_tempo_scaling;
		
		/*!
		 context pointer to use as an argument to the above functions
		 */
		void *context;
		unsigned dummy[8];
	} sscore_pd_usertempo;
	
	/*!
	 @class sscore_playdata
	 @abstract hidden score data
	 */
	typedef struct sscore_playdata sscore_playdata;

	/*!
	 @struct sscore_pd_bar_iterator
	 @abstract private bar iterator for accessing bars in correct sequence when playing
	 @discussion this is not multi-thread safe. ie all functions using this must be called on a single thread
	 */
	typedef struct sscore_pd_bar_iterator
	{
		// private fields
		const sscore_playdata *pd;
		int idx;
		int ci;
		unsigned dummy[7];
	} sscore_pd_bar_iterator;

	/*!
	 @struct sscore_pd_barnotes_iterator
	 @abstract private bar notes iterator for playing
	 @discussion this provides notes sequentially with non-decreasing start time from the start of the bar
	 to the end of the _following_ bar, ie notes in 2 bars, so that there is not an inter-bar discontinuity
	 when using non-bar-aligned buffers
	 NB This must be used with the supplied functions. The private fields should not be tampered with
	 */
	typedef struct sscore_pd_barnotes_iterator
	{
		// private fields
		sscore_pd_bar_iterator bi;
		int pidx;
		int nidx;
		unsigned dummy[8];
	} sscore_pd_barnotes_iterator;

	/*!
	 @function sscore_pd_bartypeforbar
	 @abstract get information about a partial bar with fewer beats than the time signature (anacrusis or double-barline bar)
	 @discussion it is important to know if a partial bar contains the first beat or the last beat
	 @param sc the score
	 @param barindex the index of the bar (the first bar has index 0)
	 @return type of partial bar
	 */
	EXPORT enum sscore_bartype_e sscore_pd_bartypeforbar(const sscore *sc, int barindex);

	/*!
	 @function sscore_pd_timesigforbar
	 @abstract get information about the notated time signature which applies to a bar
	 @param sc the score
	 @param barindex the index of the bar
	 @param timesig receives the time signature info for the given bar (the first bar has index 0)
	 @return any error
	 */
	EXPORT enum sscore_error sscore_pd_timesigforbar(const sscore *sc, int barindex, sscore_timesig *timesig);
	
	/*!
	 @function sscore_pd_actualbeatsforbar
	 @abstract get the effective time signature information for a bar
	 @discussion This should return the same value as sscore_timesigforbar for a full bar, less for a partial bar
	 @param sc the score
	 @param barindex the index of the bar
	 @param timesig receives the effective time signature by counting divisions in (top part) bar
	 @return any error
	 */
	EXPORT enum sscore_error sscore_pd_actualbeatsforbar(const sscore *sc, int barindex, sscore_timesig *timesig);

	/*!
	 @function sscore_pd_metronomeforbar
	 @abstract get any metronome defined in or before a bar
	 @param sc the score
	 @param barindex the index of the bar
	 @param tempo on exit contains any metronome defined at the bar, or 0 if undefined
	 @return sscore_ItemNotFoundError if no metronome value defined
	 */
	EXPORT enum sscore_error sscore_pd_metronomeforbar(const sscore *sc, int barindex, sscore_pd_tempo *tempo);

	/*!
	 @function sscore_pd_tempoatstart
	 @abstract get any tempo applying at the start of the score
	 @discussion this returns in tempo a) any metronome value or b) any sound tempo value defined at the start of the score
	 @param sc the score
	 @param tempo on exit contains any tempo defined at the start of the piece
	 @return sscore_ItemNotFoundError if no tempo value defined
	 */
	EXPORT enum sscore_error sscore_pd_tempoatstart(const sscore *sc, sscore_pd_tempo *tempo);
	
	/*! 
	 @function sscore_pd_tempoatbar
	 @abstract get any tempo applying at the start of the given bar
	 @discussion this returns in tempo a) any metronome value or b) any sound tempo value defined at the start of the given bar
	 @param sc the score
	 @param tempo on exit contains any tempo value defined
	 @return sscore_ItemNotFoundError if no tempo value defined
	 */
	EXPORT enum sscore_error sscore_pd_tempoatbar(const sscore *sc, int barindex, sscore_pd_tempo *tempo);
	
	/*!
	 @function sscore_pd_converttempotobpm
	 @abstract convert a tempo with a given beat type to the given time sig beat type
	 @discussion this is useful for converting sound tempo values, which are always crotchet relative (beat = 4) to the
				current time signature
	 @param tempo the tempo value to convert
	 @param timesig the time signature for conversion
	 @return beats per minute
	 */
	EXPORT int sscore_pd_converttempotobpm(const sscore_pd_tempo *tempo, const sscore_timesig *timesig);

	/*!
	 @function sscore_pd_getbarbeats
	 @abstract get the beats and divisions in a bar and the duration
	 @param sc the score
	 @param barindex the index of the bar
	 @param bpm the beats-per-minute value
	 @param bartype use sscore_bartype_full_bar to get all the beats in the time signature,
			or sscore_bartype_default to get the actual number
	 @param barbeats receives the number and duration of beats in the given bar with the given beats per minute
	 @return any error
	 */
	EXPORT enum sscore_error sscore_pd_getbarbeats(const sscore *sc, int barindex, int bpm, enum sscore_bartype_e bartype, sscore_pd_barbeats *barbeats);

	/*!
	 @function sscore_pd_hasdefinedtempo
	 @abstract is tempo defined in the score?
	 @discussion If this returns true then sscore_pd_usertempo.get_user_tempo_scaling will be called, else
	 sscore_pd_usertempo.get_user_bpm will be used
	 @param sc the score
	 @return true if the score defines tempo (metronome or sound tempo element).
	 */
	EXPORT bool sscore_pd_hasdefinedtempo(const sscore *sc);
	
	/*! @functiongroup sscore_playdata
	 */

	/*!
	 @function sscore_pd_newplaydata
	 @abstract create playdata which provides iterators for bar and note access
	 @param sc the score
	 @param usertempo callbacks for realtime user defined tempo
	 @param key the key defining licenses owned by the user. If this key does not include a playdata licence then
	 this will operate in evaluation mode and a limited number of notes will be returned after 
	 the app is started, after which every sscore_pd_note returned from sscore_pd_bni_getnote will have
	 all fields set to 0
	 @return pointer to new playdata
	 */
	EXPORT const sscore_playdata *sscore_pd_newplaydata(const sscore *sc,
												  const sscore_pd_usertempo *usertempo,
												  const sscore_libkeytype *key);

	/*!
	 @function sscore_pd_disposeplaydata
	 @abstract dispose the playdata
	 @discussion dispose the memory allocated for this by sscore_pd_newplaydata
	 @param pd the playdata
	 */
	EXPORT void sscore_pd_disposeplaydata(const sscore_playdata *pd);
	
	/*!
	 @function sscore_pd_title
	 @param pd the playdata
	 @return a suitable title string if available
	 */
	EXPORT const char *sscore_pd_title(const sscore_playdata *pd);

	/*!
	 @function sscore_pd_numparts
	 @return number of parts in score
	 */
	EXPORT int sscore_pd_numparts(const sscore_playdata *pd);

	/*!
	 @function sscore_pd_fullpartname
	 @return the full name of the part eg "Piano"
	 */
	EXPORT const char *sscore_pd_fullpartname(const sscore_playdata *pd, int partindex);
	
	/*!
	 @function sscore_pd_abbrevpartname
	 @return the abbreviated name of the part eg "Pno"
	 */
	EXPORT const char *sscore_pd_abbrevpartname(const sscore_playdata *pd, int partindex);

	/*!
	 @function sscore_pd_maxdynamic
	 @abstract maximum value of any sound dynamic value in all bars
	 @param pd the sscore_playdata
	 @return max sound dynamic value in score or 0 if none defined
	 */
	EXPORT float sscore_pd_maxdynamic(const sscore_playdata *pd);
	
	/*!
	 @function sscore_pd_firstbaranacrusis
	 @abstract detect partial first bar (anacrusis)
	 @param pd the sscore_playdata
	 @return true if 1st bar starts after first beat
	 */
	EXPORT bool sscore_pd_firstbaranacrusis(const sscore_playdata *pd);
	
	/*!
	 @function sscore_pd_getusertempo
	 @abstract internal function
	 @param pd the sscore_playdata
	 @return the sscore_pd_usertempo
	 */
	sscore_pd_usertempo sscore_pd_getusertempo(const sscore_playdata *pd);


	/*! @functiongroup sscore_pd_bar_iterator
		@discussion all functions must be called on a single thread
	 */

	/*!
	 @function sscore_pd_begin
	 @abstract an iterator to the start bar of the piece (viz STL container)
	 @discussion increment the iterator to move to the next bar in play order allowing for repeats
	 @param pd the playdata
	 @return an iterator to the start bar of the piece
	 */
	EXPORT sscore_pd_bar_iterator sscore_pd_begin(const sscore_playdata *pd);
	
	/*!
	 @function sscore_pd_end
	 @abstract an iterator to 1 past the end bar of the piece
	 @discussion if the iterator is equal to this then the play is finished
	 @param pd the playdata
	 @return an iterator to 1 past the end bar of the piece
	 */
	EXPORT sscore_pd_bar_iterator sscore_pd_end(const sscore_playdata *pd);

	/*!
	 @function sscore_pd_bi_converttocountin
	 @abstract convert an iterator to work for a count-in bar ie with a maximum of 4 beats
	 @param bi the normal bar iterator
	 @return an iterator converted to produce a count-in bar
	 */
	EXPORT sscore_pd_bar_iterator sscore_pd_bi_converttocountin(const sscore_pd_bar_iterator *bi);
	
	/*!
	 @function sscore_pd_bi_iscountin
	 @abstract count-in bar?
	 @param bi the normal bar iterator
	 @return true for a count-in bar
	 */
	EXPORT bool sscore_pd_bi_iscountin(const sscore_pd_bar_iterator *bi);

	/*!
	 @function sscore_pd_bi_inc
	 @abstract move the bar iterator to the next bar accounting for repeats. Unchanged if at end
	 @param bi the iterator to be updated.
	 */
	EXPORT void sscore_pd_bi_inc(sscore_pd_bar_iterator *bi);
	
	/*!
	 @function sscore_pd_bi_dec
	 @abstract move the bar iterator to the previous bar accounting for repeats. Unchanged if at beginning
	 @param bi the iterator to be updated.
	 */
	EXPORT void sscore_pd_bi_dec(sscore_pd_bar_iterator *bi);
	
	/*!
	 @function sscore_pd_bi_incbyindex
	 @abstract increment the bar iterator by index
	 @param bi the barnotes iterator
	 */
	EXPORT void sscore_pd_bi_incbyindex(sscore_pd_bar_iterator *bi, int index);

	/*!
	 @function sscore_pd_bi_changebar
	 @abstract move the bar iterator to the given bar index
	 @param bi the bar iterator
	 @param barindex the new bar index - if repeat it is the closest repeat to the current position
	 @return true if successful
	 */
	EXPORT bool sscore_pd_bi_changebar(sscore_pd_bar_iterator *bi, int barindex);
	
	/*!
	 @function sscore_pd_bi_barindex
	 @abstract get the index of the current bar
	 @param bi the bar iterator
	 @return the index of the bar which the iterator refers to (0 for first bar)
	 */
	EXPORT int sscore_pd_bi_barindex(const sscore_pd_bar_iterator *bi);
	
	/*!
	 @function sscore_pd_bi_metronomebeatsinbar
	 @abstract the number of metronome ticks, max 4 if count-in bar 
	 @param bi the bar iterator
	 @return the number of metronome beats in the bar
	 */
	EXPORT int sscore_pd_bi_metronomebeatsinbar(const sscore_pd_bar_iterator *bi);

	/*!
	 @function sscore_pd_bi_nextbarindex
	 @abstract index of next bar
	 @param bi the iterator
	 @return index of the next bar after inc if canadvance, else sscore_pd_kAfterEndBarIndex
	 */
	EXPORT int sscore_pd_bi_nextbarindex(const sscore_pd_bar_iterator *bi);
	
	/*!
	 @function sscore_pd_bi_seqindex
	 @abstract play index of bar in nondecreasing sequence
	 @param bi the iterator
	 @return sequential play index of the bar accounting for any repeats
	 */
	EXPORT int sscore_pd_bi_seqindex(const sscore_pd_bar_iterator *bi);
	
	/*!
	 @function sscore_pd_bi_barduration
	 @abstract the duration of the current bar in ms
	 @param bi the bar iterator
	 @return duration of bar in ms
	 */
	EXPORT int sscore_pd_bi_barduration(const sscore_pd_bar_iterator *bi);

	/*!
	 @function sscore_pd_bi_barduration_midi
	 @abstract the duration of the current bar in midi ticks (24 per crotchet)
	 @param bi the bar iterator
	 @param crotchet_duration midi crotchet duration ticks
	 @return duration of bar in midi ticks
	 */
	EXPORT int sscore_pd_bi_barduration_midi(const sscore_pd_bar_iterator *bi, int crotchet_duration);
	
	/*!
	 @function sscore_pd_bi_key
	 @abstract the key signature in the bar
	 @param partindex the part index
	 @param bi the bar iterator
	 @return key signature - positive indicates number of sharps in key sig, negative indicates number of flats
	 */
	EXPORT int sscore_pd_bi_keysig(int partindex, const sscore_pd_bar_iterator *bi);
	
	/*!
	 @function sscore_pd_bi_timesig
	 @abstract the time signature in the bar
	 @param partindex the part index
	 @param bi the bar iterator
	 @return time signature
	 */
	EXPORT sscore_timesig sscore_pd_bi_timesig(int partindex, const sscore_pd_bar_iterator *bi);
	
	/*!
	 @function sscore_pd_bi_tempo_crotchet_bpm
	 @abstract return the crotchet beats per minute in this bar
	 @param bi the bar iterator
	 @return the crotchet tempo
	 */
	EXPORT int sscore_pd_bi_tempo_crotchet_bpm(const sscore_pd_bar_iterator *bi);
	
	/*!
	 @function sscore_pd_bi_getnotesampleinfo
	 @abstract get information about notes required for preloading note samples ahead of time
	 @param bi the bar iterator
	 @param numbars the number of bars to collect note sample data for, ahead of the current bar (1 for just the current bar)
	 @param partset the set of parts to harvest information from (eg the set of parts played by a particular instrument for precacheing notes for that instrument)
	 @param rval on return contains the information about notes required in coming numbars. NB The maximum time for any
	 particular note is returned
	 @return any error
	 */
	EXPORT enum sscore_error sscore_pd_bi_getnotesampleinfo(const sscore_pd_bar_iterator *bi, int numbars, const sscore_pd_partset *partset, sscore_pd_notesamples *rval);

	/*!
	 @function sscore_pd_bi_equal
	 @abstract compare 2 iterators
	 @param bi1
	 @param bi2
	 @return true if iterators are equal (point to the same bar, same repeat)
	 */
	EXPORT bool sscore_pd_bi_equal(const sscore_pd_bar_iterator *bi1, const sscore_pd_bar_iterator *bi2);
	
	/*!
	 @function sscore_pd_bi_less
	 @abstract compare 2 iterators
	 @param bi1
	 @param bi2
	 @return true if bi1 is at an earlier bar than bi2
	 */
	EXPORT bool sscore_pd_bi_less(const sscore_pd_bar_iterator *bi1, const sscore_pd_bar_iterator *bi2);
	
	/*! @functiongroup sscore_pd_barnotes_iterator
	 */

	/*!
	 @function sscore_pd_bi_begin
	 @abstract an iterator to notes in the current and next bar
	 @discussion increment the returned iterator (sscore_pd_bni_inc) to move to the next note in time order in the given part
	 'dereference' the iterator (sscore_pd_bni_getnote) to get the note information
	 NB The iterator never returns the right hand note of a tie, as that only modifies the duration of the first tied note
	 @param bi the bar iterator
	 @param partindex the part index
	 @return the start barnotes iterator pointing to the first played note in the bar.
	 */
	EXPORT sscore_pd_barnotes_iterator sscore_pd_bi_begin(const sscore_pd_bar_iterator *bi, int partindex);
	
	/*!
	 @function sscore_pd_bi_endthis
	 @abstract an iterator 1 past the last note in the bar/part
	 @discussion compare a barnotes iterator with this to detect the end of sequence for the bar
	 @param bi the bar iterator
	 @param partindex the part index
	 @return the past-end barnotes iterator
	 */
	EXPORT sscore_pd_barnotes_iterator sscore_pd_bi_endthis(const sscore_pd_bar_iterator *bi, int partindex);
	
	/*!
	 @function sscore_pd_bi_endnext
	 @abstract an iterator 1 past the last note in next bar so begin->endnext includes all notes in 2 bars
	 so that the bar transition is covered
	 @discussion compare a barnotes iterator with this to detect the end of sequence
	 @param bi the bar iterator
	 @param partindex the part index
	 @return the past-end barnotes iterator
	 */
	EXPORT sscore_pd_barnotes_iterator sscore_pd_bi_endnext(const sscore_pd_bar_iterator *bi, int partindex);
	
	/*!
	 @function sscore_pd_bi_metronome_begin
	 @abstract an iterator to pseudo metronome notes in the current and next bar
	 @discussion the metronome is modelled as a series of notes, 1 per beat in each bar. The correct
	 bar sequence time signature changes are followed
	 @param bi the bar iterator
	 @return the barnotes iterator
	 */
	EXPORT sscore_pd_barnotes_iterator sscore_pd_bi_metronome_begin(const sscore_pd_bar_iterator *bi);
	
	/*!
	 @function sscore_pd_bi_metronome_endthis
	 @abstract an iterator 1 past the last note in the metronome sequence for the bar
	 @param bi the bar iterator
	 @return the barnotes iterator
	 */
	EXPORT sscore_pd_barnotes_iterator sscore_pd_bi_metronome_endthis(const sscore_pd_bar_iterator *bi);
	
	/*!
	 @function sscore_pd_bi_metronome_endnext
	 @abstract an iterator 1 past the last note in the metronome sequence for this bar and the next bar
	 @param bi the bar iterator
	 @return the barnotes iterator
	 */
	EXPORT sscore_pd_barnotes_iterator sscore_pd_bi_metronome_endnext(const sscore_pd_bar_iterator *bi);
	
	/*!
	 @function sscore_pd_bni_inc
	 @abstract increment the barnotes iterator so sscore_pd_bni_getnote returns the next note
	 @discussion notes are returned in non-decreasing start time order
	 @param bni the iterator
	 */
	EXPORT void sscore_pd_bni_inc(sscore_pd_barnotes_iterator *bni);
	
	/*!
	 @function sscore_pd_bni_incbyindex
	 @abstract increment the barnotes iterator by index
	 @param bni the barnotes iterator
	 */
	EXPORT void sscore_pd_bni_incbyindex(sscore_pd_barnotes_iterator *bni, int index);
	
	/*!
	 @function sscore_pd_bni_dec
	 @abstract decrement the barnotes iterator so sscore_pd_bni_getnote returns the previous note
	 @param bni the iterator
	 */
	EXPORT void sscore_pd_bni_dec(sscore_pd_barnotes_iterator *bni);
	
	/*!
	 @function sscore_pd_bni_getnote
	 @abstract get the note information at the current iterator position
	 @discussion
	 @param bni the barnotes iterator
	 @return play information about a note
	 */
	EXPORT sscore_pd_note sscore_pd_bni_getnote(const sscore_pd_barnotes_iterator *bni);
	
	/*!
	 @function sscore_pd_bni_equal
	 @abstract compare 2 iterators
	 @param bni1
	 @param bni2
	 @return true if iterators are equal
	 */
	EXPORT bool sscore_pd_bni_equal(const sscore_pd_barnotes_iterator *bni1, const sscore_pd_barnotes_iterator *bni2);
	
	/*!
	 @function sscore_pd_bni_less
	 @abstract compare 2 iterators
	 @param bni1
	 @param bni2
	 @return true if bni1 is earlier in the score than bni2 (assuming same playdata and part)
	 */
	EXPORT bool sscore_pd_bni_less(const sscore_pd_barnotes_iterator *bni1, const sscore_pd_barnotes_iterator *bni2);
	
	/*!
	 @function sscore_pd_create_midifile
	 @abstract create a MIDI file from the playdata
	 @param pd the playdata
	 @param midifilename full pathname for the midifile
	 @return error
	 */
	EXPORT enum sscore_error sscore_pd_create_midifile(const sscore_playdata *pd, const char *midifilename);

	/*!
	 @function sscore_pd_scalemidifiletempo
	 @abstract poke a new tickrate value into the midi file to scale the tempo
	 @param midifilename full pathname for the midifile
	 @param temposcaling the new tempo scaling (nominal = 1.0)
	 @return error
	 */
	EXPORT void sscore_pd_scalemidifiletempo(const char *midifilename, float temposcaling);
#ifdef __cplusplus
}
#endif

#endif

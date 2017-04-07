//
//  sscore_synth.h
//  SeeScoreLib
//
//  Copyright (c) 2015 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#ifndef SeeScoreLib__sscore_synth__
#define SeeScoreLib__sscore_synth__

#include "sscore.h"
#include "sscore_playdata.h"

#ifdef __cplusplus
extern "C" {
#else
#include <stdbool.h>
#endif
		
	/*! @header
	 The C interface to SeeScoreLib sound synthesizer
	 */

	/*!
	 @class sscore_synth
	 @abstract the abstract sound synthesizer
	 */
	typedef struct sscore_synth sscore_synth;
	
	typedef unsigned sscore_sy_instrumentid;

	/*!
	 @struct sscore_sampledinstrumentinfo
	 @abstract info defining a sampled instrument
	 @discussion a sampled instrument requires a set of files, one for each note, included in the Resources for the app
	 The file naming scheme is defined: sample files have the name (base_filename).(midipitch).extn eg "Piano.60.m4a"
	 base_filename and extn are defined below; base_midipitch and numfiles define the range of (midipitch).
	 Parameters attack_time_ms, decay_time_ms and overlap_time_ms need to be 'tweaked' to make a sequence sound right when
	 played against a metronome tick.
	 alternativenames is used for instrument name matching
	 pitch_offset is used to transpose the instrument, eg it can be used to mimic a clarinet when playing an
	 _untransposed_ score. Note that a score scored for transposing instrument should specify the transposition and in this
	 case pitch_offset should be zero
	 */
	typedef struct sscore_sy_sampledinstrumentinfo
	{
		const char *instrument_name; // the name of the instrument
		const char *base_filename;	// the start of the filename before the .(midipitch)
		const char *extn;		// the filename extension
		int base_midipitch;		// the lowest midi pitch file
		int numfiles;			// the number of sample files with sequential midi values from base_midipitch
		float volume;			// for adjustment of balance with other instruments
		int attack_time_ms;		// time from start of sample play to beat reference point
		int decay_time_ms;		// 90% to 10% sigmoid decay time
		int overlap_time_ms;	// overlap with following note
		const char *alternativenames; // comma-separated (lower case) alternative names for matching part name, eg "cello,violoncello"
		int pitch_offset;		// the pitch offset for a transposing instrument
		unsigned dummy[16];
	} sscore_sy_sampledinstrumentinfo;

	enum sscore_sy_synthesizedinstrumentvoice
	{
		sscore_sy_tick1,
		sscore_sy_tick2,
		sscore_sy_tick3
	};

	/*!
	 @struct sscore_sy_synthesizedinstrumentinfo
	 @abstract info defining a synthesized instrument (metronome tick only supported at present)
	 */
	typedef struct sscore_sy_synthesizedinstrumentinfo
	{
		const char *instrument_name;	// the name of the instrument
		int tickpitch;					// defines metronome tick
		float volume;					// for adjustment of balance with other instruments
		enum sscore_sy_synthesizedinstrumentvoice voice;
		unsigned dummy[16];
	} sscore_sy_synthesizedinstrumentinfo;

	typedef bool (*sscore_sy_bool_intfn)(void *context, int);
	typedef unsigned (*sscore_sy_uint_intfn)(void *context, int);
	typedef float (*sscore_sy_float_intfn)(void *context, int);
	typedef bool (*sscore_sy_boolfn)(void *context);
	typedef unsigned (*sscore_sy_uintfn)(void *context);
	typedef float (*sscore_sy_floatfn)(void *context);

	typedef struct sscore_sy_controls
	{
		sscore_sy_bool_intfn partEnabled;
		sscore_sy_uint_intfn partInstrument;
		sscore_sy_float_intfn partVolume; // [0.0..1.0]
		sscore_sy_boolfn metronomeEnabled;
		sscore_sy_uintfn metronomeInstrument;
		sscore_sy_floatfn metronomeVolume; // [0.0..1.0]
		void *context;
	} sscore_sy_controls;
	
	/*!
	 @function sscore_sy_createsynth
	 @abstract create a new synth and return it
	 @param controls synth ui controls defined above
	 @param key the key defining licenses owned by the user. If this key does not include a synth licence
	 then the synth will operate for a limited time only after the app is started 
	 @return the synth
	 */
	EXPORT sscore_synth *sscore_sy_createsynth(const sscore_sy_controls *controls, const sscore_libkeytype *key);
	
	/*!
	 @function sscore_sy_disposesynth
	 @abstract dispose the synth
	 @param synth the synth returned from sscore_sy_createsynth
	 */
	EXPORT void sscore_sy_disposesynth(sscore_synth *synth);
	
	/*!
	 @function sscore_sy_addsampledinstrument
	 @abstract create a sampled instrument for the synth to use from a set of file sound samples, 1 for each midi note
	 @param synth the synth returned from sscore_sy_createsynth
	 @param info a struct defining the sample file naming, and various instrument parameters
	 @param err returns any error
	 @return a unique identifier for the instrument
	 */
	EXPORT sscore_sy_instrumentid sscore_sy_addsampledinstrument(sscore_synth *synth,
																 const sscore_sy_sampledinstrumentinfo *info,
																 enum sscore_error *err);
	
	/*!
	 @function sscore_sy_addsynthesizedinstrument
	 @abstract create a synthesized instrument (metronome tick) for the synth to use 
	 @param synth the synth returned from sscore_sy_createsynth
	 @param info a struct defining the synthesized sound (only tick available)
	 @param err returns any error
	 @return a unique identifier for the instrument
	 */
	EXPORT sscore_sy_instrumentid sscore_sy_addsynthesizedinstrument(sscore_synth *synth,
																	   const sscore_sy_synthesizedinstrumentinfo *info,
																	   enum sscore_error *err);

	/*!
	 @function sscore_sy_removeinstrument
	 @abstract remove an instrument previously added with sscore_sy_addsampledinstrument or sscore_sy_addsynthesizedinstrument
	 @param synth the synth returned from sscore_sy_createsynth
	 @param iid the identifier returned from sscore_sy_addXXXinstrument
	 */
	EXPORT void sscore_sy_removeinstrument(sscore_synth *synth, sscore_sy_instrumentid iid);

	/*!
	 @function sscore_sy_setup
	 @abstract 
	 @param synth the synth from sscore_sy_createsynth
	 @param playdata returned from sscore_pd_newplaydata
	 @return any error
	 */
	EXPORT enum sscore_error sscore_sy_setup(sscore_synth *synth, const sscore_playdata *playdata);
	
	/*!
	 @function sscore_sy_startat
	 @abstract start playing the notes in playdata after the given delay
	 @param synth the synth from sscore_sy_createsynth
	 @param start_time the (system-dependent) time to start playing
	 NB This should be at least 1 or 2 seconds in the future to allow time for the setup to complete
	 @return any error
	 */
	EXPORT enum sscore_error sscore_sy_startat(sscore_synth *synth, unsigned long long start_time, int barindex, bool delayStartForCountIn);
	
	/*!
	 @function sscore_sy_pause
	 @abstract pause playing
	 @param synth the synth from sscore_sy_createsynth
	 */
	EXPORT void sscore_sy_pause(sscore_synth *synth);

	/*!
	 @function sscore_sy_reset
	 @abstract stop playing and reset to the start of the score
	 @param synth the synth from sscore_sy_createsynth
	 */
	EXPORT void sscore_sy_reset(sscore_synth *synth);
		
	/*!
	 @function sscore_sy_isplaying
	 @abstract detect if the synth is playing
	 @param synth the synth from sscore_sy_createsynth
	 @return true if playing
	 */
	EXPORT bool sscore_sy_isplaying(sscore_synth *synth);
		
	/*!
	 @function sscore_sy_playingbar
	 @param synth the synth from sscore_sy_createsynth
	 @return the index of the bar playing
	 */
	EXPORT int sscore_sy_playingbar(sscore_synth *synth);

	/*!
	 @function sscore_sy_setnextplaybar
	 @abstract set the next play bar while playing (eg when the user taps a bar in the score)
	 @param synth the synth from sscore_sy_createsynth
	 @param barindex the index of the bar to restart playing from
	 @param restart_time the (system-dependent) time to restart playing
	 */
	EXPORT void sscore_sy_setnextplaybar(sscore_synth *synth, int barindex, unsigned long long restart_time);

	/*!
	 @function sscore_sy_updatetempo
	 @abstract notification that the user has changed the tempo (viz. sscore_pd_usertempo)
	 @param synth the synth from sscore_sy_createsynth
	 @param restart_time the (system-dependent) time to restart playing the current bar with the new tempo
	 */
	EXPORT void sscore_sy_updatetempo(sscore_synth *synth, unsigned long long restart_time);

	/*!
	 @function sscore_sy_setpartvolume
	 @abstract change the volume of a part
	 @param synth the synth from sscore_sy_createsynth
	 @param partindex the index of the part
	 @param volume the volume [0..1]
	 */
	EXPORT void sscore_sy_setpartvolume(sscore_synth *synth, int partindex, float volume);

	/*!
	 @function sscore_sy_setmetronomevolume
	 @abstract change the volume of the metronome
	 @param synth the synth from sscore_sy_createsynth
	 @param volume the volume [0..1]
	 */
	EXPORT void sscore_sy_setmetronomevolume(sscore_synth *synth, float volume);

	/*!
	 @function sscore_sy_changedcontrols
	 @abstract notification that the controls have changed so the sscore_sy_controls needs to be reread
	 @param synth the synth from sscore_sy_createsynth
	 */
	EXPORT void sscore_sy_changedcontrols(sscore_synth *synth);
	
#ifdef __cplusplus
}
#endif

#endif

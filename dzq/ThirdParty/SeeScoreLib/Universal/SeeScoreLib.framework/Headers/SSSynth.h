//
//  SSSynth.h
//  SeeScoreLib
//
//  Copyright (c) 2015 Dolphin Computing Ltd. All rights reserved.
//
// No warranty is made as to the suitability of this for any purpose
//

#import "SSEventHandler.h"

#include "sscore_synth.h"

/*!
 @header SSSynth.h
 @abstract interface to the SeeScore iOS synthesizer
 */

/*!
 @protocol SSSyControls
 @abstract interface to UI synthesizer controls
 */
@protocol SSSyControls

/*!
 @method partEnabled
 @abstract is the part enabled for play?
 @return true if the part is enabled for playing
 */
-(bool)partEnabled:(int)partIndex;

/*!
 @method partInstrument
 @abstract get the instrument id
 @return the instrument id
 */
-(unsigned)partInstrument:(int)partIndex;

/*!
 @method partVolume
 @abstract get the part volume
 @return the relative volume of the part [0.0 .. 1.0]
 */
-(float)partVolume:(int)partIndex;

/*!
 @method metronomeEnabled
 @abstract is the metronome enabled?
 @return true if the metronome (virtual) part should be played
 */
-(bool)metronomeEnabled;

/*!
 @method metronomeInstrument
 @abstract get the metronome instrument id
 @return the id of the metronome instrument
 */
-(unsigned)metronomeInstrument;

/*!
 @method metronomeVolume
 @abstract get the metronome volume
 @return the relative volume of the metrnonome part  [0.0 .. 1.0]
 */
-(float)metronomeVolume;

@end

@class SSScore;
@class SSPData;

/*!
 @interface SSSynth
 @abstract the interface to the synthesizer which plays the MusicXML score
 */
@interface SSSynth : NSObject

/*!
 @property isPlaying
 @abstract true if playing
 */
@property (readonly) bool isPlaying;

/*!
 @property playingBar
 @abstract the 0-based index of the bar which is currently being played
 */
@property (readonly) int playingBar;

/*!
 @method createSynth:
 @abstract create the synthesizer
 @param controls the object which implements SSSyControls to control the synth (usually using UI controls, sliders, switches etc)
 @param score the score (used to access the key)
 */
+(SSSynth*)createSynth:(id<SSSyControls>)controls score:(SSScore*)score;

/*!
 @method addSampledInstrument:
 @abstract add a sampled instrument and return its unique identifier
 @param info describes the instrument including the filenames of the samples in the app resources, usually defined as a static const
 */
-(sscore_sy_instrumentid)addSampledInstrument:(const sscore_sy_sampledinstrumentinfo *)info;

/*!
 @method addSynthesizedInstrument:
 @abstract add a synthesized instrument (metronome tick)
 @param info description of the instrument, usually defined as a static const
 */
-(sscore_sy_instrumentid)addSynthesizedInstrument:(const sscore_sy_synthesizedinstrumentinfo *)info;

/*!
 @method removeInstrument:
 @abstract remove the instrument
 @param instrument the id returned from addXXXInstrument
 */
-(void)removeInstrument:(sscore_sy_instrumentid)instrument;

/*!
 @method setup:
 @abstract setup the synthesizer with the play data
 @param playdata the information about what to play
 */
-(enum sscore_error)setup:(SSPData*)playdata;

/*!
 @method startAt:
 @abstract start playing at the given time from the start of the given bar
 @param start_time the (future) time to start playing
 @param barIndex the 0-based bar to start playing from
 @param countIn set if you want a count-in bar at the start
 */
-(enum sscore_error)startAt:(dispatch_time_t)start_time bar:(int)barIndex countIn:(bool)countIn;

/*!
 @method pause
 @abstract pause play
 */
-(void)pause;

/*!
 @method reset
 @abstract stop play and reset the play position to the start
 @discussion you need to call setup: again to play after reset
 */
-(void)reset;

/*!
 @method setNextBarToPlay
 @abstract set the next bar to play. The synth will automatically stop play and restart at the new bar
 @param barIndex the bar to jump to
 @param restart_time the (future) time to restart play from the start of the new bar
 */
-(void)setNextBarToPlay:(int)barIndex at:(dispatch_time_t)restart_time;

/*!
 @method updateTempoAt:
 @abstract called on changing something which will affect the return value from SSUTempo which was supplied to the SSPData.
 The play tempo will update at the given time
 @param restart_time the time to restart with the new tempo (at the start of the current bar)
 */
-(void)updateTempoAt:(dispatch_time_t)restart_time;

/*!
 @method changedControls
 @abstract notification that the SSSyControls have changed
 */
-(void)changedControls;

/*!
 @method setBarChangeHandler:
 @abstract register an event handler to be called at the start of each bar
 @param handler the handler to be called at the start of each bar
 @param delay_ms a millisecond delay for the handler call, which can be negative (normally) to anticipate the bar change eg for an animated cursor
 */
-(void)setBarChangeHandler:(id<SSEventHandler>) handler delay:(int)delay_ms;

/*!
 @method setBeatHandler:
 @abstract register an event handler to be called on each beat in the bar
 @param handler the handler to be called on each beat
 @param delay_ms a millisecond delay for the handler call, which can be negative to anticipate the event
 */
-(void)setBeatHandler:(id<SSEventHandler>) handler delay:(int)delay_ms;

/*!
 @method setEndHandler:
 @abstract register an event handler to be called on completion of play
 @param handler the handler to be called at the end of play
 @param delay_ms a millisecond delay for the handler call, which can be negative to anticipate the event
 */
-(void)setEndHandler:(id<SSEventHandler>) handler delay:(int)delay_ms;

/*!
 @method setNoteHandler:
 @abstract register an event handler to be called on start and end of new note/chord
 @discussion This can be used to move a cursor onto each note as it is played.
 NB for a piece with many fast notes you need to ensure your handler is fast enough to handle the throughput.
 You will probably define the endNote() method to do nothing as this is called for every note, unlike startNotes
 which is only called once per chord
 @param handler the handler to be called at the start and end of each note
 @param delay_ms a millisecond delay for the handler call, which can be negative to anticipate the event
 */
-(void)setNoteHandler:(id<SSNoteHandler>) handler delay:(int)delay_ms;

@end

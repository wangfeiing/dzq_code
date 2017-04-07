

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>


/**
 * @see http://developer.apple.com/library/mac/#technotes/tn2283/_index.html
 */
@interface YYSampler : NSObject

- (void)triggerNote:(NSUInteger)note;//切换音符
- (void)triggerNote:(NSUInteger)note isOn:(BOOL)isOn;

- (void)YYSamplerPath:(int)pathId;

- (OSStatus)loadFromDLSOrSoundFont:(NSURL *)bankURL withPatch:(int)presetNumber;

@end

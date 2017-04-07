//
//  MIDIManager.h
//  MIDIKeyboard
//
//  Created by 梁伟 on 15/8/15.
//  Copyright © 2015年 梁伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

@protocol MIDIManagerDelegate <NSObject>
@optional
- (void)showMessage:(NSString *)message;
- (void)receiveNote:(int)note state:(int)data;
- (void)received;
- (void)removed;
- (void)connected;
- (void)showMessageOnMain:(NSString *)message;

@end

@interface MIDIManager : NSObject

@property (nonatomic) MIDIClientRef client;//
@property (nonatomic) MIDIPortRef inputPort;
@property (nonatomic) MIDIPortRef outputPort;
@property (nonatomic, assign)id<MIDIManagerDelegate> delegate;
@property (nonatomic, assign) MIDIPacketList *sharedPacketList;
- (void)sendBytes:(const UInt8*)data size:(UInt32)size;
@end

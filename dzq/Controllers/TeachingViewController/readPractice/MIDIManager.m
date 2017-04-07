//
//  MIDIManager.m
//  MIDIKeyboard
//
//  Created by 梁伟 on 15/8/15.
//  Copyright © 2015年 梁伟. All rights reserved.
//

#import "MIDIManager.h"
static void LWMIDIReadProc(const MIDIPacketList *pktList, void *readProcRefCon, void *srcConnRefCon);
static MIDIManager *sharedManager;
@implementation MIDIManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createClient];
        [self connectToSource];
    }
    return self;
}

- (void)createClient{
    MIDIClientRef client;
    OSStatus error = MIDIClientCreate((CFStringRef)@"MIDIClient",LWMIDINotifyProc, (__bridge void * _Nullable)(self), &client);
    if (error != noErr) {
        [self.delegate showMessage:@"Client创建失败"];
//        NSLog(@"Client创建失败");
        return;
    }
    self.client = client;
    
    MIDIPortRef inputPort;
    error = MIDIInputPortCreate(client, (CFStringRef)@"MIDIInputPort", LWMIDIReadProc, (__bridge void * _Nullable)(self), &inputPort);
    if (error != noErr) {
        [self.delegate showMessage:@"创建inputPort错误"];
        return;
    }
    self.inputPort = inputPort;
    
    MIDIPortRef outputPort;
    error = MIDIOutputPortCreate(client, (CFStringRef)@"MIDIOutputPort", &outputPort);
    if (error != noErr) {
    [self.delegate showMessage:@"创建outputPort错误"];
//        NSLog(@"创建outputPort错误");
        return;
    }
    self.outputPort = outputPort;
    
}

- (void)connectToSource{
    ItemCount numberSource = MIDIGetNumberOfSources();
    
    for (ItemCount index = 0; index < numberSource; index++) {
        MIDIEndpointRef source = MIDIGetSource(index);
        OSStatus error = MIDIPortConnectSource(_inputPort, source, (__bridge void * _Nullable)(self));
        if (error != noErr) {
            [self.delegate showMessage:@"端口链接错误"];
//            NSLog(@"端口链接错误");
            return;
        }
    }
}

#pragma mark - Notifition
void LWMIDINotifyProc(const MIDINotification *message, void *refCon){
    @autoreleasepool {
        MIDIManager *manager = (__bridge MIDIManager *)refCon;
        [manager midiNotify:message];
    }
}

void LWMIDIReadProc(const MIDIPacketList *pktList, void *readProcRefCon, void *srcConnRefCon){
    @autoreleasepool {
        MIDIManager *manager = (__bridge MIDIManager *)srcConnRefCon;
//        [manager performSelectorOnMainThread:@selector(midiReceived) withObject:nil waitUntilDone:NO];
        [manager midiReceived:pktList];
    }
}


- (void)midiReceived:(const MIDIPacketList *)pktList{
    const MIDIPacket *packet = &pktList -> packet[0];
    for (int i = 0; i < pktList -> numPackets; i++) {
        
        UInt16 length = packet->length;
//        UInt64 timestamp = packet->timeStamp;
//        int data0 = length>0? packet->data[0] : 0;
        int data1 = length>1? packet->data[1] : 0;
        int data2 = length>2? packet->data[2] : 0;
        
//        NSString *message = [NSString stringWithFormat:@"%u bytes timeStamp %llu [%02x,%02x,%02x]",length, timestamp, data0, data1, data2];

//        [self.delegate showMessageOnMain:message];
        [self.delegate receiveNote:data1 state:data2];
        packet = MIDIPacketNext(packet);
    }
}

//- (void)midiReceived:(const MIDIPacketList *)pktList{
//    [self packetListToString:pktList];
//}

- (void)midiNotify:(const MIDINotification *)notification{
    switch (notification -> messageID) {
        case kMIDIMsgObjectAdded:
            [self midiObjectAdd:(const MIDIObjectAddRemoveNotification *)notification];
            break;
        case kMIDIMsgObjectRemoved:
            [self midiObjectRemove:(const MIDIObjectAddRemoveNotification *)notification];
            break;
        case kMIDIMsgSetupChanged:
        case kMIDIMsgPropertyChanged:
        case kMIDIMsgThruConnectionsChanged:
        case kMIDIMsgSerialPortOwnerChanged:
        case kMIDIMsgIOError:
            break;
            break;
    }
}

- (void)midiObjectAdd:(const MIDIObjectAddRemoveNotification *)notification{
    if (notification -> childType == kMIDIObjectType_Source) {
//        [self.delegate showMessage:@"Source Add"];
        [self.delegate connected];
        [self connectToSource];
    }
    
}

- (void)midiObjectRemove:(const MIDIObjectAddRemoveNotification *)notification{
    if (notification -> childType == kMIDIObjectType_Source) {
//        [self.delegate showMessage:@"Source Remove"];
    }
    
    if (notification -> childType == kMIDIObjectType_Destination) {
//        [self.delegate showMessage:@"Destination Remove"];
        [self.delegate removed];
    }
}

#pragma mark - Packet

- (void)packetListToString:(const MIDIPacketList *)packetList{
    const MIDIPacket *packet = &packetList -> packet[0];
    for (int i = 0; i < packetList -> numPackets; i++) {
        [self.delegate showMessage:[self packetToString:packet]];
        packet = MIDIPacketNext(packet);
    }
}

- (NSString *)packetToString:(const MIDIPacket *)packet{
    return [NSString stringWithFormat:@"bytes:%u  timeStamp:%llu [%02x,%02x,%02x]",
            packet -> length,
            packet -> timeStamp,
            (packet->length > 0)? packet->data[0] : 0,
            (packet->length > 1)? packet->data[1] : 0,
            (packet->length > 2)? packet->data[2] : 0];
}

#pragma mark - Send

- (void)sendBytes:(const UInt8*)data size:(UInt32)size{
    assert(size < 65536);
    Byte packetBuffer[size + 100];
    MIDIPacketList *packetList = (MIDIPacketList *)packetBuffer;
    MIDIPacket *packet = MIDIPacketListInit(packetList);
    packet = MIDIPacketListAdd(packetList, sizeof(packetBuffer), packet, 0, size, data);
    [self sendPacketList:packetList];
    
}

- (void)sendPacketList:(MIDIPacketList *)packetList{
    ItemCount numberDestination = MIDIGetNumberOfDestinations();
    for (ItemCount index = 0; index < numberDestination; index++) {
        MIDIEndpointRef destination = MIDIGetDestination(index);
        OSStatus error = MIDISend(self.outputPort, destination, packetList);
        if (error != noErr) {
            [self.delegate showMessage:@"Send error"];
            return;
        }
    }
}

@end

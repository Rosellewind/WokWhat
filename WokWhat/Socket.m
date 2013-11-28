//
//  Socket.m
//  WokWhat
//
//  Created by Roselle Milvich on 11/24/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import "Socket.h"
#import "Recipe.h"

static NSString *unqKey = @"6to$3";
@interface Socket ()//singleton
@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, strong) NSMutableArray *messages;
@end

@implementation Socket
- (id) init{
    if (self = [super init])
    {
        [self initNetworkCommunication];
        self.messages = [[NSMutableArray alloc]init];
    }
    return self;
}

#pragma mark - send data packets
- (void)sendDataFromString:(NSString*)string{
    NSData *data = [NSData dataWithData:[string dataUsingEncoding:NSASCIIStringEncoding]];
    [self.outputStream write:[data bytes] maxLength:[data length]];
}

- (void)sendData:(NSData*)data{
    [self.outputStream write:[data bytes] maxLength:[data length]];
}

- (void)newUser:(NSString*)username password:(NSString*)password{
    NSString *message = [NSString stringWithFormat:@"%@/newUser/%@/%@",unqKey, username, password];
    NSData *data = [NSData dataWithData:[message dataUsingEncoding:NSASCIIStringEncoding]];
    [self sendData:data];
}

- (void)sendRecipe:(Recipe*)recipe to:(NSString*)username{
    //NSData
    //NSString *message = [NSString stringWithFormat:@"%@/newUser/%@/%@",unqKey, username, password];
//    NSData *data = [NSData dataWithData:[message dataUsingEncoding:NSASCIIStringEncoding]];
//    [self sendData:data];
}

#pragma mark - init methods
- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.1.103.", 8080, &readStream, &writeStream);
    self.inputStream = (__bridge NSInputStream *)readStream;///__
    self.outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);//changes arc
    self.inputStream.delegate = self;
    self.outputStream.delegate = self;
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream open];
    [self.outputStream open];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    NSLog(@"stream event %i", (int)eventCode);
    switch (eventCode) {
        case NSStreamEventOpenCompleted:    //just to check the connection has been opened
            NSLog(@"stream opened");
            break;
        case NSStreamEventHasBytesAvailable:    // fundamental to receive messages
            NSLog(@"stream has bytes available");
            if(aStream == self.inputStream){
                uint8_t buffer[1024];
                int len;
                while ([self.inputStream hasBytesAvailable]) {
                    len = (int)[self.inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        if (nil != output){
                            NSLog(@"server said: %@",output);
                        }
                        [self messageReceived:output];
                    }
                }
            }
            break;
            break;
        case NSStreamEventErrorOccurred:    //to check issues during the connection
            NSLog(@"stream event error");
            break;
        case NSStreamEventEndEncountered:   //to close the stream when the server goes down
            NSLog(@"stream event error");
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
        default:
            NSLog(@"unknown event");
            break;
    }
}

- (void)messageReceived:(NSString*)message{
    [self.messages addObject:message];
}


@end

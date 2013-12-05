//
//  Socket.m
//  WokWhat
//
//  Created by Roselle Milvich on 11/24/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import "Socket.h"
#import "Recipe+Create.h"
#import "NSData+Base64.h"


static NSString *unqKey = @"6to$3";

@interface Socket ()
@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSString *stringCutOff;

@end

@implementation Socket


#pragma mark - initializing singleton

+ (id)sharedSocket{
    static Socket *sharedSocket;
    @synchronized(self) //for multi-threading
    {
        if (!sharedSocket)
            sharedSocket = [[Socket alloc] init];
        return sharedSocket;
    }
}

- (id) init{
    if (self = [super init])
    {
        [self initNetworkCommunication];
        self.messages = [[NSMutableArray alloc]init];
        self.isSignedIn = NO;
        self.stringCutOff = @"";
    }
    return self;
}


#pragma mark - send data packets

- (void)sendData:(NSData*)data{
    [self.outputStream write:[data bytes] maxLength:[data length]];
}

- (void)newUser:(NSString*)username password:(NSString*)password{
    NSString *message = [NSString stringWithFormat:@"%@/newUser/%@/password/%@",unqKey, username, password];
    NSData *data = [NSData dataWithData:[message dataUsingEncoding:NSASCIIStringEncoding]];
    [self sendData:data];
    self.username = username;
    self.password = password;
}

- (void)login:(NSString*)username password:(NSString*)password{
    NSString *message = [NSString stringWithFormat:@"%@/login/%@/password/%@",unqKey, username, password];
    NSData *data = [NSData dataWithData:[message dataUsingEncoding:NSASCIIStringEncoding]];
    [self sendData:data];
    self.username = username;
    self.password = password;
}

-(void) sendDocument:(UIManagedDocument*)document withMessage:(NSString*)message toUsername:(NSString*)username{
    
    //send to username
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    // Execute the fetch
    NSError *error;
    NSArray *matches = [document.managedObjectContext executeFetchRequest:request error:&error];
    // Check what happened in the fetch
    if ([matches count] > 0) {
        NSString *dataString = [matches[0] archiveString];
        NSString *string = [NSString stringWithFormat:@"%@/from/%@/password/%@/sendTo/%@/message/%@/data/%@", unqKey, self.username, self.password, username, message, dataString];
        NSMutableData *data = [NSMutableData dataWithData:[string dataUsingEncoding:NSASCIIStringEncoding]];
        [self sendData:data];
    }
}

- (void)gotDictionary:(NSDictionary*)dic{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    
}



#pragma mark - message received

- (void)messageReceived:(NSString*)message{
    NSLog(@"message:%@",message);
    NSLog(@"self.stringCutOff:%@",self.stringCutOff);

    NSArray *a = [message componentsSeparatedByString:@"/"];
    NSLog(@"****a:%@",a);
    if (self.stringCutOff.length > 0){
        NSLog(@"..............................................");
        NSString *dataString = self.stringCutOff =[self.stringCutOff stringByAppendingString:message];
        NSLog(@"dataString:%@",dataString);
        NSData * unarchive = [NSData dataFromBase64String:dataString];
        NSLog(@"unarchive11111:%@",unarchive);
        NSDictionary *dic = nil;
        @try {
            dic = [NSKeyedUnarchiver unarchiveObjectWithData:unarchive];
            NSLog(@"dic:%@",dic);
        }
        @catch (NSException *exception) {
            NSLog(@"...............fail................");
        }
        if (dic){
            self.stringCutOff = @"";
            [self gotDictionary:dic];
        }
    }
    else if (a.count > 2 && [a[0] isEqualToString:unqKey]){
        if ([a[1] isEqualToString:@"from"]){
            NSString *name = a[2];
            NSString *msg = a[4];
            int count=0;
            for (int i = 0; i < 6; i++){
                NSString *str = a[i];
                count += (str.length + 1);
            }
            NSString *dataString = [message substringFromIndex:count];
            NSLog(@"dataString:%@",dataString);

            NSData * unarchive = [NSData dataFromBase64String:dataString];
            NSLog(@"unarchive:%@",unarchive);
            NSDictionary *dic = nil;
            @try {
                dic = [NSKeyedUnarchiver unarchiveObjectWithData:unarchive];
                NSLog(@"dic:%@",dic);
            }
            @catch (NSException *exception) {
                dataString = self.stringCutOff =[self.stringCutOff stringByAppendingString:dataString];
            }
            if (dic){
                self.stringCutOff = @"";
                [self gotDictionary:dic];
            }
        }
        else{
            NSString *successOrFail = a[1];
            NSString *type = a[2];
            if ([successOrFail isEqualToString:@"success"] && ([type isEqualToString:@"newUser"] || [type isEqualToString:@"login"]))
                self.isSignedIn = YES;
            self.isSuccess = ([successOrFail  isEqual:@"success"]) ? YES:NO;
        }
    }
}


#pragma mark - init network methods

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    //swap localhost with 192.168.1.103
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"192.168.1.101", 8080, &readStream, &writeStream);
    self.inputStream = (__bridge NSInputStream *)readStream;///__
    self.outputStream = (NSOutputStream *)CFBridgingRelease(writeStream);//changes arc
    self.inputStream.delegate = self;
    self.outputStream.delegate = self;
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream open];
    [self.outputStream open];
}


#pragma mark - NSStream delegate method

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



@end

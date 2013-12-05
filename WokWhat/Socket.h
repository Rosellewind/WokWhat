//
//  Socket.h
//  WokWhat
//
//  Created by Roselle Milvich on 11/24/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Socket : NSObject<NSStreamDelegate>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) BOOL isSignedIn;
@property (nonatomic, assign) BOOL isSuccess;   //success or fail

+ (id)sharedSocket;

- (void)newUser:(NSString*)username password:(NSString*)password;
- (void)login:(NSString*)username password:(NSString*)password;
- (void) sendDocument:(UIManagedDocument*)document withMessage:(NSString*)message toUsername:(NSString*)username;
@end

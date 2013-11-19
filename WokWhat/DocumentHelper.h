//
//  DocumentHelper.h
//  WokWhat
//
//  Created by Roselle Milvich on 9/10/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^completion_block_t)(UIManagedDocument *document);

@interface DocumentHelper : NSObject

+ (NSURL*)urlForName:(NSString*)name;
+(NSArray*)arrayOfDocumentNames;
+(void)openDocumentNamed:(NSString *)name
                  usingBlock:(completion_block_t)completionBlock;
+(void)closeDocumentNamed:(NSString *)name;
+(void)deleteDocumentNamed:(NSString *)name;

@end

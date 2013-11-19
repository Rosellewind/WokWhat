//
//  DocumentHelper.m
//  WokWhat
//
//  Created by Roselle Milvich on 9/10/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import "DocumentHelper.h"

@implementation DocumentHelper

static NSMutableDictionary *openDocumentsDic;


+ (NSURL*)urlForName:(NSString*)name{
    NSURL *url=[[[NSFileManager defaultManager]
                 URLsForDirectory:NSDocumentDirectory
                 inDomains:NSUserDomainMask] lastObject];
    return [url URLByAppendingPathComponent:name];
}

+ (NSArray*)arrayOfDocumentNames{
    NSURL *docsURL=[[[NSFileManager defaultManager]
                     URLsForDirectory:NSDocumentDirectory
                     inDomains:NSUserDomainMask] lastObject];
    NSArray *urlArray = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:docsURL includingPropertiesForKeys:@[NSURLLocalizedNameKey, NSURLCreationDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
    //names in mutArray
    NSMutableArray *mutArray = [NSMutableArray new];
    for (NSURL *url in urlArray){
        [mutArray addObject:url.lastPathComponent];
    }
    return mutArray;
}


+ (void)openDocumentNamed:(NSString *)name
                    usingBlock:(completion_block_t)completionBlock
{
    if (name){
        //init openDocumentsDic if needed
        if (!openDocumentsDic)
            openDocumentsDic = [NSMutableDictionary new];
        
        //set url and document
        UIManagedDocument *document = nil;
        NSURL *url = [DocumentHelper urlForName:name];
        
        
        //see if there is already a uimanagedDocument for the name
        UIManagedDocument *doc = [openDocumentsDic objectForKey:name];
        if (doc)
            document = doc;
        else{
            //if there isn't a uimanagedDocument, create one
            document=[[UIManagedDocument alloc]initWithFileURL:url];
            [openDocumentsDic setObject:document forKey:name];
        }
        
        //see if file is created
        if (![[NSFileManager defaultManager] fileExistsAtPath:[url path]] ) {
            [document saveToURL:url
               forSaveOperation:UIDocumentSaveForCreating
              completionHandler:^(BOOL success) {
                  NSLog(@"going to create");
                  
                  //file DNE
                  if (success){
                      NSLog(@"has been created");
                      completionBlock(document);
                      
                      //kvo
                      
                      
                  }
                  if (!success) NSLog(@"couldn't create document at %@",url);
              }];
        }else if (document.documentState == UIDocumentStateClosed){
            NSLog(@"going to open");
            
            //file closed
            [document openWithCompletionHandler:^(BOOL success) {
                if (success) {
                    NSLog(@"has been opened");
                    completionBlock(document);
                }
                if (!success) NSLog(@"couldn't open document at %@",url);
            }];
        }else if (document.documentState == UIDocumentStateNormal){
            NSLog(@"is open");
            
            //file open
            completionBlock(document);
        }
        else if (document.documentState == UIDocumentStateInConflict)
            NSLog(@"UIDocumentStateInConflict");
        else if (document.documentState == UIDocumentStateSavingError)
            NSLog(@"UIDocumentStateSavingError");
        else if (document.documentState == UIDocumentStateEditingDisabled)
            NSLog(@"UIDocumentStateEditingDisabled");
        else
            NSLog(@"***No document state***");
    }
}

+(void)closeDocumentNamed:(NSString *)name{
    ;
}

+ (void)deleteDocumentNamed:(NSString *)name{
    //set url
    NSURL *url = [DocumentHelper urlForName:name];
    
    //if in openDocumentsDic, remove it
    UIManagedDocument *document = [openDocumentsDic objectForKey:name];
    if (document){
        [DocumentHelper closeDocumentNamed:name];
        [openDocumentsDic removeObjectForKey:name];
    }
    
    //if file exists, remove it
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]] )
        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
}

///memory low, could close documents not being used?
@end

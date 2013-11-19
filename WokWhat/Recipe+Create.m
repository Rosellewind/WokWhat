//
//  Recipe+Create.m
//  WokWhat
//
//  Created by Roselle Milvich on 11/19/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import "Recipe+Create.h"
#import "DocumentHelper.h"

@implementation Recipe (Create)

+(Recipe*) recipeWithName:(NSString*) name andDescription:(NSString*) descrip inDocument:(UIManagedDocument*) document{
    Recipe *recipe = nil;
    if (name.length) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                  ascending:YES]];
        
        // Execute the fetch
        NSError *error;
        NSArray *matches = [document.managedObjectContext executeFetchRequest:request error:&error];
        
        // Check what happened in the fetch
        if (!matches || ([matches count] > 1)) {
            NSLog(@"errror finding a match");
        } else if (matches.count == 0) {
            
            //create new
            recipe = [NSEntityDescription insertNewObjectForEntityForName:@"Recipe" inManagedObjectContext:document.managedObjectContext];
            recipe.name = name;
            recipe.descrip = descrip;
            recipe.dateAdded = [NSDate date];
            
            /*
            recipe.headChef = to one Chef
            recipe.plays = to many Play
             */
            
            
            //save document
            [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
                if (!success)
                    NSLog(@"error in doc saveToURL");
            }];
        }
        else {
            //already one, return it
            recipe = [matches lastObject];
        }
    }
    return recipe;
}

+(void) deleteRecipeWithName:(NSString*) name inManagedObjectContext:(NSManagedObjectContext*) context{
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    
    // Execute the fetch
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    // Check what happened in the fetch
    if (!matches || ([matches count] > 1)) {  // nil means fetch failed; more than one impossible
        NSLog(@"errror finding a match");
    } else if ([matches count] == 1) {
        [context deleteObject:[matches lastObject]];
    }
    
    //delete file
    [DocumentHelper deleteDocumentNamed:name];
}

@end

//
//  Recipe+Create.m
//  WokWhat
//
//  Created by Roselle Milvich on 11/19/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import "Recipe+Create.h"
#import "DocumentHelper.h"
#import "AppDelegate.h"
#import "Chef+Create.h"

@implementation Recipe (Create)

- (NSData*)dataFromDictionary{
    //add attributes to the dictionary
    NSArray * attributeNameArray = [[NSArray alloc] initWithArray:self.entity.attributesByName.allKeys];
    NSMutableDictionary *myDictionary = [[self dictionaryWithValuesForKeys:attributeNameArray] mutableCopy];
    
    //add relationships to the dictionary
    NSDictionary *relationshipDictionary = self.entity.relationshipsByName;
    NSLog(@"subEntities:%@",relationshipDictionary);
    
    for (NSString *key in relationshipDictionary) {
        if ([key  isEqual: @"headChef"]){
            [myDictionary setObject:[self.headChef dictionary] forKey:key];
        }
    }
    
    for(id key in myDict) {
        id value = [myDict objectForKey:key];
        [value doStuff];
    }
//    for (NSString * attributeName in attributeNameArray) {
//        [myDictionary setValue:[aDecoder decodeObjectForKey:attributeName] forKey:attributeName];
//    }
//    
//
//    NSMutableArray *array = [NSMutableArray arrayWithCapacity:ManagedObjectItems.count];
//    [[Recipe allObjects] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        Diary_item_food *food = obj;
//        NSArray *keys = [[[food entity] attributesByName] allKeys];
//        NSDictionary *dict = [obj dictionaryWithValuesForKeys:keys];
//        [array addObject:dict];
//    }];
    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:myDictionary];
    return myData;
}

//- (id)initWithCoder:(NSCoder *)aDecoder {
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Recipe" inManagedObjectContext:[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
//    
//    self = [super initWithEntity:entity insertIntoManagedObjectContext:nil];
//    NSArray * attributeNameArray = [[NSArray alloc] initWithArray:self.entity.attributesByName.allKeys];
//    
//    for (NSString * attributeName in attributeNameArray) {
//        [self setValue:[aDecoder decodeObjectForKey:attributeName] forKey:attributeName];
//    }
//    return self;
//}
//
//- (id)awakeAfterUsingCoder:(NSCoder *)aDecoder{
//    NSLog(@"awakeAfterUsingCoder");
//
//}

//
//- (void)encodeWithCoder:(NSCoder *)coder {
//    [coder encodeObject:self.descrip forKey:@"descrip"];
//    [coder encodeObject:self.dateAdded forKey:@"dateAdded"];
//    [coder encodeObject:self.name forKey:@"name"];
//    [coder encodeObject:self.identifier forKey:@"identifier"];
//    [coder encodeObject:self.headChef forKey:@"headChef"];
//}

//- (void)setHeadChef:(Chef *)headChef{
//    [self willChangeValueForKey:@"headChef"];
//    self.headChef = headChef;
//    [self didChangeValueForKey:@"headChef"];
//    [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
//        if (!success)
//            NSLog(@"error in doc saveToURL");
//    }];
//}

+ (Recipe*) recipeWithName:(NSString*) name andDescription:(NSString*) descrip inDocument:(UIManagedDocument*) document{
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
            recipe.identifier = [[recipe objectID].URIRepresentation absoluteString];
            NSLog(@"...%@",[recipe objectID].URIRepresentation);
            NSLog(@"recipe.identifier:%@",recipe.identifier);
            
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

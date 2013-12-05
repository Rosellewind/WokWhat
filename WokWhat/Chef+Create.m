//
//  Chef+Create.m
//  WokWhat
//
//  Created by Roselle Milvich on 11/28/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import "Chef+Create.h"
#import "AppDelegate.h"

@implementation Chef (Create)

- (NSDictionary*)dictionary{
    //add attributes to the dictionary
    NSArray * attributeNameArray = [[NSArray alloc] initWithArray:self.entity.attributesByName.allKeys];
    NSMutableDictionary *myDictionary = [[self dictionaryWithValuesForKeys:attributeNameArray] mutableCopy];
    myDictionary[@"dateAdded"] = [NSNumber numberWithDouble:self.dateAdded.timeIntervalSinceNow];
    return myDictionary;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Chef" inManagedObjectContext:[(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]];
    
    self = [super initWithEntity:entity insertIntoManagedObjectContext:nil];
    NSArray * attributeNameArray = [[NSArray alloc] initWithArray:self.entity.attributesByName.allKeys];
    
    for (NSString * attributeName in attributeNameArray) {
        [self setValue:[aDecoder decodeObjectForKey:attributeName] forKey:attributeName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.username forKey:@"username"];
    [coder encodeObject:self.dateAdded forKey:@"dateAdded"];
    [coder encodeObject:self.name forKey:@"name"];
}

+ (Chef*)chefWithName:(NSString*) name andUsername:(NSString*) username inManagedObjectContext:(NSManagedObjectContext *)context{
    Chef *chef = [NSEntityDescription insertNewObjectForEntityForName:@"Chef" inManagedObjectContext:context];
    chef.name = name;
    chef.username = username;
    chef.dateAdded = [NSDate date];
    return chef;
    //save?/////////////
}


@end

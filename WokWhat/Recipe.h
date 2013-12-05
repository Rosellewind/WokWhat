//
//  Recipe.h
//  WokWhat
//
//  Created by Roselle Milvich on 12/2/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Chef;

@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSString * descrip;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * ingredients;
@property (nonatomic, retain) Chef *headChef;

@end

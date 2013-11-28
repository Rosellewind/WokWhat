//
//  Chef.h
//  WokWhat
//
//  Created by Roselle Milvich on 11/28/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Recipe;

@interface Chef : NSManagedObject

@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Recipe *recipe;

@end

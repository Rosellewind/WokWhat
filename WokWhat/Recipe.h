//
//  Recipe.h
//  WokWhat
//
//  Created by Roselle Milvich on 11/19/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Recipe : NSManagedObject

@property (nonatomic, retain) NSString * descrip;
@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSString * name;

@end

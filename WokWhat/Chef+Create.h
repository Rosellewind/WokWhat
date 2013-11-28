//
//  Chef+Create.h
//  WokWhat
//
//  Created by Roselle Milvich on 11/28/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import "Chef.h"

@interface Chef (Create)

- (NSDictionary*)dictionary;
+ (Chef*)chefWithName:(NSString*) name andUsername:(NSString*) username inManagedObjectContext:(NSManagedObjectContext *)context;
@end

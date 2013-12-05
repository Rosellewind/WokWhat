//
//  Recipe+Create.h
//  WokWhat
//
//  Created by Roselle Milvich on 11/19/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import "Recipe.h"
#define RECIPE_CURRENT_KEY @"Current Recipe Key"

@interface Recipe (Create)/*<NSCoding>*/

- (NSString*)archiveString;
- (NSDictionary*)dictionaryOfIngredients;
- (void)setDictionaryOfIngredients:(NSDictionary*) dictionary;
+(Recipe*) recipeWithName:(NSString*) name andDescription:(NSString*) descrip inDocument:(UIManagedDocument*) document;
+(void) deleteRecipeWithName:(NSString*) name inManagedObjectContext:(NSManagedObjectContext*) context;

@end

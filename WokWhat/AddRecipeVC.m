//
//  AddRecipeVC.m
//  WokWhat
//
//  Created by Roselle Milvich on 9/25/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import "AddRecipeVC.h"
#import "DocumentHelper.h"
//#import "Recipe+create.h"

@interface AddRecipeVC ()

@end

@implementation AddRecipeVC

-(IBAction)finishedEnteringName:(UITextField*)sender{
    NSString *withoutSpaces = [sender.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (withoutSpaces.length >0)
        [DocumentHelper openDocumentNamed:sender.text usingBlock:^(UIManagedDocument *document) {
            if (document)
                ;//[Recipe recipeWithName:sender.text andDescription:@"temp" inDocument:document];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
}

@end

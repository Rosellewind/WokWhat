//
//  AddRecipeVC.m
//  WokWhat
//
//  Created by Roselle Milvich on 9/25/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import "AddRecipeVC.h"
#import "DocumentHelper.h"
#import "Recipe+create.h"
#import "Chef+Create.h"

@interface AddRecipeVC ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *descripTF;

@end

@implementation AddRecipeVC
- (IBAction)done:(id)sender {
    NSString *withoutSpaces = [self.nameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (withoutSpaces.length >0)
        [DocumentHelper openDocumentNamed:self.nameTF.text usingBlock:^(UIManagedDocument *document) {
            if (document){
                Recipe *recipe = [Recipe recipeWithName:self.nameTF.text andDescription:self.descripTF.text inDocument:document];
            
                //move later/////////////
                Chef *chef = [Chef chefWithName:@"Chris" andUsername:@"hotPans" inManagedObjectContext:document.managedObjectContext];
                recipe.headChef = chef;
                
                          
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
}
    
- (IBAction)Cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end

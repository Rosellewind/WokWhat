//
//  WokVC.m
//  WokWhat
//
//  Created by Roselle Milvich on 11/19/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import "WokVC.h"
#import "Recipe+Create.h"

@interface WokVC ()

@end

@implementation WokVC

#pragma mark - Getters and Setters

-(void) setDocument:(UIManagedDocument *)document{
    if (![document isEqual:self.document]){
        _document = document;
        
        ///////delete
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                ascending:YES]];
        // Execute the fetch
        NSError *error;
        NSArray *matches = [document.managedObjectContext executeFetchRequest:request error:&error];
        // Check what happened in the fetch
        if ([matches count] > 0) {
            Recipe *recipe = matches[0];
            [recipe dataFromDictionary];
            
//            NSLog(@"originalMoc:%@ original:%@",[(Recipe*)matches[0] managedObjectContext], matches[0]);
//            
//            NSData *archivedObjects = [NSKeyedArchiver archivedDataWithRootObject:matches[0]];
//            NSLog(@"archived:%@",archivedObjects);
//            NSData *objectsData = archivedObjects;
//            if ([objectsData length] > 0) {
//                Recipe *object = [NSKeyedUnarchiver unarchiveObjectWithData:objectsData];
//                NSLog(@"unarchived:%@",object);
//                NSLog(@"moc:%@ docmoc:%@",[object managedObjectContext], document.managedObjectContext);//////figure out moc
//
//            }
            
        }

        //reload
    }
}

- (IBAction)done:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Actions

- (IBAction)foodAdded:(UIButton *)sender {
    NSArray *foodArray = [NSArray arrayWithObjects:@"orange", @"eggplant", nil];
    NSString *imgName = [NSString stringWithFormat:@"%@Bits.png", [foodArray objectAtIndex:sender.tag]];
    imgName = @"foodBits.png";////////temp///////////
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    imgView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 100);
    int w = self.view.frame.size.width/2;
    int h = w*.7;
    int x = w/2;
    int y = self.view.frame.size.height - 200;
    CGRect rect = CGRectMake(x, y, w, h);
    imgView.frame =rect;
    [self.view addSubview:imgView];
    
    CGRect offset = CGRectMake(x+8, y+5, w, h);

    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        imgView.frame = offset;
        imgView.frame = rect;
    } completion:nil];
    

    

}



@end

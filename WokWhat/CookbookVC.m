//
//  CookbookVC.m
//  WokWhat
//
//  Created by Roselle Milvich on 11/18/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import "CookbookVC.h"
#import "DocumentHelper.h"
#import "Recipe+Create.h"
#import "WokVC.h"

@interface CookbookVC ()
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@property(nonatomic, strong) NSArray *tableData;
@end

@implementation CookbookVC

#pragma mark - Getters and Setters

-(void) setTableData:(NSArray *)tableData{
    if (![tableData isEqualToArray:self.tableData]){
        _tableData = tableData;
    }
    [self.leftTableView reloadData];
}

#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView)
        return self.tableData.count;
    else return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell ready
    if (tableView == self.leftTableView){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Contents Cell" forIndexPath:indexPath];
        
        //set title
        cell.textLabel.text = [self.tableData objectAtIndex:indexPath.row];
        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Contributers Cell" forIndexPath:indexPath];
        
        //set title
        cell.textLabel.text = @"fellow chef";
        return cell;
    }

}

#pragma mark - Table View Delegate



#pragma mark - Actions

- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Transitions

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = nil;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.leftTableView indexPathForCell:sender];
    }
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"To The Wok"]) {
            if ([segue.destinationViewController respondsToSelector:@selector(setDocument:)]){
                WokVC *vc = (WokVC*)segue.destinationViewController;
                [DocumentHelper openDocumentNamed:[self.tableData objectAtIndex:indexPath.row] usingBlock:^(UIManagedDocument *document) {
                    [vc performSelector:@selector(setDocument:) withObject:document];
                }];
            }
        }
    }
}

#pragma mark - Life Cycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableData = [DocumentHelper arrayOfDocumentNames];
}


@end

//
//  CookbookVC.m
//  WokWhat
//
//  Created by Roselle Milvich on 11/18/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import "CookbookVC.h"
#import "DocumentHelper.h"


@interface CookbookVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *tableData;
@end

@implementation CookbookVC

#pragma mark - Getters and Setters

-(void) setTableData:(NSArray *)tableData{
    if (![tableData isEqualToArray:self.tableData]){
        _tableData = tableData;
    }
    [self.tableView reloadData];//reloads every time to get # photos
}

#pragma mark - Getters and Setters

#pragma mark - Table View Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableData.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell ready
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Recipe Cell" forIndexPath:indexPath];
    
    //set title
    cell.textLabel.text = [self.tableData objectAtIndex:0];
    
    return cell;
}

#pragma mark - Table View Delegate



#pragma mark - Actions

- (IBAction)pop:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Life Cycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableData = [DocumentHelper arrayOfDocumentNames];
}


@end

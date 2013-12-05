//
//  WokVC.h
//  WokWhat
//
//  Created by Roselle Milvich on 11/19/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe+Create.h"


@interface WokVC : UIViewController<UIScrollViewDelegate>
@property (nonatomic, strong) UIManagedDocument *document;
@property (strong, nonatomic) Recipe *recipe;

@end

//
//  WokVC.m
//  WokWhat
//
//  Created by Roselle Milvich on 11/19/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import "WokVC.h"
#import "Recipe+Create.h"
#import "Socket.h"
#import "DocumentHelper.h"

@interface WokVC ()
@property (weak, nonatomic) IBOutlet UIView *speechBubble;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property (weak, nonatomic) IBOutlet UIScrollView *ingredientsSV;
@property (strong, nonatomic)  NSArray *ingredients;
@end

@implementation WokVC

#pragma mark - Setup

- (void)populateIngredientsSV{
    CGFloat x = 7, y = 0, width = 32, height = 46;
    int pad = 4;
    int tag = 0;
    for (NSString *ingredient in self.ingredients){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = tag;
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", ingredient]] forState:UIControlStateNormal];
        //button.imageView.motionEffects
        button.frame = CGRectMake(x, y, width, height);
        [button addTarget:self action:@selector(foodAdded:) forControlEvents:UIControlEventTouchUpInside];
        button.exclusiveTouch = NO;
        [self.ingredientsSV addSubview:button];
        x += width + pad;/////
        tag++;
    }
    self.ingredientsSV.scrollEnabled = YES;
    self.ingredientsSV.contentSize = CGSizeMake(x, height);
    self.ingredientsSV.delegate = self;
}

#pragma mark - Getters and Setters

- (void)setDocument:(UIManagedDocument *)document{
    if (![document isEqual:self.document]){
        _document = document;
        }
        //reload
}



#pragma mark - Actions

- (IBAction)pop:(id)sender {
    [self.document closeWithCompletionHandler:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender {
    self.speechBubble.hidden = NO;
}

- (IBAction)cookingSolo:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)send:(id)sender {
    [[Socket sharedSocket] sendDocument:self.document withMessage:self.messageTF.text toUsername:self.usernameTF.text];
}

- (IBAction)foodAdded:(UIButton *)sender {
    NSString *food = self.ingredients[sender.tag];
    
    //add to core data
    NSMutableDictionary *ingredients = [[self.recipe dictionaryOfIngredients] mutableCopy];
    NSString *numString = [ingredients objectForKey:food];
    if (!numString)
        ingredients[food] = @"1";
    else{
        int integer = numString.integerValue + 1;
        ingredients[food] = [NSString stringWithFormat:@"%d",integer];
    }
    [self.recipe setDictionaryOfIngredients:ingredients];

    
    //add to the wok
    [self putInWok:food];
}


#pragma mark - Life Cycle

- (void)putInWok:(NSString*)food{//3 food bits each
    NSString *imgName = [NSString stringWithFormat:@"%@Bit%i.png", food, arc4random() % 3 + 1];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    int w = 32;
    int h = 32;
    int x = arc4random() % 160 + 60;
    int y = self.view.frame.size.height - (arc4random() % 60 + 130);
    CGRect rect = CGRectMake(x, y, w, h);
    imgView.frame =rect;
    [self.view addSubview:imgView];
    
    CGRect offset = CGRectMake(x+8, y+5, w, h);
    
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
        imgView.frame = offset;
        imgView.frame = rect;
    } completion:nil];

    
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.ingredients = @[@"orange", @"eggplant", @"onion",  @"tomato", @"chicken", @"cucumber", @"mushroom", @"broccoli", @"pepper", @"carrot", @"orange", @"eggplant", @"orange", @"eggplant", @"orange"];
    [self populateIngredientsSV];
}

- (void)viewDidAppear:(BOOL)animated{
    NSMutableDictionary *ingredients = [[self.recipe dictionaryOfIngredients] mutableCopy];
    for (NSString *ingredient in ingredients){
        int num = [(NSString*)ingredients[ingredient] intValue];
        for (int i = 0; i < num; i++){
            [self putInWok:ingredient];
        }
    }
}

-(BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    NSLog(@"......");
    return YES;
}
@end

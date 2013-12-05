//
//  SignInVC.m
//  WokWhat
//
//  Created by Roselle Milvich on 11/29/13.
//  Copyright (c) 2013 Roselle Milvich. All rights reserved.
//

#import "SignInVC.h"
#import "Socket.h"

@interface SignInVC ()
@property (weak, nonatomic) IBOutlet UIView *signInView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@end

@implementation SignInVC

- (IBAction)signUp:(id)sender {
    [[Socket sharedSocket] newUser:self.usernameTF.text password:self.passwordTF.text];
}

- (IBAction)login:(id)sender {
    [[Socket sharedSocket] login:self.usernameTF.text password:self.passwordTF.text];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqual:@"isSuccess"]) {
        Socket *socket = object;
        NSLog(@"change dic:%@",change);
        if (socket.isSignedIn == YES){
            [self.usernameTF resignFirstResponder];
            [self.passwordTF resignFirstResponder];
            self.signInView.hidden = YES;
            [self performSegueWithIdentifier:@"To The Cookbook" sender:self];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Didn't work, try again" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
        
    }
}


#pragma mark - actions

- (IBAction)letsCook:(id)sender {
    if ([[Socket sharedSocket] isSignedIn] == NO) {
        self.signInView.hidden = NO;
    }
    else [self performSegueWithIdentifier:@"To The Cookbook" sender:self];
}


#pragma mark - life cycle

- (void)viewDidLoad{
    [[Socket sharedSocket] addObserver:self forKeyPath:@"isSuccess" options:NSKeyValueObservingOptionNew context:NULL];
}

@end

//
//  ConnectNetController.m
//  SmartHome
//
//  Created by Oliver on 15/3/6.
//  Copyright (c) 2015年 renren. All rights reserved.
//

// 一键联网
#import "ConnectNetController.h"

@interface ConnectNetController ()

@property (weak, nonatomic) IBOutlet UITextField *SSIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation ConnectNetController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"一键联网";
}

- (IBAction)textFieldDidEndOnExit:(UITextField *)sender {
    self.editing = NO;
}

- (void)resignTextField
{
    [self.SSIDTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)closeKeyboard:(id)sender {
    [self resignTextField];
}

- (IBAction)beginConfig:(id)sender {
    [self resignTextField];
    
    // TODO: 开始配置
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"待完善" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [alert show];
}




@end

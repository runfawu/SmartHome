//
//  DeviceAddController.m
//  SmartHome
//
//  Created by Oliver on 15/3/6.
//  Copyright (c) 2015年 renren. All rights reserved.
//

// 设备添加
#import "DeviceAddController.h"

@interface DeviceAddController ()
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *deviceNameTextField;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *deviceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviceViewTopSpaceConstraint;

@end

@implementation DeviceAddController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设备添加";
    self.deviceView.hidden = YES;
    self.codeView.backgroundColor = [UIColor clearColor];
    self.deviceView.backgroundColor = [UIColor clearColor];
}

- (IBAction)textFieldDidEndOnExit:(id)sender {
    self.editing = NO;
}

// 填写code, 点击确定
- (IBAction)codeComfirm:(id)sender {
    if (self.codeTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先输入设备的编码" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    //插座05+6位数 灯是14、15、16+6位数
    if (([self.codeTextField.text hasPrefix:@"14"]||[self.codeTextField.text hasPrefix:@"15"]||[self.codeTextField.text hasPrefix:@"16"]||[self.codeTextField.text hasPrefix:@"05"]) && self.codeTextField.text.length == 8) {
        [UIView animateWithDuration:0.2 animations:^{
            self.codeView.alpha = 0;
        } completion:^(BOOL finished) {
            self.codeView.hidden = YES;
            self.deviceView.hidden = NO;
//            self.deviceView.
            self.deviceViewTopSpaceConstraint.constant = 94;
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"设备编码格式不正确" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)saveDevice:(id)sender {
    [self.deviceNameTextField resignFirstResponder];
    
    if ( ! self.deviceNameTextField.text.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入名称" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // TODO: 数据库中查找，若无则添加
    
}


@end

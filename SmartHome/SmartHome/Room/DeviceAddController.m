//
//  DeviceAddController.m
//  SmartHome
//
//  Created by Oliver on 15/3/6.
//  Copyright (c) 2015年 renren. All rights reserved.
//

// 设备添加
#import "DeviceAddController.h"
#import "Comon.h"
#import "AppDelegate.h"
#import "SwitchEntity.h"
#import "UIView+Toast.h"

@interface DeviceAddController ()
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UITextField *deviceNameTextField;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *deviceView;
@property (weak, nonatomic) IBOutlet UILabel *deviceCodeLabel;
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
    
    if ([self.codeTextField.text hasPrefix:@"15"] && self.codeTextField.text.length == 8) { // TODO: 待完善
        [UIView animateWithDuration:0.2 animations:^{
            self.codeView.alpha = 0;
            [self.codeTextField resignFirstResponder];
        } completion:^(BOOL finished) {
            self.codeView.hidden = YES;
            self.deviceView.hidden = NO;
            self.deviceCodeLabel.text = [NSString stringWithFormat:@"设备地址: %@", self.codeTextField.text];
            [self.deviceNameTextField becomeFirstResponder];
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
    
    // 数据库中查找，若无则添加
    NSManagedObjectContext *context = APP_DELEGATE.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SwitchEntity"];
    request.predicate = [NSPredicate predicateWithFormat:@"name == %@", self.deviceNameTextField.text];
    NSArray *switchArrayOfName = [context executeFetchRequest:request error:nil];
    if (switchArrayOfName.count > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该名称已存在，请重新命名" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    request.predicate = [NSPredicate predicateWithFormat:@"code == %@", self.codeTextField.text];
    NSArray *switchArrayOfCode = [context executeFetchRequest:request error:nil];
    if (switchArrayOfCode.count > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该设备已存在" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [self saveNewSwitchToCoreData];
}

- (void)saveNewSwitchToCoreData
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SwitchEntity"];
    request.predicate = [NSPredicate predicateWithFormat:@"type == %@ AND roomID == %@", SWITCH_TYPE_ADD, [NSNumber numberWithInteger:self.roomID]];
    
    NSArray *fakeSwitchArray = [APP_DELEGATE.managedObjectContext executeFetchRequest:request error:nil];
    NSParameterAssert(fakeSwitchArray.count == 1);
    SwitchEntity *fakeSwitch = fakeSwitchArray[0];
    [APP_DELEGATE.managedObjectContext deleteObject:fakeSwitch];
    
    SwitchEntity *newSwitch = [NSEntityDescription insertNewObjectForEntityForName:@"SwitchEntity" inManagedObjectContext:APP_DELEGATE.managedObjectContext];
    newSwitch.name = self.deviceNameTextField.text;
    newSwitch.isOn = @NO;
    newSwitch.roomID = @(self.roomID);
    newSwitch.type = [self.codeTextField.text hasPrefix:@"15"] ? SWITCH_TYPE_LIGHT: SWITCH_TYPE_SOCKET;
    newSwitch.imageName = kSwitchOffImageName;
    newSwitch.code = self.codeTextField.text;
    newSwitch.roomImageData = UIImagePNGRepresentation([UIImage imageNamed:@"Account_Cloud"]); // 可能有问题
    
    [APP_DELEGATE saveContext];
    [APP_DELEGATE createAddButtonWithRoomID:self.roomID];
    
    [self.view makeToast:@"已保存" duration:1 position:@"center"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadSwitchData" object:nil userInfo:nil];
    });
}

@end

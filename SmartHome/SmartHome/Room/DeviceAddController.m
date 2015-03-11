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

@property (weak,nonatomic) IBOutlet UILabel *deviceCodeLabel;

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
            self.deviceCodeLabel.text=[NSString stringWithFormat:@"设备地址:%@",self.codeTextField.text];
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
    
    DeviceDB *db=[DeviceDB sharedInstance];
    
    //写入light表
    if ([self.codeTextField.text hasPrefix:@"14"]||[self.codeTextField.text hasPrefix:@"15"]||[self.codeTextField.text hasPrefix:@"16"]) {
        //先写如Light表再写如Register表
        
        NSMutableArray *fields = [[NSMutableArray alloc]init];
        NSMutableArray *values = [[NSMutableArray alloc]init];
        
        [fields addObject:@"mac"];
        
        [values addObject:self.codeTextField.text];
      
        if(![db insertWithTable:LIGHT_TABLE fields:fields values:values])
        {
            NSLog(@"写入light表失败");
        }else{
            //取出ID 写入register表
            if ([fields count]>0) {
                [fields removeAllObjects];
            }
            if ([values count]>0) {
                [values removeAllObjects];
            }
            Light *light=[db getLightWithMac:self.codeTextField.text];
            [fields addObject:@"lightId"];
            [fields addObject:@"deviceName"];
            [fields addObject:@"roomId"];
            [fields addObject:@"roomName"];
            
            [values addObject:[NSNumber numberWithInt:light.lightId]];
            [values addObject:self.deviceNameTextField.text];
            [values addObject:[NSNumber numberWithInt:100]];
            [values addObject:@"客厅"];
            
            if(![db insertWithTable:DEVICE_TABLE fields:fields values:values])
            {
                NSLog(@"写入device表失败");
            }
        }
    }else if ([self.codeTextField.text hasPrefix:@"05"]){
        NSMutableArray *fields = [[NSMutableArray alloc]init];
        NSMutableArray *values = [[NSMutableArray alloc]init];
        
        [fields addObject:@"mac"];
        
        [values addObject:self.codeTextField.text];
        
        if(![db insertWithTable:SOCKET_TABLE fields:fields values:values])
        {
            NSLog(@"写入socket表失败");
        }else{
            //取出ID 写入register表
            if ([fields count]>0) {
                [fields removeAllObjects];
            }
            if ([values count]>0) {
                [values removeAllObjects];
            }
            Socket *socket=[db getSocketWithMac:self.codeTextField.text];
            [fields addObject:@"socketId"];
            [fields addObject:@"deviceName"];
            [fields addObject:@"roomId"];
            [fields addObject:@"roomName"];
            
            [values addObject:[NSNumber numberWithInt:socket.socketId]];
            [values addObject:self.deviceNameTextField.text];
            [values addObject:[NSNumber numberWithInt:100]];
            [values addObject:@"客厅"];
            
            if(![db insertWithTable:DEVICE_TABLE fields:fields values:values])
            {
                NSLog(@"写入device表失败");
            }
        }
    
        }
}

@end

//
//  AddHostViewController.h
//  SmartHome
//
//  Created by micheal on 15/3/2.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncUdpSocket.h"

@interface AddHostViewController : UIViewController{
    
}

@property (nonatomic,strong) IBOutlet UITextField *wifiName;
@property (nonatomic,strong) IBOutlet UITextField *wifiPassword;

@property (nonatomic,strong) IBOutlet UIButton *configureNetWorkButton;

@property (nonatomic,strong) GCDAsyncUdpSocket *socket;

-(IBAction)configureNetWork:(id)sender;


@end

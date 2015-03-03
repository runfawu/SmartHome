//
//  AccountSynchronousViewController.h
//  SmartHome
//
//  Created by micheal on 15/3/2.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountSynchronousViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) IBOutlet UIButton *synchronousToCloudButton;
@property (nonatomic,strong) IBOutlet UIButton *synchronousToLocalButton;

-(IBAction)synchronousDataToCloud:(id)sender;
-(IBAction)synchronousDataToLocal:(id)sender;

@end

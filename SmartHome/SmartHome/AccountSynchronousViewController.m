//
//  AccountSynchronousViewController.m
//  SmartHome
//
//  Created by micheal on 15/3/2.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "AccountSynchronousViewController.h"

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

@interface AccountSynchronousViewController ()

@end

@implementation AccountSynchronousViewController

@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.synchronousToCloudButton.backgroundColor=[UIColor colorWithRed:102.0/255 green:204.0/255 blue:51.0/255 alpha:1.0];
    self.synchronousToCloudButton.layer.cornerRadius=5.0;
    
    self.synchronousToLocalButton.backgroundColor=[UIColor colorWithRed:102.0/255 green:204.0/255 blue:51.0/255 alpha:1.0];
    self.synchronousToLocalButton.layer.cornerRadius=5.0;
    
    // Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark SynchrounsData
-(IBAction)synchronousDataToCloud:(id)sender{
    
}

-(IBAction)synchronousDataToLocal:(id)sender{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

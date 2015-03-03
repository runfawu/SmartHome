//
//  AddHostViewController.h
//  SmartHome
//
//  Created by micheal on 15/3/2.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddHostViewController : UIViewController

@property (nonatomic,strong) IBOutlet UIView *linkedView;
@property (nonatomic,strong) IBOutlet UILabel *linkedNameLabel;
@property (nonatomic,strong) IBOutlet UILabel *linkedNoticeLabel;

@property (nonatomic,strong) IBOutlet UITableView *hostTableView;


@end

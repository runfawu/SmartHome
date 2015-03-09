//
//  AddViewSubview.h
//
//  Created by Tech3 on 15/3/3.
//  Copyright (c) 2015年 Tech3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRoomViewSubview : UIView
@property (weak, nonatomic) IBOutlet UIButton *AddBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
+ (instancetype)loadNib;
@end

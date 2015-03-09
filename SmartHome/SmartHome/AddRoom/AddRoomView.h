//
//  AddView.h
//
//  Created by Tech3 on 15/3/3.
//  Copyright (c) 2015年 Tech3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRoomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

+ (instancetype)loadNib;
@end

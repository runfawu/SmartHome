//
//  GridView.h
//  SmartHome
//
//  Created by Oliver on 15/3/2.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchObject.h"

@class GridView;
@protocol GridViewDelegate <NSObject>

- (void)gridViewAddSwitch:(GridView *)gridView;

@end

@interface GridView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (nonatomic, assign) BOOL onOffFlag;
@property (nonatomic, weak) id<GridViewDelegate> delegate;

@property (nonatomic, strong) SwitchObject *switchObj;

+ (GridView *)getNibInstance;

@end

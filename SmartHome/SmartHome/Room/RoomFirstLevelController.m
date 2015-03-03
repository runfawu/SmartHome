//
//  RoomFirstLevelController.m
//  SmartHome
//
//  Created by Oliver on 15/3/2.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "RoomFirstLevelController.h"
#import "GridView.h"
#import "SwitchObject.h"

#define kGridViewTag         101

static const int column = 3;
static const int gridWith = 100;
static const int gridHeight = 100;

@interface RoomFirstLevelController ()<UITableViewDataSource,
                                       UITableViewDelegate,
                                       UIImagePickerControllerDelegate,
                                       UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UITableView *aTableView;
@property (nonatomic, strong) NSMutableArray *switchArray;

@end

@implementation RoomFirstLevelController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
    [self addTapToImageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - Private methods
- (void)setup
{
    self.aTableView.backgroundColor = [UIColor purpleColor];
    self.switchArray = [NSMutableArray array];
    for (int i = 0; i < 20; i ++) {
        SwitchObject *object = [[SwitchObject alloc] init];
        object.switchName = [NSString stringWithFormat:@"开关%02d",i + 1];
        object.switchFlag = NO;
        
        [self.switchArray addObject:object];
    }
    
    SwitchObject *object = [self.switchArray lastObject];
    object.switchName = @"添加设备";
}

#pragma mark - Tap image
- (void)addTapToImageView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chageThumbnailImage:)];
    
    [self.thumbnailImageView addGestureRecognizer:tap];
}

- (void)chageThumbnailImage:(UITapGestureRecognizer *)tap
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    //[picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.thumbnailImageView.image = info[UIImagePickerControllerEditedImage];
    // TODO: 图片数据写进数据库
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView dataSource && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int value = self.switchArray.count % column > 0 ? 1 : 0;
    int line = (int)self.switchArray.count / column + value;
    
    return line * gridHeight + 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SwitchCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    CGFloat contextWidth = self.aTableView.bounds.size.width;
    CGFloat contextHeight = ((self.switchArray.count-1)/column + 1 ) * gridHeight;
    CGFloat xGap = (contextWidth - column * gridWith) / (column + 1);
    CGFloat yGap = (contextHeight - ((self.switchArray.count-1)/column + 1) * gridHeight) / ((self.switchArray.count-1)/column + 2);
    
    for (int i = 0; i < self.switchArray.count; i ++) {
        CGFloat X = xGap + i % column * (gridWith + xGap);
        CGFloat Y = yGap + i / column * (gridHeight + yGap);
        
        SwitchObject *object = self.switchArray[i];
        
        GridView *gridView = [GridView getNibInstance];
        gridView.frame = CGRectMake(X, Y, gridWith, gridHeight);
        gridView.tag = kGridViewTag + i;
        gridView.stateLabel.text = object.switchName;
        if (i == self.switchArray.count - 1) {
            
        } else {
            
        }
        
        [cell.contentView addSubview:gridView];
    }
    
    
    return cell;
}

@end

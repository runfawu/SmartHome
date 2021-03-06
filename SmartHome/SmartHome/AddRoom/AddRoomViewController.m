//
//  AddViewController.m
//
//  Created by Tech3 on 15/3/3.
//  Copyright (c) 2015年 Tech3. All rights reserved.
//

#define WIDTH 100
#define HEIGHT 100

static const int column = 3;
static const int width = 100;
static const int height = 100;

#import "AddRoomViewController.h"
#import "AddRoomViewController.h"
#import "AddRoomView.h"
#import "AddRoomEditView.h"
#import "AddRoomViewSubview.h"
#import "DeviceDB.h"
#import "Devices.h"
#import "AppDelegate.h"

@interface AddRoomViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *addTableView;

@property (nonatomic, strong) NSMutableArray *addArray;//图片数组
@property (nonatomic, strong) NSMutableArray *nameArray;//名字数组
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UITableView *titleTableView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic,strong) DeviceDB *db;

@end

@implementation AddRoomViewController
{
    NSMutableDictionary *addDic;
    AddRoomViewSubview *addView;
    AddRoomEditView *editView;
    NSInteger viewTag;//长按view的tag；
}

@synthesize roomArray;


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.addTableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取房间数据
    self.roomArray=[NSMutableArray array];
     self.db=[DeviceDB sharedInstance];
    [self.db connect];
    
    NSArray *rmArray=[self.db getDevicesRegister];
    [self.roomArray addObjectsFromArray:rmArray];
    
    [self.addTableView reloadData];
    [self.titleTableView reloadData];
    [self updateData];
    self.addTableView.tag = 120;
    self.addTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.addTableView.dataSource = self;
    self.addTableView.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark ------------- 获取到 模拟的 字典数组----------------
- (void)updateData
{
    [self addButtion];
}

#pragma mark -----------------添加按钮--------------------
- (void)addButtion
{
    Devices *device=[[Devices alloc] init];
    device.roomName=@"添加";
    [self.roomArray addObject:device];
}


#pragma mark ---------------------uitableviewdelegate-------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _titleTableView) {
        return 30;
    }
    int value = self.roomArray.count % column > 0 ? 1 : 0;
    int line = (int)self.roomArray.count / column + value;
    return line * 100 + 10;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _titleTableView) {
        return 2;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.titleTableView) {
        static NSString *identifier = @"EditCell";
        UITableViewCell *editCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        if (editCell == nil) {
            editCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        NSArray *titleArray = @[@"编辑该房间",@"删除该房间"];
        editCell.textLabel.text = titleArray[indexPath.row];
        return editCell;
    }
    static NSString *identifier = @"AddCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    CGFloat contextWidth = self.addTableView.frame.size.width;
    //横向间距
    CGFloat xGap = (contextWidth - column * WIDTH)/ (column + 1);
    //    CGFloat yGap = (contextHeight - ((self.addArray.count - 1)/column + 1) * HEIGHT) / ((self.addArray.count - 1)/column + 2);
    CGFloat yGap = 0;
    
    for (int i = 0; i < self.roomArray.count; i ++) {
        CGFloat XA = xGap + i % column * (width + xGap);
        CGFloat YA =  yGap + i / column * (height + yGap);
       
        Devices *device=[self.roomArray objectAtIndex:i];
        
        AddRoomView *aView = [AddRoomView loadNib];
        
        aView.tag = i ;
        [aView.addButton setBackgroundImage:nil forState:UIControlStateNormal];
        aView.nameLabel.text = device.roomName;
        
        if ( aView.tag == self.roomArray.count - 1) {
            [aView.addButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
        }else{
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
            aView.addButton.enabled = NO;
            [aView addGestureRecognizer:longPress];
        }
        aView.frame = CGRectMake(XA, YA, width,height);
        [cell.contentView addSubview:aView];
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _titleTableView) {
        switch (indexPath.row) {
            case 0:
            {
                //跳出编辑界面：修改名称：
                [self createEditView];
            }
                break;
            case 1:
            {
                //删除
                [self deleteView];
            }
                break;
            default:
                break;
        }
    }
}

//半透明背景View
- (UIView *)backgroundView
{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [_bgView setTag:1000];
    [_bgView setBackgroundColor:[UIColor blackColor]];
    [_bgView setAlpha:0.5];
    return _bgView;
}

#pragma mark ----------------编辑界面-------------
- (void)createEditView
{
    [_titleTableView removeFromSuperview];
    [_titleView removeFromSuperview];
    [addView removeFromSuperview];
    editView = [AddRoomEditView loadEditNib];
    editView.center = self.view.center;
    editView.nameTextField.delegate = self;
    editView.picImageView.image = [UIImage imageNamed:[self.addArray[viewTag] objectForKey:@"pic"]];
    [editView.saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view.window addSubview:editView];
    [self createGesture];
}

- (void)save
{
    [editView.nameTextField resignFirstResponder];
    if (![editView.nameTextField.text isEqualToString:@""]) {
        [self.addArray[viewTag] setObject:editView.nameTextField.text forKey:@"name"];
        [self removeViews];
        [self.addTableView reloadData];
    }else{
        NSLog(@"该名称已经存在");
    }
}

#pragma mark -----------------删除---------------
- (void)deleteView
{
   
    NSLog(@"sjdkjfjkskjdf :%@",self.roomArray[viewTag]);
    Devices *device=self.roomArray[viewTag];
    if (![self.db deleteWithTable:@"DevicesRegister" field:@"roomId" value:[NSString stringWithFormat:@"%d",device.roomId]]) {
        NSLog(@"删除房间失败!");
    }else{
        if (self.roomArray.count>0) {
            [self.roomArray removeAllObjects];
        }
        
        NSArray *rmArray=[self.db getDevicesRegister];
        [self.roomArray addObjectsFromArray:rmArray];
        
        [self addButtion];
        [self removeViews];
    }

    [self.addTableView reloadData];
}

#pragma mark -----------------添加界面---------------
- (void)add
{
    _bgView = [self backgroundView];
    [self.view.window addSubview:_bgView ];
    addView = [AddRoomViewSubview loadNib];
    addView.center = self.view.center;
    
    [addView.AddBtn addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view.window addSubview:addView ];
    addView.nameTextField.delegate = self;
    [self createGesture];
}

- (void)addClick
{
    if (![addView.nameTextField.text isEqualToString:@""]) {
        
        NSMutableArray *deviceFields = [[NSMutableArray alloc]init];
        NSMutableArray *deviceValues = [[NSMutableArray alloc]init];
        
        [deviceFields addObject:@"roomId"];
        [deviceFields addObject:@"roomName"];
        
        //获取roomID
        AppDelegate *delegate=[UIApplication sharedApplication].delegate;
        NSInteger roomID=delegate.roomID;
        [deviceValues addObject:[NSNumber numberWithInteger:roomID]];
        [deviceValues addObject:addView.nameTextField.text];
        if(! [self.db insertWithTable:@"DevicesRegister" fields:deviceFields values:deviceValues])
        {
            NSLog(@"health table 存储记录失败");
        }else{
            delegate.roomID+=1;
            if (self.roomArray.count>0) {
                [self.roomArray removeAllObjects];
            }
            
            NSArray *rmArray=[self.db getDevicesRegister];
            [self.roomArray addObjectsFromArray:rmArray];
            
            [self addButtion];
            [self removeViews];
        }

        [self.addTableView reloadData];
    }else{
        NSLog(@"请输入名称");
    }
}

#pragma mark -------------------UITextFieldDelegate----------
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (editView) {
        [self changeFrameWithYValue:80. withView:editView];
    }
    if (addView) {
        [self changeFrameWithYValue:100. withView:addView];
    }
}

- (void)changeFrameWithYValue:(CGFloat)YValue withView:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin.y = YValue;
    [UIView animateWithDuration:0.25 animations:^{
        view.frame = frame;
    }];
}

#pragma mark -------------------长按手势事件-----------------
- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    //保存长按View 的数据
    UIView *aview = gesture.view;
    viewTag = aview.tag;
    NSLog(@"aaa:%ld",viewTag);
    //创建tableview
    if ([gesture state] == UIGestureRecognizerStateBegan){
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 60)];
        _titleView .layer.borderWidth = 1;
        _titleView .layer.borderColor = [[UIColor blackColor]CGColor];
        _titleView.backgroundColor = [UIColor whiteColor];
        _titleView.tag = 110;
        _titleTableView = [[UITableView alloc]init];
        _titleTableView.frame = CGRectMake(0, 0, 280, 60) ;
        _titleTableView .showsHorizontalScrollIndicator = NO;
        _titleTableView .showsVerticalScrollIndicator = NO;
        _titleTableView .scrollEnabled = NO;
        _titleTableView .delegate = self;
        _titleTableView .dataSource = self;
        _titleTableView .backgroundColor = [UIColor clearColor];
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _titleView .center = _bgView.center;
        [_bgView setTag:1000];
        [_bgView setBackgroundColor:[UIColor blackColor]];
        [_bgView setAlpha:0.5];
        [self.view.window addSubview:_bgView];
        [_titleView addSubview:_titleTableView];
        [self.view.window addSubview:_titleView ];
        [self createGesture];
        
    }
}
- (void)createGesture
{
    UITapGestureRecognizer *tapWin = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeViews)];
    [_bgView addGestureRecognizer:tapWin];
    
}

- (void)removeViews
{
    [_bgView removeFromSuperview];
    if (editView) {
        [editView removeFromSuperview];
    }
    if (_titleTableView) {
        [_titleView  removeFromSuperview];
        [_titleTableView removeFromSuperview];
    }
    if (addView) {
        [addView removeFromSuperview];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

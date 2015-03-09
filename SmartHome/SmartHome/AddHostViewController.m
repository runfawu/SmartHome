//
//  AddHostViewController.m
//  SmartHome
//
//  Created by micheal on 15/3/2.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "AddHostViewController.h"
#import "Common.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "AppDelegate.h"

@interface AddHostViewController ()

@property (nonatomic) Reachability *wifiReachability;

@end

@implementation AddHostViewController

@synthesize wifiName;
@synthesize wifiPassword;
@synthesize configureNetWorkButton;

@synthesize socket;
@synthesize uartData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.uartData=[NSMutableData data];
    //添加开始符
    [self.uartData appendData:[Common getBeginCode]];
    
    self.configureNetWorkButton.layer.cornerRadius=8.0;
    self.configureNetWorkButton.layer.borderWidth=1.0;
    self.configureNetWorkButton.layer.borderColor=[UIColor grayColor].CGColor;
    
    self.wifiName.borderStyle=UITextBorderStyleNone;

    self.wifiPassword.borderStyle=UITextBorderStyleNone;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.wifiReachability=[Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
    [self updateInterfaceWithReachability:self.wifiReachability];
    
    //连接socket
    [self socketConnect];
    
    // Do any additional setup after loading the view.
}

/*!
 * Called by Reachability whenever status changes.
 */
- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    [self updateInterfaceWithReachability:curReach];
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    NSDictionary *wifiDic;
    switch (netStatus) {
        case ReachableViaWiFi:
            wifiDic=[Common fetchSSIDInfo];
            self.wifiName.text=[wifiDic objectForKey:@"SSID"];
            
            break;
        default:
            [self.view makeToast:@"当前网络环境不在WiFi环境下，请连接WiFi" duration:2.0 position:CSToastPositionCenter];
            
            break;
    }
}

//配置控制码
-(NSMutableData *)configureControlCode{
    NSMutableData *controlCodeData=[NSMutableData data];
    //命令识别码
    Byte orderByte[]={0xD1};
    NSData *ordeData=[NSData dataWithBytes:orderByte length:1];
    //Wifi 名称
    NSData *apNameData=[Common hexBytesWithString:self.wifiName.text];
    //中间
    Byte midleByte[]={0x0d};
    NSData *midleData=[NSData dataWithBytes:midleByte length:1];
    //Wifi 密码
    NSData *apPwData=[Common hexBytesWithString:self.wifiPassword.text];
    [controlCodeData appendData:ordeData];
    [controlCodeData appendData:apNameData];
    [controlCodeData appendData:midleData];
    [controlCodeData appendData:apPwData];
    
    return controlCodeData;
}

//开始配置网络
-(IBAction)configureNetWork:(id)sender{
    //判断密码和网络环境
    if (self.wifiPassword.text.length>0) {
        NetworkStatus netStatus=[[Reachability reachabilityForLocalWiFi] currentReachabilityStatus];
        switch (netStatus) {
            case ReachableViaWiFi:
                [self createUARTByte];
                [self.socket sendData:self.uartData toHost:[Common localWiFiIPAddress] port:9527 withTimeout:-1 tag:1];
                break;
            default:
                [self.view makeToast:@"当前网络环境不在WiFi环境下，请连接WiFi" duration:2.0 position:CSToastPositionCenter];
                
                break;
        }
    }else{
        
    }
}

-(void)createUARTByte{
    //获取控制码
    NSMutableData *controlCodeData=[self configureControlCode];
    //获取长度
    NSInteger uartLength=11+[controlCodeData length];
    Byte lengthByte[1];
    lengthByte[0]=uartLength;
    //添加长度
    NSData *lengthData=[NSData dataWithBytes:lengthByte length:1];
    //目标Mac
    NSData *targetMacData=[Common hexBytesWithOriginMacString:@"01ffffff"];
    //源Mac
    NSString *currentTime=[Common getCurrentTime];
    NSData *originMacData=[Common hexBytesWithOriginMacString:currentTime];
    
    //信息码
    NSData *infoCodeData=[Common getInfomationCode];
    //顺序码
    Byte orderByte[1];
    AppDelegate *delegate =[[UIApplication sharedApplication] delegate];
    orderByte[0]=delegate.orderCode;
    delegate.orderCode+=1;
    if (delegate.orderCode>255) {
        delegate.orderCode=0;
    }
    
    NSData *orderCodeData=[NSData dataWithBytes:orderByte length:1];
    
    [self.uartData appendData:lengthData];
    [self.uartData appendData:targetMacData];
    [self.uartData appendData:originMacData];
    [self.uartData appendData:infoCodeData];
    [self.uartData appendData:orderCodeData];
    [self.uartData appendData:controlCodeData];
    
    //获取验证码
    Byte checkCode[1];
    uint8_t *bytes=(uint8_t *)[self.uartData bytes];
    for (int i=2; i<[self.uartData length]-1; i++) {
        checkCode[0]=(Byte)(checkCode[0] +bytes[i]);
    }
    //封装完byte数组
    NSData *checkCodeData=[NSData dataWithBytes:checkCode length:1];
    [self.uartData appendData:checkCodeData];
}

-(void)socketConnect{
    if (self.socket==nil) {
        GCDAsyncUdpSocket *udpSocket=[[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        self.socket=udpSocket;
        udpSocket=nil;
    }
    NSError *error=nil;
    //实现服务器发送的消息
    if (![self.socket bindToPort:0 error:&error]) {
        NSLog(@"Error binding:%@",error);
        return;
    }
    if (![self.socket beginReceiving:&error]) {
        NSLog(@"Error receiving:%@",error);
        return;
    }
}

#pragma mark -
#pragma mark UDPSocket Delegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    // You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    // You could add checks here
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
//    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    if (msg)
//    {
//        [self logMessage:FORMAT(@"RECV: %@", msg)];
//    }
//    else
//    {
//        NSString *host = nil;
//        uint16_t port = 0;
//        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
//        
//        [self logInfo:FORMAT(@"RECV: Unknown message from: %@:%hu", host, port)];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
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

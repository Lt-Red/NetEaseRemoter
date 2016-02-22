//
//  ViewController.m
//  ConnNetEase
//
//  Created by 罗小红 on 16/2/2.
//  Copyright © 2016年 LtRed. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
#import "MBProgressHUD+MJ.h"

static const uint16_t kTestPort = 30303;

//      CMD             key-code

#define CMD_NEXT        @"124"
#define CMD_PVR         @"123"
#define CMD_VOL_UP      @"126"
#define CMD_VOL_DOWN    @"125"
#define CMD_PAUSE       @"49"
#define CMD_LOVE        @"37"

@interface ViewController ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *clientSocket;

@property (weak, nonatomic) IBOutlet UITextField *portTextField;

@property (weak, nonatomic) IBOutlet UITextField *ipTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUp];
    
}

#pragma mark -- Button点击事件

- (IBAction)ConnectToHost:(id)sender {
    
    NSError *error = nil;
    
    BOOL success = NO;
    
    int port = [_portTextField.text intValue];
    
    if ( 0>=port || port>65535 ) {
        
        port = kTestPort;
        
    }
    
    NSString* ipStr = _ipTextField.text;
    
    if ([ipStr isEqualToString:@""]) {
        
        ipStr = @"192.168.11.124";
        
        [MBProgressHUD showError:@"fill your ip addr" toView:self.view];
    }
    
    success = [self.clientSocket connectToHost:ipStr onPort:port error:&error];
    
    if (!success) {
        
        NSLog(@"%@",error);
        
    }
    
}

- (IBAction)nextSong {
    
    NSData* data = [CMD_NEXT dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.clientSocket writeData:data withTimeout:-1 tag:1];
    
}

- (IBAction)priviorSong {
    
    NSData* data = [CMD_PVR dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.clientSocket writeData:data withTimeout:-1 tag:1];
    
}
- (IBAction)volumeUp:(id)sender
{
    NSData* data = [CMD_VOL_UP dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.clientSocket writeData:data withTimeout:-1 tag:1];
}
- (IBAction)volumeDown:(id)sender
{
    NSData* data = [CMD_VOL_DOWN dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.clientSocket writeData:data withTimeout:-1 tag:1];
}
- (IBAction)love:(id)sender
{
    NSData* data = [CMD_LOVE dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.clientSocket writeData:data withTimeout:-1 tag:1];
}
- (IBAction)pause:(id)sender
{
    NSData* data = [CMD_PAUSE dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.clientSocket writeData:data withTimeout:-1 tag:1];
}

#pragma mark -- GCDAsyncSoket

- (void)setUp {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
}

- (void)tearDown {
    
    [self.clientSocket disconnect];
    self.clientSocket = nil;
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"didConnectToHost %@ %@ %d", sock, host, port);
    });
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"socketDidDisconnect %@",err);
    });
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length] - 0)];
    NSString *msg = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (msg)
        {
            NSLog(@"%@",msg);
        }
        else
        {
            NSLog(@"Error converting received data into UTF-8 String");
        }
    });
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"didWriteDataWithTag = %ld",tag);
        
        [sock readDataWithTimeout:-1 tag:1];
    });
}


@end

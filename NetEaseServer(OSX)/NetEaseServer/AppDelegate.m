//
//  AppDelegate.m
//  NetEaseNextSong
//
//  Created by 罗小红 on 16/2/2.
//  Copyright © 2016年 LtRed. All rights reserved.
//

#import "AppDelegate.h"
#import <Carbon/Carbon.h>

#import "GCDAsyncSocket.h"

#define WELCOME_MSG  0
#define ECHO_MSG     1

#define WARNING_MSG  2

#define READ_TIMEOUT 120.0
#define READ_TIMEOUT_EXTENSION 10.0

#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]

static const uint16_t kTestPort = 30303;

@interface AppDelegate ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *serverSocket;
@property (nonatomic, strong) GCDAsyncSocket *acceptedServerSocket;

@property (nonatomic, strong) NSMutableArray *connectedSockets;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    CGFloat thickness = [[NSStatusBar systemStatusBar] thickness];
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:thickness]; //正方形
    _menulet = [[Menulet alloc]initWithFrame:(NSRect){.size={thickness, thickness}}];
    _controller = [[MenuletController alloc] init];
    _menulet.delegate = _controller;
    
    [_statusItem setView:_menulet];
    
    [self setUp]; 
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark -- GCDAsyncSocket

- (void)setUp {
    
    _connectedSockets = [[NSMutableArray alloc] initWithCapacity:1];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:queue];
    
    NSError *error = nil;
    BOOL success = NO;
    
    success = [self.serverSocket acceptOnPort:kTestPort error:&error];
    
    if (!success) {
        NSLog(@"%@",error);
    }
}

-(BOOL)connectToPort:(int)port
{
    [self tearDown];
    
    [self setUp];
    
    NSError *error = nil;
    BOOL success = NO;
    
    
    success = [self.serverSocket acceptOnPort:port error:&error];
    
    if (!success) {
        NSLog(@"%@",error);
    }
    
    return success;
}

- (void)tearDown {
    
    [self.serverSocket disconnect];
    [self.acceptedServerSocket disconnect];
    
    // Stop any client connections
    @synchronized(_connectedSockets)
    {
        NSUInteger i;
        for (i = 0; i < [_connectedSockets count]; i++)
        {
            // Call disconnect on the socket,
            // which will invoke the socketDidDisconnect: method,
            // which will remove the socket from the list.
            [[_connectedSockets objectAtIndex:i] disconnect];
        }
    }
    
    self.serverSocket = nil;
    self.acceptedServerSocket = nil;
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    
    @synchronized(_connectedSockets)
    {
        [_connectedSockets addObject:newSocket];
    }
    
    NSString *host = [newSocket connectedHost];
    UInt16 port = [newSocket connectedPort];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",FORMAT(@"Accepted client %@:%hu", host, port));
        
        NSString *welcomeMsg = @"Welcome to the AsyncSocket Echo Server\r\n";
        NSData *welcomeData = [welcomeMsg dataUsingEncoding:NSUTF8StringEncoding];
        
        [newSocket writeData:welcomeData withTimeout:-1 tag:WELCOME_MSG];
        
        [newSocket readDataWithTimeout:-1 tag:1];
    });
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [sock readDataWithTimeout:-1 tag:1];
    });

}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString* cmdStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"didReadData = %@",cmdStr);
        
        [self excuteCMD:[cmdStr intValue]];
        
        [sock readDataWithTimeout:-1 tag:1];
        
        // Echo message back to client
        [sock writeData:data withTimeout:-1 tag:ECHO_MSG];
    });
    
    
}

/**
 * This method is called if a read has timed out.
 * It allows us to optionally extend the timeout.
 * We use this method to issue a warning to the user prior to disconnecting them.
 **/
//- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag
//                 elapsed:(NSTimeInterval)elapsed
//               bytesDone:(NSUInteger)length
//{
//    if (elapsed <= READ_TIMEOUT)
//    {
//        NSString *warningMsg = @"Are you still there?\r\n";
//        NSData *warningData = [warningMsg dataUsingEncoding:NSUTF8StringEncoding];
//        
//        [sock writeData:warningData withTimeout:-1 tag:WARNING_MSG];
//        
//        return READ_TIMEOUT_EXTENSION;
//    }
//    
//    return 0.0;
//}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (sock != _serverSocket)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Client Disconnected");
        });
        
        @synchronized(_connectedSockets)
        {
            [_connectedSockets removeObject:sock];
        }
    }
}

#pragma mark -- 控制网易云操作快捷键

//      CMD             key-code

#define CMD_NEXT        124
#define CMD_PVR         123
#define CMD_VOL_UP      126
#define CMD_VOL_DOWN    125
#define CMD_PAUSE       49
#define CMD_LOVE        37

-(void)excuteCMD:(int) cmd
{
    
    NSAppleEventDescriptor *eventDescriptor = nil;
    NSAppleScript *script = nil;
    
    NSString *scriptSource = FORMAT(@"tell application \"System Events\"\r"
                                    "key code %d using {command down, option down} -- shift-command-right \r"
                                    "end tell",cmd);
    
    if (scriptSource)
    {
        script = [[NSAppleScript alloc] initWithSource:scriptSource];
        if (script)
        {
            eventDescriptor = [script executeAndReturnError:nil];
            if (eventDescriptor)
            {
                //                NSLog(@"%@", [eventDescriptor stringValue]);
            }
        }
    }
}


@end

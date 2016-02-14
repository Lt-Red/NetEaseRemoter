//
//  AppDelegate.h
//  NetEaseNextSong
//
//  Created by 罗小红 on 16/2/2.
//  Copyright © 2016年 LtRed. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Menulet.h"
#import "MenuletController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (assign, nonatomic) BOOL darkModeOn;

@property (strong, nonatomic) Menulet *menulet;
@property (strong, nonatomic) MenuletController *controller;

-(BOOL)connectToPort:(int)port;

@end


//
//  MenuletController.m
//  NetEaseNextSong
//
//  Created by 罗小红 on 16/2/13.
//  Copyright © 2016年 LtRed. All rights reserved.
//

#import "MenuletController.h"
#import "PopoverController.h"
#import "AppDelegate.h"

@interface MenuletController ()<MenuletDelegate>

@end

@implementation MenuletController

@synthesize active;
@synthesize popover;

- (void)clicked
{
    self.active = !active; //每次被单击时改变 active 的值
    if (active) { //显示 popover
        [self setupPopover];
        AppDelegate *appDelegate = [NSApp delegate];
        [popover showRelativeToRect:[appDelegate.menulet frame] ofView:appDelegate.menulet preferredEdge:CGRectMinYEdge];
        
        
    } else { //关闭 popover
        [popover performClose:self];
    }
}

- (void)setupPopover
{
    if (!popover) {
        popover = [[NSPopover alloc] init];
        popover.behavior = NSPopoverBehaviorTransient;
        popover.contentViewController = [[PopoverController alloc] init];
    }
}

@end

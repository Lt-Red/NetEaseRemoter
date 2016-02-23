//
//  MenuletController.h
//  NetEaseNextSong
//
//  Created by 罗小红 on 16/2/13.
//  Copyright © 2016年 LtRed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@protocol MenuletDelegate

- (BOOL)isActive; //是否已被单击
- (void)clicked; //被单击时调用的方法

@end


@interface MenuletController : NSObject

@property (assign, nonatomic, getter = isActive) BOOL active;
@property (strong, nonatomic) NSPopover *popover;

@end

//
//  Menulet.h
//  NetEaseNextSong
//
//  Created by 罗小红 on 16/2/13.
//  Copyright © 2016年 LtRed. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MenuletController.h"

@interface Menulet : NSView

@property (weak, nonatomic) id<MenuletDelegate> delegate;

@end

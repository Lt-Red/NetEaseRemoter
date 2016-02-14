//
//  Menulet.m
//  NetEaseNextSong
//
//  Created by 罗小红 on 16/2/13.
//  Copyright © 2016年 LtRed. All rights reserved.
//

#import "Menulet.h"

@implementation Menulet

@synthesize delegate;

- (void)setDelegate:(id)newDelegate
{
    [(NSObject *)newDelegate addObserver:self forKeyPath:@"active" options:NSKeyValueObservingOptionNew context:nil]; //观察 active 的值的改变
    delegate = newDelegate;

}

- (void)mouseDown:(NSEvent *)event
{
    [delegate clicked];
}

- (void)drawRect:(NSRect)rect //绘制图标的代码
{
    rect = CGRectInset(rect, 2, 2);
    if ([delegate isActive]) {
        [[NSColor textColor] set];
    } else {
        [[NSColor textColor] set];
    }
    NSRectFill(rect);
    [[NSImage imageNamed:@"Menulet"] drawInRect:rect fromRect:NSZeroRect operation:NSCompositeDestinationIn fraction:1.0];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setNeedsDisplay:YES]; //active 值改变时重新绘制图标
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent //避免焦点不在状态栏时需要单击两次才能点击到图标的问题
{
    return YES;
}


@end

//
//  BarView.m
//  ViewDemo
//
//  Created by Super User on 24.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import "BarView.h"

@implementation BarView

/* designated initializer */
- (id)initWithFrame:(NSRect)r
{
    self = [super initWithFrame:r];
    if (self) {
        [self setBoundsSize:NSMakeSize(100.0,1.0)];
    }
    return self;
}

- (BOOL)isOpaque
{
    return YES;
}

- (void)drawRect:(NSRect)aRect
{
    [[NSColor blackColor] set];
    NSRectFill(NSMakeRect(0, 0, _percentage ,1));
    
    NSDrawWindowBackground( NSMakeRect(_percentage, 0, 100 - _percentage, 1));
}

- (IBAction)takePercentage:(id)sender
{
    [self setPercentage:[sender floatValue] ];
}

- (void)setPercentage:(float)val
{
    _percentage = val;
    [self setNeedsDisplay:YES];
}

@end

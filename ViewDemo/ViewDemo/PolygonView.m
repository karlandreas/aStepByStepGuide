//
//  WhiteView.m
//  ViewDemo
//
//  Created by Super User on 22.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import "PolygonView.h"

@implementation PolygonView

- initWithFrame:(NSRect)rect
{
    self = [super initWithFrame:rect];
    if (self) {
        [self setBounds:NSMakeRect(-1,-1,2,2)];
        [self setNumSides:3];
    }
    return self;
}

-(void)drawRect:(NSRect)rect
{
    NSBezierPath *shape = [NSBezierPath bezierPath];
    float theta;
    
    [shape moveToPoint:NSMakePoint(sin(0.0),cos(0.0))];
    
    // M_PI is a predefined value of PI.
    // M_PI*2.0 is number of radians in a circle.
    // The for() statement below sweeps through each
    //    pie-section of the polygon for each side.
    
    for (theta = 0.0;
         theta <= 2 * M_PI;
         theta += (M_PI*2.0) / _sides) {
        
        [shape lineToPoint:NSMakePoint(sin(theta), cos(theta)) ];
    }
    
    [ [NSColor whiteColor] set];
    [shape fill];
}

- (IBAction)takeNumSidesFrom:sender
{
	[self setNumSides:[sender intValue] ];
}


- (BOOL)isOpaque
{
    return NO;
}


- (void)setNumSides:(int)val
{
    if (val > 0 && _sides != val) {
        _sides = val;
        [self setNeedsDisplay:YES];
    }
}


- (void)setSize:(float)size
{
    [self setFrameSize:NSMakeSize(size,size)];
    [self setBounds:NSMakeRect(-1,-1,2,2)];
    [self setNeedsDisplay:YES];
}


- (void)takeFloatSize:(id)sender
{
    [self setSize:[sender floatValue] ];
}


@end

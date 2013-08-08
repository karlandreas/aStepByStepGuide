//
//  Segment.m
//  GraphPaper
//
//  Created by Super User on 30.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import "Segment.h"

@implementation Segment

- initFrom:(NSPoint)theStart to:(NSPoint)theEnd
{
    self = [super init];
    if (self) {
        _start = theStart;
        _end   = theEnd;
        _color = [NSColor blackColor];
    }
    return self;
}

- (NSRect)bounds
{
    return NSMakeRect( MIN(_start.x, _end.x), MIN(_start.y, _end.y),
                      fabs(_start.x - _end.x) + FLT_MIN, fabs(_start.y - _end.y) + FLT_MIN);
}


- (NSPoint)segmentCenter
{
    return NSMakePoint((_start.x + _end.x) / 2.0, (_start.y + _end.y) / 2.0);
}


- (void)stroke
{
    [_color set];
    [NSBezierPath strokeLineFromPoint:_start toPoint:_end];
}

@end

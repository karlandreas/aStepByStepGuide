//
//  BlackView.m
//  ViewDemo
//
//  Created by Super User on 22.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import "BlackView.h"

@implementation BlackView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    [[NSColor blackColor] set];
    [NSBezierPath fillRect:dirtyRect];
}

@end

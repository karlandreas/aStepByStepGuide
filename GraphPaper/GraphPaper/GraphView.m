//
//  GraphView.m
//  GraphPaper
//
//  Created by Super User on 30.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        _annotations = [[NSMutableArray alloc] init];
        
        _trackingRect = [self addTrackingRect:[self visibleRect]
                                        owner:self
                                     userData:0
                                 assumeInside:NO];
    }    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    id obj = nil;
    
    [[NSColor whiteColor] set];
    NSRectFill(dirtyRect);
    
    NSSize sz = [self convertSize:NSMakeSize(1,1) fromView:nil];
    [NSBezierPath setDefaultLineWidth:MAX(sz.width,sz.height)];
    
    NSEnumerator *en = [_displayList objectEnumerator];
    
    while (obj = [en nextObject]) {
        if (NSIntersectsRect(dirtyRect,[obj bounds]) ) {
            [obj stroke];
        }
    }
    
}

@end

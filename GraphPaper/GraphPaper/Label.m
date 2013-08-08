//
//  Label.m
//  GraphPaper
//
//  Created by Super User on 30.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import "Label.h"

@implementation Label

- (id)initRect:(NSRect)aBounds text:(NSString *)aText size:(float)aSize
{
    self = [super init];
    if (self) {
        _bounds = aBounds;
        
        _font = [NSFont fontWithName:@"Times-Roman" size:aSize];
        _dict = [[NSMutableDictionary alloc] init];
        [_dict setObject:_font forKey:NSFontAttributeName];
        
        _text = [[NSMutableAttributedString alloc] initWithString:aText attributes:_dict];
        [self setColor:[NSColor blackColor]];
    }
    return self;
}

- (void)setColor:(NSColor *)aColor
{
    [_dict setObject:aColor forKey:NSForegroundColorAttributeName];
    [_text setAttributes:_dict range:NSMakeRange(0,[_text length])];
    
    // Now reapply the alignment because of a Cocoa bug
    [_text setAlignment:NSCenterTextAlignment range:NSMakeRange(0,[_text length])];
}

// This one works, but it requires a subview
// Note: Modified from G&M first edition so that subview isn't
// recreated each time the view is drawn
- (void)stroke
{
    NSView *fv = [NSView focusView];
    
    NSView *tempView = [ [NSView alloc] initWithFrame:_bounds];
    
    [fv addSubview:tempView];		// put the subview in
    
    // Scale the tempView to screen coordinates
    [tempView setBounds: [tempView convertRect:[self bounds] toView:nil] ];
    
    [tempView lockFocus];
    [_color set];
    [_text drawInRect:[tempView bounds] ];
    [tempView unlockFocus];
    [tempView removeFromSuperviewWithoutNeedingDisplay]; // remove the subview
}


@end

//
//  MathAnimation.m
//  MathPaper
//
//  Created by Super User on 22.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import "MathAnimation.h"
#import "MathApplication.h"


@implementation MathAnimation

#define FPS 30.0    // Frames Per Second
#define PI  3.14159

- (IBAction)tick:(id)sender
{
    
    if ([ ((MathApplication *)NSApp) doEasterEgg] ) {
        _theta -= (4.0 * PI / FPS) / 2.0; // spin reverse faster
    }
    else{
        _theta += (2.0 * PI / FPS) / 2.0;    // spin every 2 seconds
    }
    
    _fraction += _ddelta;                 // Pulse every 5 seconds
    
    if (fraction<0 || fraction>1) { // Do we need to reverse pulse?
        _ddelta   = -_ddelta;
        _fraction += _ddelta;
    }
    [self display];
}


- (void)awakeFromNib
{
    // Set up the attributed text
    NSFont *font = [NSFont fontWithName:@"Helvetica" size:36.0];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    
    [attrs setObject:font forKey:NSFontAttributeName];
    [attrs setObject:[NSColor greenColor]
              forKey:NSForegroundColorAttributeName];
    
    _str = [ [NSMutableAttributedString alloc] initWithString:@"MathPaper" attributes:attrs];
    
    _ddelta = (1.0 / FPS) / 5.0;
    _theta = 0.0;
    
    
    _image = [NSImage imageNamed:@"PaperIcon"];
    
    [ [NSNotificationCenter defaultCenter] addObserver:self selector:@selector(start:) name:NSWindowDidBecomeKeyNotification object:[self window]];
    
    [ [NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop:) name:NSWindowWillCloseNotification object:[self window] ];
}



- (void)start:(void *)userInfo
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/FPS
                                                  target:self
                                                selector:@selector(tick:)
                                                userInfo:0
                                                 repeats:YES];
    } 
}


- (void)stop:(void *)userInfo
{
    if (_timer) {
        [_timer invalidate];
        _timer = 0;  // No need to release because we did not retain
    }
}



- (void)drawRect:(NSRect)rect
{
    float x,y,t2;
    NSBezierPath *oval;
    
    // Paint the background white
    [ [NSColor whiteColor] set];
    NSRectFill([self bounds]);
    
    // Draw the name "MathPaper"
    [_str drawAtPoint:NSMakePoint(20,50)];
    
    // Draw those cool straight black lines
    [[NSColor blackColor] set];
    for (x=0; x<50; x+=10) {
        [NSBezierPath setDefaultLineWidth:(50-x)/10.0];
        [NSBezierPath strokeLineFromPoint:NSMakePoint(20+x,50-x)
                                  toPoint:NSMakePoint(300.0,50-x)];
    }
    
    // Put the PaperIcon in the upper-left hand corner of the panel
//    [_image compositeToPoint: NSMakePoint(10.0, [self frame].size.height-128.0) operation:NSCompositeSourceOver fraction:fraction];
    [_image drawAtPoint:NSMakePoint(10.0, [self frame].size.height-128.0) fromRect:[self frame] operation:NSCompositeSourceOver fraction:fraction];
    
    // Make a path for the star
    x = [self frame].size.width * .75;
    y = [self frame].size.height * .75;
    oval = [NSBezierPath bezierPath];
    
    [oval moveToPoint:
     NSMakePoint(x + cos(_theta)*50, y + sin(_theta) * 50)];
    for (t2 = 0; t2 <= 2*M_PI+.1; t2 += M_PI * .5) {
        [oval curveToPoint:NSMakePoint(x + cos(_theta+t2)*50,
                                       y + sin(_theta+t2)*50)
             controlPoint1:NSMakePoint(x,y)
             controlPoint2:NSMakePoint(x,y)];
    }
    [[NSColor blackColor] set];
    [oval stroke];
}


@end

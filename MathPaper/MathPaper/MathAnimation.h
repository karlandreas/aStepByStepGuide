//
//  MathAnimation.h
//  MathPaper
//
//  Created by Super User on 22.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MathAnimation : NSView

@property float theta;       // Current rotation for the star
@property float fraction;    // Current intensity for the pulsing icon
@property float ddelta;      // Density delta for icon

@property (nonatomic, strong)NSMutableAttributedString *str;   // "MathPaper" string
@property (nonatomic, strong)NSImage *image;
@property (nonatomic, strong)NSTimer *timer;                   // Our timer

- (IBAction)tick:(id)sender;


@end

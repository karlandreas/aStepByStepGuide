//
//  WhiteView.h
//  ViewDemo
//
//  Created by Super User on 22.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PolygonView : NSView

@property int sides;

- (IBAction)takeNumSidesFrom:(id)sender;
- (void)setNumSides:(int)val;

- (void)setSize:(float)size;
- (IBAction)takeFloatSize:(id)sender;

@end

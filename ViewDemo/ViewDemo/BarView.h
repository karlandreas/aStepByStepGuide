//
//  BarView.h
//  ViewDemo
//
//  Created by Super User on 24.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface BarView : NSView

@property (nonatomic) float percentage;

- (IBAction)takePercentage:(id)sender;
- (void)setPercentage:(float)newPercentage;

@end

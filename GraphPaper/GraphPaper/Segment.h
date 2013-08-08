//
//  Segment.h
//  GraphPaper
//
//  Created by Super User on 30.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Segment : NSObject

@property (nonatomic)NSPoint start;
@property (nonatomic)NSPoint end;
@property (nonatomic, strong)NSColor *color;
@property int myTag;

- initFrom:(NSPoint)start to:(NSPoint)end;
- (NSPoint) segmentCenter;

- (void)stroke;

@end

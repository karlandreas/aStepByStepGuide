//
//  GraphView.h
//  GraphPaper
//
//  Created by Super User on 30.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Segment.h"
#import "PaperController.h"

#define GRAPH_TAG 1
#define AXES_TAG  2
#define LABEL_TAG 3

@interface GraphView : NSView

@property (nonatomic) NSTrackingRectTag trackingRect;
@property (nonatomic, strong) NSMutableArray *annotations;

- (id)initWithFrame:(NSRect)frame;

@property (nonatomic, strong)NSMutableArray *displayList;

@end


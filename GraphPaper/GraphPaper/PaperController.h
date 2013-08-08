//
//  PaperController.h
//  GraphPaper
//
//  Created by Super User on 30.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GraphView.h"
#import "Label.h"
#import "Segment.h"
#import "GraphApplication.h"

#define STOP_SENDER 1
#define STOP_RECEIVER 2
#define GRAPH_TAG 1
#define AXES_TAG  2
#define LABEL_TAG 3

@class GraphView;
@interface PaperController : NSWindowController {

@public
    // For use by stuffer thread
    BOOL graphing;
    int toFd;
}

@property (weak) IBOutlet NSButton *graphButton;
@property (weak) IBOutlet NSFormCell *xMinCell;
@property (weak) IBOutlet NSFormCell *xMaxCell;
@property (weak) IBOutlet NSFormCell *xStepCell;
@property (weak) IBOutlet NSFormCell *yMinCell;
@property (weak) IBOutlet NSFormCell *yMaxCell;
@property (weak) IBOutlet NSTextField *formulaField;

@property (weak) IBOutlet NSTextField *xField;
@property (weak) IBOutlet NSTextField *yField;

@property (weak) IBOutlet GraphView *theView;
@property (nonatomic, strong)GraphApplication *delegate;

@property (nonatomic, strong)NSPipe *toPipe;
@property (nonatomic, strong)NSPipe *fromPipe;
@property (nonatomic, strong)NSFileHandle *toEvaluator;
@property (nonatomic, strong)NSFileHandle *fromEvaluator;
@property (nonatomic, strong)NSTask *evaluator;
@property (nonatomic, strong)NSMutableString *fromBuf;

// These hold the contents of the NSForm
@property double ymin;
@property double ymax;
@property double xstep;
@property double xmax;
@property double xmin;

// Communication with stuffer thread
@property BOOL stop_sending;
@property BOOL sending;
@property BOOL receiving;

// Display list
@property BOOL first;
@property (nonatomic)NSPoint lastPt;

- (IBAction)graph:(id)sender;
- (IBAction)stopGraph:(id)sender;

- (void)doStop:(int)which;
- (void)getFormAndScaleView;
- (void)addGraphElement:(id)element;
- (void)clear;
- (void)sendData;

- (void)mouseEntered:(NSEvent *)theEvent;
- (void)mouseExited:(NSEvent *)theEvent;
- (void)mouseMoved:(NSEvent *)theEvent;
- (void)removeAnnotations;

@end

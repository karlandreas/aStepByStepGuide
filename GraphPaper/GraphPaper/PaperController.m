//
//  PaperController.m
//  GraphPaper
//
//  Created by Super User on 30.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import "PaperController.h"

@implementation PaperController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        _delegate = (GraphApplication *)[NSApplication sharedApplication];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    [_xStepCell setPreferredTextFieldWidth:80.0f];
    _theView.displayList = [ [NSMutableArray alloc] init];
    _fromBuf = [ [NSMutableString alloc] init];
    
    // What follows is largely from MathPaper
    NSString *path  = [ [NSBundle mainBundle] pathForResource:@"Evaluator" ofType:@""];
    
    if (!path) {
        NSLog(@"%@: Cannot find Evaluator",[self description]);
    }
    else {
        _toPipe   = [NSPipe pipe];
        _fromPipe = [NSPipe pipe];
        
        _toEvaluator   = [_toPipe fileHandleForWriting];
        _fromEvaluator = [_fromPipe fileHandleForReading];
        
        _evaluator = [ [NSTask alloc] init];
        [_evaluator setLaunchPath:path];
        
        [_evaluator setStandardOutput:_fromPipe];
        [_evaluator setStandardInput:_toPipe];
        [_evaluator launch];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(gotData:)
                                                     name:NSFileHandleReadCompletionNotification
                                                   object:_fromEvaluator ];
        
        [_fromEvaluator readInBackgroundAndNotify];
    }
    
    // The notification below causes the getFormAndScaleView
    // method to be invoked whenever this view is resized.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getFormAndScaleView)
                                                 name:NSViewFrameDidChangeNotification
                                               object:self];
}

#pragma mark - my methods

- (void)clear
{
    [_theView.displayList removeAllObjects];
    [_theView setNeedsDisplay:YES];
}

- (IBAction)stopGraph:(id)sender
{
    _stop_sending = YES;
}

- (IBAction)graph:(id)sender
{
    // set instance variables from the form
    [self getFormAndScaleView];
    
    // Check the parameters of the graph
    if (_xmax < _xmin || _ymax < _ymin){
        NSRunAlertPanel( nil, @"Invalid min/max combination", @"OK", nil, nil);
        return;
    }
    
    if ( _xstep <= 0 ) {
        NSRunAlertPanel(0, @"The step size must be positive", @"OK", nil, nil);
        return;
    }
    
    [self clear];
    
    // Display the axes
    [self addAxesFrom:NSMakePoint(_xmin, 0.0) to:NSMakePoint(_xmax,0.0)];
    [self addAxesFrom:NSMakePoint(0.0, _ymin) to:NSMakePoint(0.0,_ymax)];
    
    // Add a label
    {
        Label *label = [[Label alloc] initRect: NSMakeRect(_xmin, _ymin, _xmax - _xmin, (_ymax - _ymin) * .2)
                                          text:[_formulaField stringValue]
                                          size:24.0];
        [label setMyTag:LABEL_TAG];
        [label setColor:[_delegate colorForTag:LABEL_TAG]];
        [self addGraphElement:label];
    }
    
    _first = YES;
    _stop_sending = NO;
    _sending = YES;
    _receiving = YES;
    
    [_graphButton setTitle:@"Stop"];
    [_graphButton setAction:@selector(stopGraph:)];
    
    [NSThread detachNewThreadSelector:@selector(sendData) toTarget:self withObject:nil];
    
}

- (void)addAxesFrom:(NSPoint)pt1 to:(NSPoint)pt2
{
    Segment *seg = [[Segment alloc] initFrom:pt1 to:pt2];
    [seg  setMyTag:AXES_TAG];
    [seg setColor:[_delegate colorForTag:AXES_TAG]];
    [self addGraphElement:seg];
}

- (void)doStop:(int)which
{
    switch (which) {
        case STOP_SENDER:
            _sending = NO;
            break;
        case STOP_RECEIVER:
            _receiving = NO;
            break;
    }
    
    if (_sending == NO && _receiving == NO) {  // Reinitialize
        [_graphButton setTitle:@"Graph"];
        [_graphButton setAction:@selector(graph:)];
        [_graphButton setEnabled:YES];
    }
    
    if (_sending == NO && _receiving == YES) { // Wait for results data
        [_graphButton setEnabled:FALSE];
        [_graphButton setTitle:@"Waiting..."];
    }
    
    if (_sending == YES && _receiving == NO) { // A problem
        NSLog(@"Synchronization error");
    }
}

- (void)getFormAndScaleView
{
    _xmin  = [_xMinCell.stringValue doubleValue];
    _xmax  = [_xMaxCell.stringValue doubleValue];
    _xstep = [_xStepCell.stringValue doubleValue];
    _ymin  = [_yMinCell.stringValue doubleValue];
    _ymax  = [_yMaxCell.stringValue doubleValue];
    
    [_theView setBounds:(NSMakeRect(_xmin, _ymin, _xmax - _xmin, _ymax - _ymin) )];
    [_theView setNeedsDisplay:YES];
}

- (void)addGraphElement:(id)element
{
    [_theView.displayList addObject:element];
    [_theView setNeedsDisplayInRect:[element bounds]];
}

- (void)sendData
{    
    NSString *formula = [_formulaField stringValue];
    
    for (double x = _xmin; _stop_sending == NO && x <= _xmax; x += _xstep) {
        
        NSMutableString *fsend = [NSMutableString stringWithString:@"x,"];
        NSString *xString = [NSString stringWithFormat:@"%g",x];
        
        [fsend appendString:formula];
        [fsend appendString:@"\n"];
        
        // Now go through the formula and change
        // every 'x' to a '%g'
        for (int i = (int)[fsend length] - 1; i >= 0; i--)
        {
            if ([fsend characterAtIndex:i] == 'x') {
                [fsend replaceCharactersInRange:NSMakeRange(i,1) withString:xString];
            }
        }
        
        // Send this to the other side
        [_toEvaluator writeData:
         [fsend dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] ];
    }
    // Now send through the termination code
    [_toEvaluator writeData:[@"999\n" dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
    
    [self doStop:STOP_SENDER];
}

- (void)gotData:(NSNotification *)not
{
    NSPoint pt;
    NSString *line = 0;
    
    NSData *data = [[not userInfo] objectForKey:NSFileHandleNotificationDataItem];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    // Add the data to the end of the text buffer
    [_fromBuf appendString:str];
    
    // Register to get the notification again
    [_fromEvaluator readInBackgroundAndNotify];
    
    // Now, process all complete lines we have
    do {
        
        NSRange r1 = [_fromBuf rangeOfString:@"\n"];
        
        if (r1.length < 1)
            break;
        
        line = [_fromBuf substringToIndex:r1.location];
        [_fromBuf replaceCharactersInRange:NSMakeRange(0, r1.location +1) withString:@""];
        
        int num = sscanf([line UTF8String], "%lf, %lf", &pt.x, &pt.y);
        if (num != 2) {
            [self doStop:STOP_RECEIVER];
            return;
        }
        if (!_first && !_stop_sending) {
            Segment *seg = [[Segment alloc] initFrom:_lastPt to:pt];
            [seg  setMyTag:GRAPH_TAG];
            [seg setColor:[_delegate colorForTag:GRAPH_TAG]];
            [self addGraphElement:seg];
        }
        _first = NO; // No longer first
        _lastPt = pt; // Remember this point
    } while (line);
    // end do
    
}

#pragma mark - mouse tracking

- (void)mouseEntered:(NSEvent *)theEvent
{
    [ [self window] setAcceptsMouseMovedEvents:YES];
    [ [self window] makeFirstResponder:self];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [self removeAnnotations];
    [ [self window] setAcceptsMouseMovedEvents:NO];
}



- (void)addAnnotation:(id)obj
{
    [_theView.annotations addObject:obj];
    [self addGraphElement:obj];
}

- (void)removeAnnotations
{
    NSEnumerator *en = [_theView.annotations objectEnumerator];
    id obj;
    
    while(obj = [en nextObject]) {
        [_theView setNeedsDisplayInRect:[obj bounds]];
    }
    
    [_theView.displayList removeObjectsInArray:_theView.annotations];
    [_theView.annotations removeAllObjects];
}

- (void)mouseMoved:(NSEvent *)theEvent
{
    id obj;
    
    NSPoint pt = [_theView convertPoint:[theEvent locationInWindow] fromView:nil];
    
    NSEnumerator *en = [_theView.displayList objectEnumerator];
    while (obj = [en nextObject]) {
        
        if ([obj myTag] == GRAPH_TAG &&
            pt.x >= [obj bounds].origin.x &&
            pt.x <= [obj bounds].origin.x +
            [obj bounds].size.width) {
            
            // Are we within 30 pixels of the line in screen coordinates?
            NSPoint ptMouse = [theEvent locationInWindow];
            NSPoint ptLine = [_theView convertPoint:[obj segmentCenter] toView: nil];
            
            double dist = sqrt(pow(ptMouse.x - ptLine.x,2) + pow(ptMouse.y - ptLine.y,2));
            
            if (dist < 30.0) {
                // Add two segments to annotations
                NSRect vb = [_theView bounds];
                NSRect ob = [obj bounds];
                id seg;
                
                [self removeAnnotations];  // Remove the old
                
                // Horizontal line intersecting cursor hot spot
                seg = [ [Segment alloc] initFrom:NSMakePoint(vb.origin.x, ob.origin.y)
                                              to:NSMakePoint(vb.origin.x+vb.size.width, ob.origin.y)];
                [self addAnnotation:seg];
                [seg setColor:[NSColor greenColor]];
                
                
                // Vertical line intersecting cursor hot spot
                seg = [ [Segment alloc] initFrom:NSMakePoint(ob.origin.x, vb.origin.y)
                                              to:NSMakePoint(ob.origin.x, vb.origin.y+vb.size.height)];
                [self addAnnotation:seg];
                [seg setColor:[NSColor greenColor]];
                
                // Update positions in the x and y text fields
                _xField.stringValue = [NSString stringWithFormat:@"X: %g", [obj segmentCenter].x];
                _yField.stringValue = [NSString stringWithFormat:@"Y: %g", [obj segmentCenter].y];
                
                [_theView display];    // Shouldn't be needed
                return;
            }
        }
    }
    
    // No segment should be highlighted
    [self removeAnnotations];
    [_theView display];
    _xField.stringValue = @"X:";
    _yField.stringValue = @"Y:";
}




@end

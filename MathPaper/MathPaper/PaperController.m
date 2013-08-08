//
//  PaperController.m
//  MathPaper
//
//  Created by Super User on 21.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import "PaperController.h"

@implementation PaperController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        _readFlag = YES;
        NSString *path = [NSBundle pathForResource:@"evaluator" ofType:@"" inDirectory:@"/usr/local/bin"];
        
        _toPipe   = [NSPipe pipe];
        _fromPipe = [NSPipe pipe];
        
        _toEvaluator   = [_toPipe fileHandleForWriting];
        _fromEvaluator = [_fromPipe fileHandleForReading];
        
        _evaluator = [ [NSTask alloc] init];
        [_evaluator setLaunchPath:path];
        
        [_evaluator setStandardOutput:_fromPipe];
        [_evaluator setStandardInput:_toPipe];
        [_evaluator launch];
        
        [ [NSNotificationCenter defaultCenter] addObserver:self
                                                  selector:@selector(gotData:)
                                                      name:NSFileHandleReadCompletionNotification
                                                    object:_fromEvaluator];
        
        [_fromEvaluator readInBackgroundAndNotify];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
        
    if ([self.document getHistory] != nil) {
        NSData *myHist = [self.document getHistory];
        NSAttributedString *stringData = [[NSAttributedString alloc] initWithRTF:myHist documentAttributes:NULL];
        _readFlag = NO;
        [_theText insertText:stringData];
        _readFlag = YES;
    }
}

- (void)gotData:(NSNotification *)notification
{
    NSData *data = [[notification userInfo] objectForKey:NSFileHandleNotificationDataItem];
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    RTF *rtf = [[RTF alloc] init];
    
    [rtf setBold:YES];
    [rtf setJustify:NSRightTextAlignment];
    [rtf setSize:20];
    [rtf appendString:str];
    [rtf setBold:NO];
    [rtf setJustify:NSLeftTextAlignment];
    [rtf setSize:12];
    [rtf appendString:@"--------------------\n"];
    NSAttributedString *stringData = [[NSAttributedString alloc] initWithRTF:[rtf data] documentAttributes:NULL];
    [_theText insertText:stringData];
    
    
    // Add the data to the end of theText object.
    //    [_theText insertText:str];
    //    [_theText insertText:@"--------------------\n"];
    
    // Scroll to the bottom.
    [_theText scrollRangeToVisible: NSMakeRange([ [_theText textStorage] length], 0)];
    
    // Register to get the notification again
    [_fromEvaluator readInBackgroundAndNotify];
    
    // Allow the user to type additional math expressions.
    _readFlag = YES;
}

- (void)textDidChange:(NSNotification *)notification
{
    NSString *str = @"";
    if (_readFlag) {
        str = [[self.window currentEvent] characters];
        [[self document] updateChangeCount:NSChangeDone];
    }
    
    if ([str isEqualToString:@"\r"] && [str isNotEqualTo:@"\n"]) {
        // Get the last line of text and send it to the Evaluator
        NSString *str = [_theText string];
        
        for (int i = (int)[str length] - 2; i >= 0; i--) {
            if ( i==0 || [str characterAtIndex:i-1] == '\n') {
                NSRange llRange = NSMakeRange(i,[str length]-i);
                NSString *lastLine =  [str substringWithRange:llRange];
                
                [_toEvaluator writeData: [lastLine dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] ];
                
                // Do not allow any more changes to the text
                _readFlag = NO;
                return;
            }
        }
    }
}

- (void)synchronizeData
{
    NSRange allRange = NSMakeRange(0, [[_theText textStorage] length]);
    
    MathDocument *doc = [self document];
    
    [doc setHistory:[NSMutableData dataWithData:[_theText RTFFromRange:allRange]]];
    [doc setFrame:[self.window frame]];
}


@end

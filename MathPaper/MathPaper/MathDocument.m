//
//  Document.m
//  MathPaper
//
//  Created by Super User on 21.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import "MathDocument.h"

@implementation MathDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        RTF *rtf = [[RTF alloc] init];
        
        [rtf setBold:TRUE];
        [rtf setSize:10.0];
        [rtf appendString:@"Enter a math expression and hit return:"];
        [rtf setBold:FALSE];
        [rtf setSize:12.0];
        [rtf appendString:@"\n"];
        _history = [[NSMutableData alloc] initWithData:[rtf data] ];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    _frame   = [coder decodeRect];
    _history = [coder decodeObject];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeRect:_frame];
    [coder encodeObject:_history];
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MathDocument";
}

- (void)makeWindowControllers
{
    id ctl = [[PaperController alloc] initWithWindowNibName:[self windowNibName] ];
    [self addWindowController:ctl];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace
{
    return NO;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    
    if([typeName isEqualToString:@"MathPaper"])
    {
        /* Ask our windows to synchronize their data */
        [[self windowControllers] makeObjectsPerformSelector:@selector(synchronizeData)];
        
        /* And encode the data */
        return [NSArchiver archivedDataWithRootObject:self];
    }
    
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    
    if([typeName isEqualToString:@"MathPaper"])
    {
        MathDocument *temp = [NSUnarchiver unarchiveObjectWithData:data];
        if(temp){
            [self setFrame:[temp getFrame]];
            [self setHistory:[NSData dataWithData:[temp getHistory]]];
            return YES;
        }
    }
    
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return NO;
}

#pragma mark - archiving methods

-(NSData *)getHistory
{
    return _history;
}

-(void)setHistory:(NSData *)theHistory
{
    [_history setData:theHistory];
}

-(NSRect)getFrame
{
    return _frame;
}

-(void)setFrame:(NSRect)aFrame
{
    _frame = aFrame;
}

-(BOOL)hasFrame
{
    return _frame.size.height != 0 && _frame.size.width != 0;
}

- (BOOL)isDocumentEdited
{
    PaperController *pctl = [[self windowControllers] objectAtIndex:0];
    return [[pctl window] isDocumentEdited];
}



@end

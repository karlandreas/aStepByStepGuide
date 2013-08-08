//
//  GraphApplication.m
//  GraphPaper
//
//  Created by Super User on 30.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import "GraphApplication.h"

@implementation GraphApplication

- (IBAction)showPrefs:(id)sender
{
    NSLog(@"Showing prefs");
    
    if (_preferencesPane == nil) {
        [NSBundle loadNibNamed:@"Preferences" owner:self];
    }
    
    [_preferencesPane makeKeyAndOrderFront:sender];
}

- (NSColor *)colorForTag:(int)aTag
{
    switch(aTag) {
        case AXES_TAG:
            if (_axesColor) {
                return _axesColor;
            } else {
                return [NSColor blackColor];
            }
        case GRAPH_TAG:
            if (_graphColor) {
                return _graphColor;
            } else {
                return [NSColor blackColor];
            }
        case LABEL_TAG:
            if (_labelColor) {
                return _labelColor;
            } else {
                return [NSColor blackColor];
            }
    }
    return nil;                         // no color?
}

- (void)setObjectsToColor:(NSColor *)theColor forTag:(int)aTag
{
    /* First set the correct instance variable */
    switch(aTag){
        case AXES_TAG:
            _axesColor = theColor;
            break;
        case GRAPH_TAG:
            _graphColor = theColor;
            break;
        case LABEL_TAG:
            _labelColor = theColor;
            break;
    }
}

- (IBAction)setObjectsToColor:(NSColorWell *)sender
{
    [self setObjectsToColor:[sender color] forTag:(int)[sender tag]];
}

#pragma mark - Window delegate methods

- (void)windowWillClose:(NSNotification *)notification
{
    NSLog(@"Closing window");
    _preferencesPane = nil;
}

#pragma mark - AppDelegate methods

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"Application did finish launching");
}

@end

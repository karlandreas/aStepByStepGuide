//
//  GraphApplication.h
//  GraphPaper
//
//  Created by Super User on 30.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define GRAPH_TAG 1
#define AXES_TAG  2
#define LABEL_TAG 3

@interface GraphApplication : NSApplication <NSApplicationDelegate, NSWindowDelegate>

- (IBAction)showPrefs:(id)sender;

@property (unsafe_unretained) IBOutlet NSPanel *preferencesPane;

- (IBAction)setObjectsToColor:(id)sender;
- (NSColor *)colorForTag:(int)aTag;

@property (nonatomic, strong)NSColor *graphColor;
@property (nonatomic, strong)NSColor *axesColor;
@property (nonatomic, strong)NSColor *labelColor;



@end

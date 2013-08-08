//
//  AboutApplication.h
//  MathPaper
//
//  Created by Super User on 22.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MathApplication : NSApplication 

@property BOOL easterEgg;

@property (strong) IBOutlet NSPanel *aboutPanel;

-(BOOL)doEasterEgg;

@end

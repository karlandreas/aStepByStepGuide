//
//  AboutApplication.m
//  MathPaper
//
//  Created by Super User on 22.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import "MathApplication.h"

@implementation MathApplication

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"application will finish launching");
}

- (void)orderFrontStandardAboutPanel:(id)sender
{
    if (_aboutPanel == nil) {
        [NSBundle loadNibNamed:@"AboutPanel" owner:self];
    }
    
    _easterEgg = [[self currentEvent] modifierFlags] & (NSShiftKeyMask | NSAlternateKeyMask);
    
    [_aboutPanel makeKeyAndOrderFront:self];
}

-(BOOL)doEasterEgg
{
    return _easterEgg;
}

@end

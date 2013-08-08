//
//  AppDelegate.h
//  Calculator
//
//  Created by Super User on 18.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property double X;
@property double Y;
@property double operationMemory;
@property double operationResult;
@property BOOL	operationFlag;
@property BOOL yFlag;
@property BOOL equalsFlag;
@property int base;
@property NSInteger operation;
@property (nonatomic, strong)NSMutableArray *operationHistory;

@property (weak) IBOutlet NSTextField *readoutTextField;
@property (weak) IBOutlet NSMatrix *keypadMatrix;
@property (weak) IBOutlet NSPopUpButton *radixPopUp;

@property (weak) IBOutlet id aboutPanel;

- (IBAction)clearAll:(id)sender;
- (IBAction)clear:(id)sender;
- (IBAction)enterDigit:(id)sender;
- (IBAction)enterOption:(id)sender;
- (IBAction)doUnaryMinus:(id)sender;
- (IBAction)setRadix:(id)sender;

- (IBAction)showPreferences:(id)sender;
- (IBAction)showAboutPanel:(id)sender;

@end

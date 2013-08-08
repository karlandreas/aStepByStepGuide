//
//  AppDelegate.m
//  Calculator
//
//  Created by Super User on 18.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import "AppDelegate.h"

enum {
	PLUS	 = 1001,
	SUBTRACT = 1002,
	MULTIPLY = 1003,
	DIVIDE	 = 1004,
	EQUALS	 = 1005
};

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _X = 0.0;
    _Y = 0.0;
    _base = 10;
    _operationMemory = 0.0;
    _operationFlag = YES;
    _operationHistory = [[NSMutableArray alloc] initWithObjects:@"zero", nil];
    [_readoutTextField resignFirstResponder];
    [_radixPopUp selectItemAtIndex:[@1 integerValue]];
}

#pragma mark - recieved actions

- (IBAction)enterDigit:(id)sender {
    
    _X = [[sender selectedCell] tag];
    
    if (!_operationFlag) {
        _operationMemory = 0.0;
    }
    if (_Y != 0.0) {
        NSString *stringValue = _readoutTextField.stringValue;
        NSString *newValue = [NSString stringWithFormat:@"%@%f", stringValue, _X];
         _X = [newValue doubleValue];
    }
    
    _Y = _X;
    
    [self displayX];
}

- (IBAction)enterOption:(id)sender
{
    _operationFlag = YES;
    
    if ([[sender selectedCell] tag] != 0) {
        _operation = [[sender selectedCell] tag];
    } else {
        _equalsFlag = YES;
    }
    
    switch (_operation) {
        case PLUS:
            if ([[_operationHistory lastObject] isEqualToString:@"SUBTRACT"]) {
                [self doSubtract];
            } else if ([[_operationHistory lastObject] isEqualToString:@"MULTIPLY"]) {
                [self doMultiply];
            } else if ([[_operationHistory lastObject] isEqualToString:@"DIVIDE"]) {
                [self doDivide];
            }
            [self doPlus];
            break;
        case SUBTRACT:
            if ([[_operationHistory lastObject] isEqualToString:@"PLUS"]) {
                [self doPlus];
            } else if ([[_operationHistory lastObject] isEqualToString:@"MULTIPLY"]) {
                [self doMultiply];
            } else if ([[_operationHistory lastObject] isEqualToString:@"DIVIDE"]) {
                [self doDivide];
            }
            [self doSubtract];
            break;
        case MULTIPLY:
            if ([[_operationHistory lastObject] isEqualToString:@"PLUS"]) {
                [self doPlus];
            } else if ([[_operationHistory lastObject] isEqualToString:@"SUBTRACT"]) {
                [self doSubtract];
            } else if ([[_operationHistory lastObject] isEqualToString:@"DIVIDE"]) {
                [self doDivide];
            }
            [self doMultiply];
            break;
        case DIVIDE:
            if ([[_operationHistory lastObject] isEqualToString:@"PLUS"]) {
                [self doPlus];
            } else if ([[_operationHistory lastObject] isEqualToString:@"SUBTRACT"]) {
                [self doSubtract];
            } else if ([[_operationHistory lastObject] isEqualToString:@"MULTIPLY"]) {
                [self doMultiply];
            }
            [self doDivide];
            break;
        default:
            break;
    }
}

- (IBAction)doUnaryMinus:(id)sender {
    _operationMemory = -_operationMemory;
    [self displayOperationResult];
}

- (IBAction)setRadix:(id)sender
{
    NSCell *cell;
    int oldRadix = _base;
    
    _base = (int)[[sender selectedCell] tag];
    
    if (_base != oldRadix && (_base == 16 || oldRadix == 16) ) {
        // get the full size of 2 rows (cell height + intercellSpacing *2)
        double ysize = [_keypadMatrix cellSize].height * 2 + [_keypadMatrix intercellSpacing].height * 2;
        
        int row,col;
        // NSWindow *win = [_keypadMatrix window];
        NSRect frame = [_window frame];
        
        // If switching to radix 16, grow the window, and keep the title bar in the same place.
        if (_base == 16){
            frame.size.height += ysize;
            frame.origin.y    -= ysize;
            [_window setFrame:frame display:YES animate:YES];
            
            for (row = 0; row < 2; row++) {
                [_keypadMatrix insertRow:0];
                
                for(col = 0; col < 3; col++)
                {
                    int val = 10 + row * 3 + col; // get base 16 value of A, B, C, D, E, F
                    cell = [_keypadMatrix cellAtRow:0 column:col];
                    [cell setTag:val];
                    [cell setTitle:[NSString stringWithFormat:@"%X",val]]; // Set title to hex value
                }
            }
            [_keypadMatrix sizeToCells];
            [_keypadMatrix setNeedsDisplay];
        }
        // If switching away from base 16, shrink the window (keeping the title bar in the same place)
        else {
            frame.size.height -= ysize;
            frame.origin.y    += ysize;
            [_keypadMatrix removeRow:0];
            [_keypadMatrix removeRow:0];
            [_keypadMatrix sizeToCells];
            [_keypadMatrix setNeedsDisplay];
            
            [_window setFrame:frame display:YES animate:YES];
        }
    }
    
    // Disable the buttons that are higher than selected radix
    NSEnumerator *enumerator = [[_keypadMatrix cells] objectEnumerator];
    while (cell = [enumerator nextObject]) {
        [cell setEnabled: ([cell tag] < _base) ];
    }
    [self displayX];
}

- (IBAction)clearAll:(id)sender {
    _X = 0.0;
	_Y = 0.0;
    _operationMemory = 0.0;
    [_operationHistory removeAllObjects];
	_operationFlag = YES;
    _equalsFlag = NO;
	[self displayX];
}

- (IBAction)clear:(id)sender {
    _X = 0.0;
	_Y = 0.0;
    _operationMemory = 0.0;
    [_operationHistory removeAllObjects];
	_operationFlag = YES;
    _equalsFlag = NO;
	[self displayX];
}

- (IBAction)showPreferences:(id)sender
{
    
}

- (IBAction)showAboutPanel:(id)sender {
    if (_aboutPanel == nil) {
        if (![NSBundle loadNibNamed:@"AboutPanel" owner:self]) {
            NSLog(@"Load of AboutPanel.nib failed");
            return;
        }
    }
    [_aboutPanel makeKeyAndOrderFront: nil];
}

#pragma mark - display results

- (void)displayX
{
//	NSLog(@"Displaying ... _X is %f, _Y is %f, operationMemory is %F", _X, _Y, _operationMemory);
    NSString *s = nil;
    
    switch (_base) {
        case 16:
            s = [NSString stringWithFormat:@"%x", (int)_X];
            break;
        case 10:
            s = [NSString stringWithFormat:@"%15.10g", _X];
            break;
        case 8:
            s = [NSString stringWithFormat:@"%o",(int)_X];
            break;
        case 2:
            s = [self toBinary:(int)_X];
            break;
        default:
            break;
    }
	[_readoutTextField setStringValue: s];
}

- (void)displayOperationResult
{
//    NSLog(@"Displaying ... _X is %f, _Y is %f, operationMemory is %F", _X, _Y, _operationMemory);
	NSString *s = [NSString stringWithFormat:@"%15.10g", _operationMemory ];
	[_readoutTextField setStringValue: s];
    
//    NSLog(@"Last Operation: %@\n\n\n", [_operationHistory lastObject]);
    if (_equalsFlag) {
        _operationFlag = NO;
        _equalsFlag = NO;
    }
}

#pragma mark - Calculation operations

- (void)doPlus {
//    NSLog(@"Doing plus operation");
    _operationMemory = _operationMemory + _Y;
//    NSLog(@"operationMemory set to %f", _operationMemory);
    [_operationHistory addObject:@"PLUS"];
    _X = 0.0;
    _Y = 0.0;
    [self displayOperationResult];
}

- (void)doSubtract {
//    NSLog(@"Doing subtraction operation");
    [_operationHistory addObject:@"SUBTRACT"];
    if (_operationMemory == 0.0) {
        _operationMemory = _Y;
    } else {
        _operationMemory = _operationMemory - _Y;
    }
//    NSLog(@"operationMemory set to %f", _operationMemory);
    _X = 0.0;
    _Y = 0.0;
    [self displayOperationResult];
}

- (void)doMultiply {
//    NSLog(@"Doing multiplication operation");
    if (_operationMemory == 0.0) {
        _operationMemory = _Y;
    } else if (_Y != 0.0) {
        _operationMemory = _operationMemory * _Y;
    }
//    NSLog(@"operationMemory set to %f", _operationMemory);
    [_operationHistory addObject:@"MULTIPLY"];
    _X = 0.0;
    _Y = 0.0;
    [self displayOperationResult];
}

- (void)doDivide {
//    NSLog(@"Doing division operation");
    if (_operationMemory == 0.0) {
        _operationMemory = _Y;
    } else if (_Y != 0.0) {
        _operationMemory = _operationMemory / _Y;
    }
//    NSLog(@"operationMemory set to %f", _operationMemory);
    [_operationHistory addObject:@"DIVIDE"];
    _X = 0.0;
    _Y = 0.0;
    [self displayOperationResult];
}

- (NSString *)toBinary: (unsigned long)val {
    int i;
    char buf[33];
    
    for (i = 0; i < 32; i++) {
        buf[i] = (val & ( 1 << (31-i) ) ? '1' : '0');
    }
    buf[32] = '\0';
    
    for (i = 0; i < 32; i++) {
        if (buf[i] != '0') {
            return [NSString stringWithCString:buf+i encoding:NSASCIIStringEncoding];
        }
    }
    return [NSString stringWithCString:buf+31 encoding:NSASCIIStringEncoding];
}


@end

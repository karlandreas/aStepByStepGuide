//
//  RTF.m
//  MathPaper
//
//  Created by Super User on 21.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import "RTF.h"

@implementation RTF

- (id)init
{
    self = [super init];
    if (self) {
        NSString *header = @"{\\rtf1\\mac{\\fonttbl\\f0\\fswiss Helvetica;}\\f0\\fs24 ";
        
        _data = [NSMutableData dataWithData:[header dataUsingEncoding: NSASCIIStringEncoding] ];
    }
    
    return self;
}


// Create a new NSData object that has a termination brace.
// Cocoa's NSText won't display without the brace.
- (NSData *)data
{
    NSMutableData *data2 = [[NSMutableData alloc] initWithData:_data];
    [data2 appendBytes:"}" length:1];
    return data2;
}


// appendChar: appends an arbitrary character to the data
- (void)appendChar:(unsigned char)ch
{
    [_data appendBytes:&ch length:1];
}


// appendRTF: appends an arbitrary RTF string to the RTF object
- (void)appendRTF:(NSString *)string
{
    [_data appendData: [string dataUsingEncoding:NSASCIIStringEncoding] ];
}


// appendString: appends an ASCII text string,
// all of the special characters in the text.
- (void)appendString:(NSString *)string
{
    int i;
    
    for(i=0;i<[string length];i++){
        unichar c = [string characterAtIndex:i];
        
        switch(c){
            case '\n':   // escape special characters
            case '{':
            case '}':
            case '\\':
                [self appendChar:'\\'];
                break;
            default:
                break;
        }
        [self appendChar:c];
    }
}


- (void)setBold:(BOOL)flag
{
    [self appendRTF: flag ? @"\\b " : @"\\b0 "];
}

- (void)setSize:(float)aSize
{
    [self appendRTF:
     [NSString stringWithFormat:@"\\fs%d",(int)aSize*2]];
}

- (void)setJustify:(NSTextAlignment)mode
{
    switch(mode){
        case NSNaturalTextAlignment:
        case NSLeftTextAlignment:
        case NSJustifiedTextAlignment:
            [self appendRTF:@"\\ql\n"];
            break;
        case NSCenterTextAlignment:
            [self appendRTF:@"\\qc\n"];
            break;
        case NSRightTextAlignment:
            [self appendRTF:@"\\qr\n"];
            break;
    }
}



@end

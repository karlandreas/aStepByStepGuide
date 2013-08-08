//
//  RTF.h
//  MathPaper
//
//  Created by Super User on 21.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTF : NSObject

@property (nonatomic, strong) NSMutableData *data;

- (NSData *)data;

- (void)appendRTF:(NSString *)string;
- (void)setBold:(BOOL)flag;
- (void)setJustify:(NSTextAlignment)mode;
- (void)setSize:(float)aSize;
- (void)appendString:(NSString *)string;

@end

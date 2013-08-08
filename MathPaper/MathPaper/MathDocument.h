//
//  Document.h
//  MathPaper
//
//  Created by Super User on 21.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PaperController.h"

@interface MathDocument : NSDocument 

@property (nonatomic)NSRect frame;
@property (nonatomic, strong)NSMutableData *history;

-(NSData *)getHistory;
-(void)setHistory:(NSMutableData *)theHistory;
-(NSRect)getFrame;
-(void)setFrame:(NSRect)aFrame;
-(BOOL)hasFrame;

@end

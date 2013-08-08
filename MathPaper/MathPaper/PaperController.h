//
//  PaperController.h
//  MathPaper
//
//  Created by Super User on 21.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MathDocument.h"
#import "RTF.h"

@interface PaperController : NSWindowController <NSTextViewDelegate>

@property (nonatomic, strong)NSTask         *evaluator;
@property (nonatomic, strong)NSPipe         *toPipe;
@property (nonatomic, strong)NSPipe         *fromPipe;
@property (nonatomic, strong)NSFileHandle   *toEvaluator;
@property (nonatomic, strong)NSFileHandle   *fromEvaluator;
@property BOOL readFlag;

@property (unsafe_unretained) IBOutlet NSTextView *theText;

- (void)synchronizeData;

@end

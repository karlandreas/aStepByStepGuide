//
//  Label.h
//  GraphPaper
//
//  Created by Super User on 30.05.13.
//  Copyright (c) 2013 KAjohansen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Label : NSObject

@property (nonatomic) NSRect bounds;
@property (nonatomic,strong) NSMutableAttributedString *text;
@property (nonatomic,strong) NSColor             *color;
@property (nonatomic,strong) NSFont              *font;
@property (nonatomic,strong) NSMutableDictionary *dict;
@property int myTag;


- (id)initRect:(NSRect)bounds text:(NSString *)aText size:(float)aSize;

@end

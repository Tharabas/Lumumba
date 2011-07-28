//
//  THSize.h
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class THPoint, THRect, THGrid;

@interface THSize : NSObject {
  CGFloat width;
  CGFloat height;
}

+(THSize *)size;
+(THSize *)sizeOf:(id)object;
+(THSize *)sizeWithSize:(NSSize)size;
+(THSize *)sizeWithWidth:(CGFloat)width height:(CGFloat)height;

+(BOOL)maybeSize:(id)object;

-(id)initWithWidth:(CGFloat)width height:(CGFloat)height;
-(id)initWithSize:(NSSize)size;

@property (assign) NSSize size;
@property (assign) CGFloat width;
@property (assign) CGFloat height;

@property (readonly) CGFloat min;
@property (readonly) CGFloat max;
@property (readonly) CGFloat wthRatio;

-(id)growBy:(id)object;
-(id)growByWidth:(CGFloat)width height:(CGFloat)height;

-(id)multipyBy:(id)object;
-(id)multipyByWidth:(CGFloat)width height:(CGFloat)height;
-(id)multipyByPoint:(NSPoint)point;
-(id)multipyBySize:(NSSize)size;

-(id)divideBy:(id)object;
-(id)divideByWidth:(CGFloat)width height:(CGFloat)height;
-(id)divideByPoint:(NSPoint)point;
-(id)divideBySize:(NSSize)size;

-(id)swap;
-(id)negate;
-(id)invert;

@end

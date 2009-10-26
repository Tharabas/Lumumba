//
//  THRect.h
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class THPoint;

@interface THRect : THPoint {
  CGFloat width;
  CGFloat height;
}

+(THRect *)rect;
+(THRect *)rectOf:(id)object;
+(THRect *)rectWithRect:(NSRect)rect;
+(THRect *)rectWithOrigin:(NSPoint)origin 
                  andSize:(NSSize)size;
+(THRect *)rectWithX:(CGFloat)x 
                andY:(CGFloat)y 
               width:(CGFloat)width 
              height:(CGFloat)height;

+(BOOL)maybeRect:(id)object;

-(id)initWithRect:(NSRect)rect;
-(id)initWithSize:(NSSize)size;
-(id)initFromPoint:(NSPoint)ptOne 
           toPoint:(NSPoint)ptTwo;

@property (assign) CGFloat width;
@property (assign) CGFloat height;
@property (readonly) CGFloat area;

@property (assign) NSPoint origin;
@property (assign) NSPoint center;
@property (assign) NSSize size;
@property (assign) NSRect rect;

-(id)shrinkBy:(id)object;
-(id)shrinkByPadding:(NSInteger)padding;
-(id)shrinkBySizePadding:(NSSize)padding;

-(id)growBy:(id)object;
-(id)growByPadding:(NSInteger)padding;
-(id)growBySizePadding:(NSSize)padding;

-(BOOL)contains:(id)object;
-(BOOL)containsPoint:(NSPoint)pt;
-(BOOL)containsRect:(NSRect)rect;

-(id)centerOn:(id)bounds;
-(id)moveTo:(id)relationPoint ofRect:(id)bounds;
-(id)sizeTo:(id)relationPoint ofRect:(id)bounds;

// graphing
-(void)drawFrame;
-(void)fill;

@end

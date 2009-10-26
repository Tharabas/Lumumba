//
//  NSBezierPath+TH.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 03.02.10.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum _THTriangleStyle {
  THTriangleDefault   = 0,
  THTriangleStopLine  = 1L << 2,
  THTrianglePitched   = 1L << 3,
  THTriangleDouble    = 1L << 4,
  THTriangleTriple    = 1L << 5
} THTriangleStyle;

@interface NSBezierPath (TH)

-(void)appendBezierPathWithTriangleInRect:(NSRect)rect 
                     pointingAngleFromTop:(CGFloat)angle;
-(void)appendBezierPathWithTriangleInRect:(NSRect)rect 
                     pointingAngleFromTop:(CGFloat)angle
                                withStyle:(THTriangleStyle)style;

-(void)lineFromPoint:(NSPoint)from toPoint:(NSPoint)to;
-(void)lineFromPoint:(NSPoint)from 
         alongPoints:(NSPoint *)way 
           waypoints:(NSUInteger)waypoints;

-(void)rotateByDegrees:(CGFloat)angle;

//-(CGFloat)lineBy; // alibi method
//-(void)setLineBy:(CGFloat)x, ...;
//
//-(CGFloat)moveBy; // alibi method
//-(void)setMoveBy:(CGFloat)x, ...;

@end

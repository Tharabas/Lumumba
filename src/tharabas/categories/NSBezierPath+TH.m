//
//  NSBezierPath+TH.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 03.02.10.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "NSBezierPath+TH.h"
#import "THGeometricFunctions.h"
#import "NSAffineTransform+TH.h"

@implementation NSBezierPath (TH)

-(void)appendBezierPathWithTriangleInRect:(NSRect)rect 
                     pointingAngleFromTop:(CGFloat)angle
{
  [self appendBezierPathWithTriangleInRect:rect
                      pointingAngleFromTop:angle
                                 withStyle:THTriangleDefault];
}

-(void)appendBezierPathWithTriangleInRect:(NSRect)rect 
                     pointingAngleFromTop:(CGFloat)angle
                                withStyle:(THTriangleStyle)style
{
  NSBezierPath *p = NSBezierPath.new;
  
  // create a path for a new triangle
  // drawin the triangle will occur around the origin
  // afterwards the triangle will be rotated, resized and moved

  [p moveToPoint:NSMakePoint(-.5, -.5)];
  if (style & THTrianglePitched) {
    NSPoint pitchPoint = NSMakePoint(0, -.25);
    [p curveToPoint:NSMakePoint(.5, -.5)
      controlPoint1:pitchPoint
      controlPoint2:pitchPoint
     ];
  } else {
    [p lineToPoint:NSMakePoint(.5, -.5)];
  }

  [p lineToPoint:NSMakePoint(0, .5)];
  [p lineToPoint:NSMakePoint(-.5, -.5)];
  
  if (style & THTriangleStopLine) {
    // append a line atop
    [p moveToPoint:NSMakePoint(-.5, .5)];
    [p lineToPoint:NSMakePoint(.5, .5)];
  }

  NSAffineTransform *at = NSAffineTransform.new;
  // affine actions in reversed order!
  [at translateBy:THCenterOfRect(rect)];
  [at scaleXBy:rect.size.width yBy:rect.size.height];
  [at rotateByDegrees:angle];
  [p transformUsingAffineTransform:at];
  
  [at release];
  
  [self appendBezierPath:p];
  
  [p release];
}

-(void)lineFromPoint:(NSPoint)from toPoint:(NSPoint)to {
  [self moveToPoint:from];
  [self lineToPoint:to];
}

-(void)lineFromPoint:(NSPoint)from 
         alongPoints:(NSPoint *)way 
           waypoints:(NSUInteger)waypoints 
{
  [self moveToPoint:from];
  for (int i = 0; i < waypoints; i++) {
    [self lineToPoint:way[i]];
  }
}

-(void)rotateByDegrees:(CGFloat)angle {
  NSRect bounds = self.bounds;
  NSAffineTransform *at = [[NSAffineTransform alloc] init];
  NSPoint center = THCenterOfRect(bounds);
  
  // affine transformation in reversed order
  [at translateBy:center];
  [at rotateByDegrees:angle];
  [at translateBy:THNegatePoint(center)];
  
  [self transformUsingAffineTransform:at];
  
  [at release];
}

//-(CGFloat)moveBy {
//  return 1.0;
//}
//
//-(void)setMoveBy:(CGFloat)x, ... {
//  if (self.isEmpty) {
//    return;
//  }
//  va_list args;
//  va_start(args, x);
//  NSPoint pt = NSMakePoint(va_arg(args, double), va_arg(args, double));
//  va_end(args);
//  
//  [self moveToPoint:THAddPoints(self.currentPoint, pt)];
//}
//
//-(CGFloat)lineBy {
//  return 1.0;
//}
//
//-(void)setLineBy:(CGFloat)x, ... {
//  if (self.isEmpty) {
//    return;
//  }
//  
//  va_list args;
//  va_start(args, x);
//  NSPoint pt = NSMakePoint(va_arg(args, double), va_arg(args, double));
//  va_end(args);
//  
//  [self lineToPoint:THAddPoints(self.currentPoint, pt)];
//}

@end

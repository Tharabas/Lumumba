//
//  THSegmentedRect.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 26.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "THSegmentedRect.h"
#import "NSString+TH.h"

@implementation THSegmentedRect

+(THSegmentedRect *)rectWithRect:(NSRect)rect {
  return [[[THSegmentedRect alloc] initWithRect:rect] autorelease];
}

+(THSegmentedRect *)rectWithRect:(NSRect)rect cubicSize:(NSUInteger)size {
  THSegmentedRect *re = [[THSegmentedRect alloc] initWithRect:rect];
  re.horizontalSegments = size;
  re.verticalSegments = size;
  return [re autorelease];
}

+(THSegmentedRect *)rectWithRect:(NSRect)rect
                           width:(NSUInteger)wv
                          height:(NSUInteger)hv
{
  THSegmentedRect *re = [[THSegmentedRect alloc] initWithRect:rect];
  re.horizontalSegments = wv;
  re.verticalSegments = hv;
  return [re autorelease];
}

-(id)init {
  if ((self = [super init])) {
    segments = NSMakePoint(2, 2);
    emptyBorder = YES;
    minimumSegmentSize = NSMakeSize(0, 0);
    maximumSegmentSize = NSMakeSize(INT_MAX, INT_MAX);
  }
  
  return self;
}

@synthesize emptyBorder;

-(void)setHorizontalSegments:(NSUInteger)hseg {
  segments.x = MAX(1, hseg) - (emptyBorder ? 1 : 0);
}

-(NSUInteger)horizontalSegments {
  return segments.x + (emptyBorder ? 1 : 0);
}

-(void)setVerticalSegments:(NSUInteger)vseg {
  segments.y = MAX(1, vseg) - (emptyBorder ? 1 : 0);
}

-(NSUInteger)verticalSegments {
  return segments.y + (emptyBorder ? 1 : 0);
}

-(id)setCubicSize:(NSUInteger)size {
  self.horizontalSegments = size;
  self.verticalSegments = size;
  
  return self;
}

-(id)setDimensionWidth:(NSUInteger)wv height:(NSUInteger)hv {
  self.horizontalSegments = wv;
  self.verticalSegments = hv;
  
  return self;
}

-(NSUInteger)segmentCount {
  return self.horizontalSegments * self.verticalSegments;
}

-(NSSize)segmentSize {
  CGFloat w = MIN(MAX(width / segments.x, 
                      minimumSegmentSize.width), 
                  maximumSegmentSize.width);
  CGFloat h = MIN(MAX(height / segments.y,
                      minimumSegmentSize.height),
                  maximumSegmentSize.height);
  
  return NSMakeSize(w, h);
}

@synthesize minimumSegmentSize, maximumSegmentSize;

-(NSPoint)indicesOfSegmentAtIndex:(NSUInteger)index {
  NSUInteger i = index % self.segmentCount;
  NSUInteger px = i % self.horizontalSegments;
  NSUInteger py = (i - px) / self.horizontalSegments;

  return NSMakePoint(px, py);
}
-(NSUInteger)indexAtPoint:(NSPoint)pt {
  THPoint *ppt = [THPoint pointWithPoint:pt];
  [ppt divideBy:[THSize sizeWithSize:self.segmentSize]];
  [ppt floor];
  
  return ppt.x + ppt.y * height;
}

-(NSPoint)pointOfSegmentAtIndex:(NSUInteger)index {
  NSPoint pt = [self indicesOfSegmentAtIndex:index];
  return [self pointOfSegmentAtX:pt.x y:pt.y];
}
-(NSPoint)pointOfSegmentAtX:(NSUInteger)vx 
                          y:(NSUInteger)vy 
{
  NSSize size = self.segmentSize;
  return NSMakePoint(x + ((CGFloat)vx) * size.width, 
                     y + ((CGFloat)vy) * size.height);
}

-(NSRect)rectOfSegmentAtIndex:(NSUInteger)index {
  NSPoint pt = [self indicesOfSegmentAtIndex:index];
  return [self rectOfSegmentAtX:pt.x y:pt.y];
}
-(NSRect)rectOfSegmentAtX:(NSUInteger)vx 
                        y:(NSUInteger)vy
{
  NSSize size = self.segmentSize;
  return NSMakeRect(x + ((CGFloat)vx) * size.width, 
                    y + ((CGFloat)vy) * size.height,
                    size.width,
                    size.height);
}

-(THRect *)segmentAtIndex:(NSUInteger)index {
  NSPoint pt = [self indicesOfSegmentAtIndex:index];
  return [self segmentAtX:pt.x y:pt.y];
}
-(THRect *)segmentAtX:(NSUInteger)vx 
                    y:(NSUInteger)vy 
{
  return [THRect rectWithRect:[self rectOfSegmentAtX:vx y:vy]];
}

-(NSPoint)pointWithString:(NSString *)string {
  NSPoint re = NSMakePoint(0.0, 0.0);
  NSPoint m  = NSMakePoint(1.0, 1.0);
  
  NSInteger sepos = [string indexOf:@","];
  NSMutableString *sx = [[[string substringToIndex:sepos] trim] mutableCopy];
  NSMutableString *sy = [[[string substringFromIndex:sepos + 1] trim] mutableCopy];

  //NSLog(@"x:%@ y:%@", sx, sy);
  
  if ([sx removeSuffix:@"%"]) {
    // percent
    m.x = width / 100;
  } else if ([sx removeSuffix:@"s"]) {
    // segments
    m.x = self.segmentSize.width;
  }
  re.x = [sx.trim floatValue] * m.x;
  
  if ([sy removeSuffix:@"%"]) {
    // percent
    m.y = height / 100;
  } else if ([sy removeSuffix:@"s"]) {
    // segments
    m.y = self.segmentSize.height;
  }
  re.y = [sy.trim floatValue] * m.y;

  [sx release];
  [sy release];
  
  return re;
}

@end

@implementation THRect (THSegmentedRect)
-(THSegmentedRect *)segmentedRect {
  return [THSegmentedRect rectWithRect:self.rect];
}
-(THSegmentedRect *)segmentedRectWithCubicSize:(NSUInteger)size {
  return [THSegmentedRect rectWithRect:self.rect cubicSize:size];
}
-(THSegmentedRect *)segmentedRectWithWidth:(NSUInteger)wv
                                    height:(NSUInteger)hv
{
  return [THSegmentedRect rectWithRect:self.rect width:hv height:wv];
}
@end


@implementation NSBezierPath (THSegmentedRect)

-(id)traverseSegments:(NSString *)segmentDefinition 
               inRect:(THSegmentedRect *)segmentedRect
{
  // traversion ops:
  // 0 moveTo
  // 1 lineTo
  // 2 curveTo
  int op = 0;
  NSPoint points[3];
  
  //NSLog(@"traverse(\"%@\")", segmentDefinition);
  
  // FIXME parse sement definition
  for (NSString *seg in [segmentDefinition componentsSeparatedByString:@";"]) {
    // what now?
    
    seg = [seg trim];
    
    // determine the action
    if ([seg hasPrefix:@"_"]) {
      // indicates only a moveTo insted of a lineTo
      op = 0;
      seg = [seg shifted];
    } else if ([seg hasPrefix:@"~"]) {
      // curveTo
      op = 2;
      seg = [seg shifted];
    } else {
      // lineTo
      op = 1;
    }
    
    // determine the navigation points
    int si = 0;
    for (NSString *pos in [seg componentsSeparatedByString:@" "]) {
      NSPoint pt;
      
      // types are
      // 0 anchor
      // 1 absolute
      // 2 relative
      int type = 0;
      
      if ([pos hasPrefix:@"!"]) {
        type = 1;
        pos = [pos shifted];
      } else if ([pos hasPrefix:@"+"]) {
        type = 2;
        pos = [pos shifted];
      }
      
      if (type == 0 && ![pos contains:@","]) {
        //NSLog(@"Checking index %i", [pos intValue]);
        pt = [segmentedRect indicesOfSegmentAtIndex:[pos intValue]];
      } else {
        pt = [segmentedRect pointWithString:pos];
      }
      
      //NSLog(@"Point.raw: %@", NSStringFromPoint(pt));
      
      if (type == 0) {
        pt = [segmentedRect pointOfSegmentAtX:pt.x y:pt.y];
      } else if (type == 2) {
        // shift relatives by the point
        pt.x += self.currentPoint.x;
        pt.y += self.currentPoint.y;
      }
      
      //NSLog(@"Point.parsed: %@", NSStringFromPoint(pt));

      points[si] = pt;
      
      if (op != 2 || si == 2) {
        break;
      }
      si++;
    }
    
    // gathered all points
    // now move, curve or whatever, just do something!
    
    if (op == 0) {
      //NSLog(@"moving to %@", NSStringFromPoint(points[0]));
      [self moveToPoint:points[0]];
    } else if (op == 1) {
      //NSLog(@"line to %@", NSStringFromPoint(points[0]));
      [self lineToPoint:points[0]];
    } else if (op == 2) {
      //NSLog(@"curve to %@ with %@ and %@", 
      //      NSStringFromPoint(points[0]),
      //      NSStringFromPoint(points[1]),
      //      NSStringFromPoint(points[2]));
      [self curveToPoint:points[0] 
           controlPoint1:points[1] 
           controlPoint2:points[2]];
    }
  }
  
  return self;
}

@end

//
//  THGeometricFunctions.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 19.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "THGeometricFunctions.h"

NSNumber *iNum(NSInteger i) {
  return [NSNumber numberWithInt:i];
}

NSNumber *uNum(NSUInteger ui) {
  return [NSNumber numberWithUnsignedInt:ui];
}

NSNumber *fNum(CGFloat f) {
  return [NSNumber numberWithFloat:f];
}

NSNumber *dNum(double d) {
  return [NSNumber numberWithDouble:d];
}

NSRange THMakeRange(NSUInteger min, NSUInteger max) {
  NSUInteger loc = MIN(min, max);
  NSUInteger len = MAX(min, max) - loc;
  return NSMakeRange(loc, len);
}

//
// 2D Functions
//

CGFloat THLengthOfPoint(NSPoint pt) {
  return sqrt(pt.x * pt.x + pt.y * pt.y);
  //return ABS(pt.x) + ABS(pt.y);
}

CGFloat THAreaOfSize(NSSize size) {
  return size.width * size.height;
}

CGFloat THAreaOfRect(NSRect rect) {
  return THAreaOfSize(rect.size);
}

//
// NSPoint result functions
//
NSPoint THPointFromSize(NSSize size) {
  return NSMakePoint(size.width, size.height);
}

NSPoint THAbsPoint(NSPoint point) {
  return NSMakePoint(ABS(point.x), ABS(point.y));
}

NSPoint THFloorPoint(NSPoint point) {
  return NSMakePoint(floor(point.x), floor(point.y));
}

NSPoint THCeilPoint(NSPoint point) {
  return NSMakePoint(ceil(point.x), ceil(point.y));
}

NSPoint THRoundPoint(NSPoint point) {
  return NSMakePoint(round(point.x), round(point.y));
}

NSPoint THNegatePoint(NSPoint point) {
  return NSMakePoint(-point.x, -point.y);
}

NSPoint THInvertPoint(NSPoint point) {
  return NSMakePoint(1 / point.x, 1 / point.y);
}

NSPoint THSwapPoint(NSPoint point) {
  return NSMakePoint(point.y, point.x);
}

NSPoint THAddPoints(NSPoint one, NSPoint another) {
  return NSMakePoint(one.x + another.x, one.y + another.y);
}

NSPoint THSubtractPoints(NSPoint origin, NSPoint subtrahend) {
  return NSMakePoint(origin.x - subtrahend.x, origin.y - subtrahend.y);
}

NSPoint THSumPoints(NSUInteger count, NSPoint point, ...) {
  NSPoint re = point;
  
  va_list pts;
  va_start(pts, point);
  
  for (int i = 0; i < count; i++) {
    NSPoint pt = va_arg(pts, NSPoint);
    re.x += pt.x;
    re.y += pt.y;
  }
  
  va_end(pts);
  
  return re;
}

NSPoint THMultiplyPoint(NSPoint point, CGFloat multiplier) {
  return NSMakePoint(point.x * multiplier, point.y * multiplier);
}

NSPoint THMultiplyPointByPoint(NSPoint one, NSPoint another) {
  return NSMakePoint(one.x * another.x, one.y * another.y);
}

NSPoint THMultiplyPointBySize(NSPoint one, NSSize size) {
  return NSMakePoint(one.x * size.width, one.y * size.height);
}

NSPoint THRelativeToAbsolutePoint(NSPoint relative, NSRect bounds) {
  return NSMakePoint(relative.x * bounds.size.width  + bounds.origin.x,
                     relative.y * bounds.size.height + bounds.origin.y
                     );
}

NSPoint THAbsoluteToRelativePoint(NSPoint absolute, NSRect bounds) {
  return NSMakePoint((absolute.x - bounds.origin.x) / bounds.size.width, 
                     (absolute.y - bounds.origin.y) / bounds.size.height
                     );
}

NSPoint THDividePoint(NSPoint point, CGFloat divisor) {
  return NSMakePoint(point.x / divisor, point.y / divisor);
}

NSPoint THDividePointByPoint(NSPoint point, NSPoint divisor) {
  return NSMakePoint(point.x / divisor.x, point.y / divisor.y);
}

NSPoint THDividePointBySize(NSPoint point, NSSize divisor) {
  return NSMakePoint(point.x / divisor.width, point.y / divisor.height);
}


NSPoint THMovePoint(NSPoint origin, NSPoint target, CGFloat p) {
  // delta = distance fom target to origin
  NSPoint delta = THSubtractPoints(target, origin);
  // multiply that with the relative distance
  NSPoint way   = THMultiplyPoint(delta, p);
  // add it to the origin to move along the way
  return THAddPoints(origin, way);
}

NSPoint THMovePointAbs(NSPoint origin, NSPoint target, CGFloat pixels) {
  // Distance from target to origin
  NSPoint delta = THSubtractPoints(target, origin);
  // normalize that by x to recieve the x2y-ratio
  // but wait, if x is 0 already it can not be normalized
  if (delta.x == 0) {
    // in this case check whether y is empty too
    if (delta.y == 0) {
      // cannot move anywhere
      return origin;
    }
    return NSMakePoint(origin.x, 
                       origin.y + pixels * (delta.y > 0 ? 1.0 : -1.0));
  }
  // now, grab the normalized way
  CGFloat ratio = delta.y / delta.x;
  CGFloat x = pixels / sqrt(1.0 + ratio * ratio);
  if (delta.x < 0) x *= -1;
  NSPoint move = NSMakePoint(x, x * ratio);
  return THAddPoints(origin, move);
}

NSPoint THCenterOfRect(NSRect rect) {
  // simple math, just the center of the rect
  return NSMakePoint(rect.origin.x + rect.size.width  * 0.5, 
                     rect.origin.y + rect.size.height * 0.5);
}

NSPoint THCenterOfSize(NSSize size) {
  return NSMakePoint(size.width  * 0.5, 
                     size.height * 0.5);
}

NSPoint THEndOfRect(NSRect rect) {
  return NSMakePoint(rect.origin.x + rect.size.width,
                     rect.origin.y + rect.size.height);
}


/*
 *   +-------+
 *   |       |   
 *   |   a   |   +-------+
 *   |       |   |       |
 *   +-------+   |   b   |
 *               |       |
 *               +-------+
 */
NSPoint THCenterDistanceOfRects(NSRect a, NSRect b) {
  return THSubtractPoints(THCenterOfRect(a),
                          THCenterOfRect(b));
}

NSPoint THBorderDistanceOfRects(NSRect a, NSRect b) {
  // 
  // +------------ left
  // |
  // |     +------ right  
  // v     v
  // +-----+ <---- top
  // |     |
  // +-----+ <---- bottom
  //
  
  // distances, always from ones part to anothers counterpart
  // a zero x or y indicated that the rects overlap in that dimension
  NSPoint re = NSZeroPoint;
  
  NSPoint oa = a.origin;
  NSPoint ea = THEndOfRect(a);
  
  NSPoint ob = b.origin;
  NSPoint eb = THEndOfRect(b);
  
  // calculate the x and y separately

  // left / right check
  if (ea.x < ob.x) {
    // [a] [b] --- a left of b
    // positive re.x
    re.x = ob.x - ea.x;
  } else if (oa.x > eb.x) {
    // [b] [a] --- a right of b
    // negative re.x
    re.x = eb.x - oa.x;
  }
  
  // top / bottom check
  if (ea.y < ob.y) {
    // [a] --- a above b
    // [b]
    // positive re.y
    re.y = ob.y - ea.y;
  } else if (oa.y > eb.y) {
    // [b] --- a below b
    // [a]
    // negative re.y
    re.y = eb.y - oa.y;
  }
  
  return re;
}

NSPoint THNormalizedDistanceOfRects(NSRect from, NSRect to) {
  NSSize mul = THInvertSize(THBlendSizes(from.size, to.size, 0.5));
  NSPoint re = THCenterDistanceOfRects(to, from);
          re = THMultiplyPointBySize(re, mul);

  return re;
}

NSPoint THNormalizedDistanceToCenterOfRect(NSPoint point, NSRect rect) {
  NSPoint center = THCenterOfRect(rect);
  NSPoint half   = THMultiplyPoint(THPointFromSize(rect.size), 0.5);
  NSPoint re     = THSubtractPoints(point, center);
          re     = THMultiplyPointByPoint(re, half);
  
  return re;
}

NSPoint THPointDistanceToBorderOfRect(NSPoint point, NSRect rect) {
  NSPoint re = NSZeroPoint;
  
  NSPoint o = rect.origin;
  NSPoint e = THEndOfRect(rect);
  
  if (point.x < o.x) {
    re.x = point.x - re.x;
  } else if (point.x > e.x) {
    re.x = e.x - point.x;
  }
  
  if (point.y < o.y) {
    re.y = point.y - re.y;
  } else if (point.y > e.y) {
    re.y = e.y - point.y;
  }

  return re;
}

//
// NSSize functions
//

NSSize THSizeFromPoint(NSPoint point) {
  return NSMakeSize(point.x, point.y);
}

NSSize THAbsSize(NSSize size) {
  return NSMakeSize(ABS(size.width), ABS(size.height));
}

NSSize THAddSizes(NSSize one, NSSize another) {
  return NSMakeSize(one.width + another.width, 
                    one.height + another.height);
}

NSSize THInvertSize(NSSize size) {
  return NSMakeSize(1 / size.width, 1 / size.height);
}

NSSize THRatioOfSizes(NSSize inner, NSSize outer) {
  return NSMakeSize(inner.width / outer.width, 
                    inner.height / outer.height);
}

NSSize THMultiplySize(NSSize size, CGFloat multiplier) {
  return NSMakeSize(size.width * multiplier, 
                    size.height * multiplier);
}

NSSize THMultiplySizeBySize(NSSize size, NSSize another) {
  return NSMakeSize(size.width * another.width, 
                    size.height * another.height);
}

NSSize THMultiplySizeByPoint(NSSize size, NSPoint point) {
  return NSMakeSize(size.width * point.x, 
                    size.height * point.y);
}

NSSize THBlendSizes(NSSize one, NSSize another, CGFloat p) {
  NSSize way;
  way.width  = another.width - one.width;
  way.height = another.height - one.height;
  
  return NSMakeSize(one.width + p * way.width, 
                    one.height + p * way.height);
}

NSSize THSizeMax(NSSize one, NSSize another) {
  return NSMakeSize(MAX(one.width, another.width),
                    MAX(one.height, another.height));
}

NSSize THSizeMin(NSSize one, NSSize another) {
  return NSMakeSize(MIN(one.width, another.width),
                    MIN(one.height, another.height));
  
}

NSSize THSizeBound(NSSize preferred, NSSize minSize, NSSize maxSize) {
  NSSize re = preferred;
  
  re.width  = MIN(MAX(re.width,  minSize.width),  maxSize.width);
  re.height = MIN(MAX(re.height, minSize.height), maxSize.height);
  
  return re;
}


//
// NSRect result functions
//
NSRect THMakeRectFromPoint(NSPoint point) {
  return NSMakeRect(point.x, point.y, 0, 0);
}

NSRect THMakeRectFromSize(NSSize size) {
  return NSMakeRect(0, 0, size.width, size.height);
}

NSRect THMakeRect(NSPoint point, NSSize size) {
  return NSMakeRect(point.x, 
                    point.y, 
                    size.width, 
                    size.height);
}

NSRect THMakeSquare(NSPoint center, CGFloat radius) {
  return NSMakeRect(center.x - radius, 
                    center.y - radius, 
                    2 * radius, 
                    2 * radius);
}


NSRect THMultiplyRectBySize(NSRect rect, NSSize size) {
  return NSMakeRect(rect.origin.x    * size.width,
                    rect.origin.y    * size.height,
                    rect.size.width  * size.width,
                    rect.size.height * size.height
                    );
}

NSRect THRelativeToAbsoluteRect(NSRect relative, NSRect bounds) {
  return NSMakeRect(relative.origin.x    * bounds.size.width  + bounds.origin.x,
                    relative.origin.y    * bounds.size.height + bounds.origin.y,
                    relative.size.width  * bounds.size.width,
                    relative.size.height * bounds.size.height
                    );
}

NSRect THAbsoluteToRelativeRect(NSRect a, NSRect b) {
  return NSMakeRect((a.origin.x - b.origin.x) / b.size.width,
                    (a.origin.y - b.origin.y) / b.size.height,
                    a.size.width  / b.size.width,
                    a.size.height / b.size.height
                    );
}


NSRect THPositionRectOnRect(NSRect inner, NSRect outer, NSPoint position) {
  return NSMakeRect(outer.origin.x 
                    + (outer.size.width - inner.size.width) * position.x, 
                    outer.origin.y 
                    + (outer.size.height - inner.size.height) * position.y, 
                    inner.size.width, 
                    inner.size.height
                    );
}

NSRect THCenterRectOnPoint(NSRect rect, NSPoint center) {
  return NSMakeRect(center.x - rect.size.width  / 2, 
                    center.y - rect.size.height / 2, 
                    rect.size.width, 
                    rect.size.height);
}

NSRect THCenterRectOnRect(NSRect inner, NSRect outer) {
  return THPositionRectOnRect(inner, outer, THHalfPoint);
}

NSRect THSquareAround(NSPoint center, CGFloat distance) {
  return NSMakeRect(center.x - distance, 
                    center.y - distance, 
                    2 * distance, 
                    2 * distance
                    );
}

NSRect THBlendRects(NSRect from, NSRect to, CGFloat p) {
  NSRect re;

  CGFloat q = 1 - p;
  re.origin.x    = from.origin.x    * q + to.origin.x    * p;
  re.origin.y    = from.origin.y    * q + to.origin.y    * p;
  re.size.width  = from.size.width  * q + to.size.width  * p;
  re.size.height = from.size.height * q + to.size.height * p;

  return re;
}

NSRect THLeftEdge(NSRect rect, CGFloat width) {
  return NSMakeRect(rect.origin.x, 
                    rect.origin.y, 
                    width, 
                    rect.size.height);
}

NSRect THRightEdge(NSRect rect, CGFloat width) {
  return NSMakeRect(rect.origin.x + rect.size.width - width, 
                    rect.origin.y, 
                    width, 
                    rect.size.height);
}

NSRect THLowerEdge(NSRect rect, CGFloat height) {
  return NSMakeRect(rect.origin.x, 
                    rect.origin.y, 
                    rect.size.width, 
                    height);
}

NSRect THUpperEdge(NSRect rect, CGFloat height) {
  return NSMakeRect(rect.origin.x, 
                    rect.origin.y + rect.size.height - height, 
                    rect.size.width, 
                    height);
}

//
// Comparison Methods
//

BOOL THIsPointLeftOfRect(NSPoint point, NSRect rect) {
  return THPointDistanceToBorderOfRect(point, rect).x < 0;
}

BOOL THIsPointRightOfRect(NSPoint point, NSRect rect) {
  return THPointDistanceToBorderOfRect(point, rect).x > 0;
}

BOOL THIsPointAboveRect(NSPoint point, NSRect rect) {
  return THPointDistanceToBorderOfRect(point, rect).y < 0;
}

BOOL THIsPointBelowRect(NSPoint point, NSRect rect) {
  return THPointDistanceToBorderOfRect(point, rect).y > 0;
}

BOOL THIsRectLeftOfRect(NSRect rect, NSRect compare) {
  return THNormalizedDistanceOfRects(rect, compare).x <= -1;
}

BOOL THIsRectRightOfRect(NSRect rect, NSRect compare) {
  return THNormalizedDistanceOfRects(rect, compare).x >= 1;
}

BOOL THIsRectAboveRect(NSRect rect, NSRect compare) {
  return THNormalizedDistanceOfRects(rect, compare).y <= -1;
}

BOOL THIsRectBelowRect(NSRect rect, NSRect compare) {
  return THNormalizedDistanceOfRects(rect, compare).y >= 1;
}

//
// EOF
//


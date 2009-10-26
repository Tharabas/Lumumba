//
//  THGeometricFunctions.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 19.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//
// shortcuts for [NSNumber numberWithXY]
//
NSNumber *iNum(NSInteger i);
NSNumber *uNum(NSUInteger ui);
NSNumber *fNum(CGFloat f);
NSNumber *dNum(double d);

//
// NSRange from a min and max values
// even though the names imply that min should be greater than max
// the order does not matter
// the range will always start at the lower value and have
// a size to reach the upper value
//
NSRange THMakeRange(NSUInteger min, NSUInteger max);

//
// Predifined Points, Sizes and Rects
//
#define THHalfPoint NSMakePoint(0.5, 0.5)
#define THMaxPoint NSMakePoint(MAXFLOAT, MAXFLOAT)
#define THHalfSize NSMakeSize(0.5, 0.5)
#define THMaxSize NSMakeSize(MAXFLOAT, MAXFLOAT)
#define THRelationRect NSMakeRect(0, 0, 1, 1)

//
// Simple Length and Area calculus
//
CGFloat THLengthOfPoint(NSPoint pt);
CGFloat THAreaOfSize(NSSize size);
CGFloat THAreaOfRect(NSRect rect);

// Size -> Point conversion
NSPoint THPointFromSize(NSSize size);

//
// NSPoint result methods
//

// returns the absolute values of a point (pt.x >= 0, pt.y >= 0)
NSPoint THAbsPoint(NSPoint point);

// floor, ceil and round simply use those functions on both values of the point
NSPoint THFloorPoint(NSPoint point);
NSPoint THCeilPoint(NSPoint point);
NSPoint THRoundPoint(NSPoint point);

// pt.x = -pt.x, pt.y = -pt.x
NSPoint THNegatePoint(NSPoint point);

// pt.x = 1 / pt.x, pt.y = 1 / pt.y
NSPoint THInvertPoint(NSPoint point);

// exchanges both x and y values
NSPoint THSwapPoint(NSPoint point);

// sum of two points
NSPoint THAddPoints(NSPoint one, NSPoint another);

// subtracts the 2nd from the 1st point
NSPoint THSubtractPoints(NSPoint origin, NSPoint subtrahend);

// sums a list of points
NSPoint THSumPoints(NSUInteger count, NSPoint points, ...);

// multiplies both x and y with one multiplier
NSPoint THMultiplyPoint(NSPoint point, CGFloat multiplier);

// multiplies each value with its corresponding value in another point
NSPoint THMultiplyPointByPoint(NSPoint one, NSPoint another);

// multiplies each value with its corresponding value in a size
NSPoint THMultiplyPointBySize(NSPoint one, NSSize size);

// positions a relative {0-1,0-1} point within absolute bounds
NSPoint THRelativeToAbsolutePoint(NSPoint relative, NSRect bounds);

// calculates the relative {0-1,0-1} point from absolute bounds
NSPoint THAbsoluteToRelativePoint(NSPoint absolute, NSRect bounds);

NSPoint THDividePoint(NSPoint point, CGFloat divisor);
NSPoint THDividePointByPoint(NSPoint point, NSPoint divisor);
NSPoint THDividePointBySize(NSPoint point, NSSize divisor);

// moves from an origin towards the destination point
// at a distance of 1 it will reach the destination
NSPoint THMovePoint(NSPoint origin, NSPoint target, CGFloat relativeDistance);

// moves from an origin towards the destination point
// distance on that way is measured in pixels
NSPoint THMovePointAbs(NSPoint origin, NSPoint target, CGFloat pixels);

// returns the center point of a rect
NSPoint THCenterOfRect(NSRect rect);

// returns the center point of a size
NSPoint THCenterOfSize(NSSize size);

// will return the origin + size value of a rect
NSPoint THEndOfRect(NSRect rect);

// will return the average distance of two rects
NSPoint THCenterDistanceOfRects(NSRect from, NSRect to);

// will return the shortest possible distance in x and y
NSPoint THBorderDistanceOfRects(NSRect from, NSRect to);

// will return the shortes possible distance from point to rect
NSPoint THPointDistanceToBorderOfRect(NSPoint point, NSRect rect);

NSPoint THNormalizedDistanceOfRects(NSRect from, NSRect to);

//
// NSSize result methods
// 

// converts a point to a size
NSSize THSizeFromPoint(NSPoint point);

// ABS on both values of the size
NSSize THAbsSize(NSSize size);

// Adds the width and height of two sizes
NSSize THAddSizes(NSSize one, NSSize another);

// subtracts the subtrahends dimensions from the ones of the size
NSSize THSubtractSizes(NSSize size, NSSize subtrahend);

// returns 1 / value on both values of the size
NSSize THInvertSize(NSSize size);

// will return the ratio of an inner size to an outer size
NSSize THRatioOfSizes(NSSize inner, NSSize outer);

// will multiply a size by a single multiplier
NSSize THMultiplySize(NSSize size, CGFloat multiplier);

// will multiply a size by another size
NSSize THMultiplySizeBySize(NSSize size, NSSize another);

// will multiply a size by a point
NSSize THMultiplySizeByPoint(NSSize size, NSPoint point);

// blends one size towards another
// percentage == 0 -> one
// percentage == 1 -> another
// @see THMovePoint
NSSize THBlendSizes(NSSize one, NSSize another, CGFloat percentage);

NSSize THSizeMax(NSSize one, NSSize another);
NSSize THSizeMin(NSSize one, NSSize another);
NSSize THSizeBound(NSSize preferred, NSSize minSize, NSSize maxSize);

//
// NSRect result methods
//

// returns a zero sized rect with the argumented point as origin
NSRect THMakeRectFromPoint(NSPoint point);

// returns a zero point origin with the argumented size
NSRect THMakeRectFromSize(NSSize size);

// just another way of defining a rect
NSRect THMakeRect(NSPoint point, NSSize size);

// creates a square rect around a center point
NSRect THMakeSquare(NSPoint center, CGFloat radius);

NSRect THMultiplyRectBySize(NSRect rect, NSSize size);

// transforms a relative rect to an absolute within absolute bounds
NSRect THRelativeToAbsoluteRect(NSRect relative, NSRect bounds);

// transforms an absolute rect to a relative rect within absolute bounds
NSRect THAbsoluteToRelativeRect(NSRect absolute, NSRect bounds);

NSRect THPositionRectOnRect(NSRect inner, NSRect outer, NSPoint position);

// moves the origin of the rect
NSRect THCenterRectOnPoint(NSRect rect, NSPoint center);

// returns the innter rect with its posiion centeredn on the outer rect
NSRect THCenterRectOnRect(NSRect inner, NSRect outer);

// will a square rect with a given center
NSRect THSquareAround(NSPoint center, CGFloat distance);

// blends a rect from one to another
NSRect THBlendRects(NSRect from, NSRect to, CGFloat at);

// returns a rect at the left edge of a rect with a given inset width
NSRect THLeftEdge(NSRect rect, CGFloat width);

// returns a rect at the right edge of a rect with a given inset width
NSRect THRightEdge(NSRect rect, CGFloat width);

// returns a rect at the lower edge of a rect with a given inset width
NSRect THLowerEdge(NSRect rect, CGFloat height);

// returns a rect at the upper edge of a rect with a given inset width
NSRect THUpperEdge(NSRect rect, CGFloat height);

// macro to call a border drawing method with a border width
// this will effectively draw the border but clip the inner rect
//
// Example: THInsideClip(NSDrawLightBezel, rect, 2);
//          Will draw a 2px light beezel around a rect
#define THInsideClip(METHOD,RECT,BORDER) \
  METHOD(RECT, THLeftEdge( RECT, BORDER)); \
  METHOD(RECT, THRightEdge(RECT, BORDER)); \
  METHOD(RECT, THUpperEdge(RECT, BORDER)); \
  METHOD(RECT, THLowerEdge(RECT, BORDER))

//
// Comparison methods
//

BOOL THIsPointLeftOfRect(NSPoint point, NSRect rect);
BOOL THIsPointRightOfRect(NSPoint point, NSRect rect);
BOOL THIsPointAboveRect(NSPoint point, NSRect rect);
BOOL THIsPointBelowRect(NSPoint point, NSRect rect);

BOOL THIsRectLeftOfRect(NSRect rect, NSRect compare);
BOOL THIsRectRightOfRect(NSRect rect, NSRect compare);
BOOL THIsRectAboveRect(NSRect rect, NSRect compare);
BOOL THIsRectBelowRect(NSRect rect, NSRect compare);

//
// EOF
// 

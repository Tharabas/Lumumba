//
//  THSegmentedRect.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 26.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "THRect.h"

@class THPoint, THSize, THRect;

@interface THSegmentedRect : THRect {
  NSPoint segments;
  BOOL emptyBorder;
  
  NSSize minimumSegmentSize;
  NSSize maximumSegmentSize;
}

+(THSegmentedRect *)rectWithRect:(NSRect)rect;
+(THSegmentedRect *)rectWithRect:(NSRect)rect 
                       cubicSize:(NSUInteger)size;
+(THSegmentedRect *)rectWithRect:(NSRect)rect 
                           width:(NSUInteger)width
                          height:(NSUInteger)height;

@property (nonatomic, assign) BOOL emptyBorder;
@property (nonatomic, assign) NSUInteger horizontalSegments;
@property (nonatomic, assign) NSUInteger verticalSegments;

@property (nonatomic, assign) NSSize minimumSegmentSize;
@property (nonatomic, assign) NSSize maximumSegmentSize;

@property (readonly) NSUInteger segmentCount;
@property (readonly) NSSize segmentSize;

-(id)setCubicSize:(NSUInteger)size;
-(id)setDimensionWidth:(NSUInteger)width height:(NSUInteger)height;

-(NSPoint)indicesOfSegmentAtIndex:(NSUInteger)index;
-(NSUInteger)indexAtPoint:(NSPoint)pt;

-(THRect *)segmentAtIndex:(NSUInteger)index;
-(THRect *)segmentAtX:(NSUInteger)x y:(NSUInteger)y;

-(NSPoint)pointOfSegmentAtIndex:(NSUInteger)index;
-(NSPoint)pointOfSegmentAtX:(NSUInteger)x y:(NSUInteger)y;

-(NSRect)rectOfSegmentAtIndex:(NSUInteger)index;
-(NSRect)rectOfSegmentAtX:(NSUInteger)x y:(NSUInteger)y;

-(NSPoint)pointWithString:(NSString *)string;

@end

@interface THRect (THSegmentedRect)
-(THSegmentedRect *)segmentedRect;
-(THSegmentedRect *)segmentedRectWithCubicSize:(NSUInteger)size;
-(THSegmentedRect *)segmentedRectWithWidth:(NSUInteger)width 
                                    height:(NSUInteger)height;
@end


@interface NSBezierPath (THSegmentedRect)

-(id)traverseSegments:(NSString *)segmentDefinition 
               inRect:(THSegmentedRect *)segmentedRect;

@end


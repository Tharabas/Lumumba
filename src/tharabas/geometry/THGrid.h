//
//  THGrid.h
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "THPoint.h"
#import "THSize.h"
#import "THRect.h"
#import "THGrid.h"
#import "THMatrix.h"

enum {
  THGridStyleCompact = 0,
  THGridStyleHorizontal = 1,
  THGridStyleVertical = 2
};

enum THGridOrder {
  THGridRowMajorOrder = 0,
  THGridColumnMajorOrder = 1
};

@class THPoint, THSize, THRect, THMatrix;

@interface THGrid : NSObject {
  NSMutableArray *array;
  NSUInteger parallels;
  NSUInteger style;
  NSUInteger order;
  BOOL rowMajorOrder;
}

-(id)initWithCapacity:(NSUInteger)numItems;

@property (readonly) NSUInteger count;
@property (readonly) THSize* size;
@property (readonly) CGFloat width;
@property (readonly) CGFloat height;

@property (readonly) CGFloat min;
@property (readonly) CGFloat max;

@property (assign) NSUInteger parallels;
@property (assign) NSUInteger order;
@property (assign) NSUInteger style;

-(NSMutableArray *)elements;
-(NSNumber *)indexAtPoint:(NSPoint)point;
-(id)objectAtIndex:(NSUInteger)index;
-(id)objectAtPoint:(NSPoint)point;
-(THPoint *)pointAtIndex:(NSUInteger)index;

-(void)addObject:(id)anObject;
-(void)insertObject:(id)anObject atIndex:(NSUInteger)index;
-(void)removeObjectAtIndex:(NSUInteger)index;
-(void)removeAllObjects;

@end
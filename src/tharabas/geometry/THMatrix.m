//
//  THMatrix.m
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "THMatrix.h"


@implementation THMatrix

-(id)init {
  if ((self = super.init)) {
    data = [[NSMutableArray alloc] init];
    height = 0;
    width = 0;
  }
  
  return self;
}

-(void)dealloc {
  [data release];
  [super dealloc];
}

@synthesize width, height;

-(void)setHeight:(NSUInteger)hv {
  // this is easy, just extend or crop the array
  if (hv == height) {
    // NADA
    return;
  }
  if (hv > height) {
    // FIXME hier weiterschreiben
  }
}

-(void)setWidth:(NSUInteger)wv {
  
}

-(id)objectAtX:(NSUInteger)x y:(NSUInteger)y {
  if (x > width || y > height) {
    [NSException raise:@"THMatrixIndexOutOfBounds" 
                format:@"Matrix index (%u, %u) out of bounds (%u, %u)",
     x,y,width,height];
    return nil;
  }
  return [data objectAtIndex:(y * width + x)];
}

@end

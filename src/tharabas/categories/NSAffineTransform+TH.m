//
//  NSAffineTransform+TH.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 03.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "NSAffineTransform+TH.h"

@implementation NSAffineTransform (TH)

-(NSAffineTransform *)blendedTransformTo:(NSAffineTransform *)otherTransform
                            atPercentage:(CGFloat)percentage 
{
  if (percentage <= 0) {
    return self;
  } else if (percentage >= 1) {
    return otherTransform;
  }
  
  CGFloat p = percentage;
  CGFloat q = 1 - p;
  
  NSAffineTransform *re = [[NSAffineTransform alloc] init];

  NSAffineTransformStruct fromStruct = self.transformStruct;
  
  NSAffineTransformStruct toStruct = otherTransform.transformStruct;
  
  fromStruct.m11 = fromStruct.m11 * q + toStruct.m11 * p;
  fromStruct.m12 = fromStruct.m12 * q + toStruct.m12 * p;
  fromStruct.m21 = fromStruct.m21 * q + toStruct.m21 * p;
  fromStruct.m22 = fromStruct.m22 * q + toStruct.m22 * p;
  fromStruct.tX  = fromStruct.tX  * q + toStruct.tX  * p;
  fromStruct.tY  = fromStruct.tY  * q + toStruct.tY  * p;
  
  re.transformStruct = fromStruct;
  
  return [re autorelease];
}

-(CGAffineTransform)cgTransform {
  NSAffineTransformStruct s = self.transformStruct;
  return CGAffineTransformMake(s.m11, s.m12, s.m21, s.m22, s.tX, s.tY);
}

-(NSRect)transformRect:(NSRect)rect {
  NSRect re;
  
  re.origin = [self transformPoint:rect.origin];
  re.size   = [self transformSize:rect.size];
  
  return re;
}

-(void)translateBy:(NSPoint)pt {
  [self translateXBy:pt.x yBy:pt.y];
}

@end

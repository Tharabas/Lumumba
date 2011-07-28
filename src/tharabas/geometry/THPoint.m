//
//  THPoint.m
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "THPoint.h"

@implementation THPoint

#pragma mark statics

+(THPoint *)point {
  return [[[THPoint alloc] init] autorelease];
}

+(THPoint *)pointOf:(id)object {
  THPoint *re = [[THPoint alloc] init];
  
  if (object == nil) {
    return [re autorelease];
  }
  
  if ([object isKindOfClass:NSNumber.class]) {
    NSNumber *n = (NSNumber *)object;
    re.x = n.floatValue;
    re.y = n.floatValue;
  } else if ([object isKindOfClass:THPoint.class]) {
    THPoint *pt = (THPoint *)object;
    re.x = pt.x;
    re.y = pt.y;
  } else if ([object isKindOfClass:THSize.class]) {
    THSize *s = (THSize *)object;
    re.x = s.width;
    re.y = s.height;
  } else if ([object isKindOfClass:NSView.class]) {
    NSView *v = (NSView *)object;
    re.x = v.frame.origin.x;
    re.y = v.frame.origin.y;
  } else if ([object isKindOfClass:CALayer.class]) {
    CALayer *l = (CALayer *)object;
    re.x = l.frame.origin.x;
    re.y = l.frame.origin.y;
  } else if ([object isKindOfClass:NSEvent.class]) {
    NSEvent *event = (NSEvent *)object;
    re.x = event.locationInWindow.x;
    re.y = event.locationInWindow.y;
  }
  
  return [re autorelease];
}

+(THPoint *)pointWithX:(CGFloat)xv y:(CGFloat)yv {
  return [[[THPoint alloc] initWithX:xv y:yv] autorelease];
}

+(THPoint *)pointWithPoint:(NSPoint)pt {
  return [[[THPoint alloc] initWithPoint:pt] autorelease];
}

+(THPoint *)halfPoint {
  return [THPoint pointWithX:0.5 y:0.5];
}

+(BOOL)maybePoint:(id)object {
  if (object == nil) {
    return NO;
  }
  
  NSArray *allowedClasses = 
  [NSArray arrayWithObjects:
   [NSNumber class], [THPoint class], [THSize class],
   [NSView class], [CALayer class], [NSEvent class],
   nil];
  
  for (id clazz in allowedClasses) {
    if ([object isKindOfClass:clazz]) {
      return YES;
    }
  }
  
  return NO;
}

#pragma mark initializer

-(id)init {
  if ((self = [super init])) {
    x = 0;
    y = 0;
  }
  
  return self;
}

-(id)initWithX:(CGFloat)xv y:(CGFloat)yv {
  if ((self = [self init])) {
    x = xv;
    y = yv;
  }
  
  return self;
}

-(id)initWithPoint:(NSPoint)pt {
  return [self initWithX:pt.x y:pt.y];
}

-(id)copy {
  return [[THPoint alloc] initWithX:x y:y];
}

-(id)copyWithZone:(NSZone *)zone {
  return [[THPoint allocWithZone:zone] initWithX:x y:y];
}

#pragma mark properties

@synthesize x, y;

-(NSPoint)point {
  return NSMakePoint(self->x, self->y);
}

-(void)setPoint:(NSPoint)pt {
  self->x = pt.x;
  self->y = pt.y;
}

-(CGPoint)cgpoint {
  return CGPointMake(self->x, self->y);
}

-(CGFloat)min {
  return MIN(x,y);
}

-(CGFloat)max {
  return MAX(x,y);
}

#pragma mark methods

-(id)swap {
  CGFloat t = self->x;
  self->x = self->y;
  self->y = t;
  
  return self;
}

-(id)negate {
  self->x = -self->x;
  self->y = -self->y;
  
  return self;
}

-(id)invert {
  self->x = 1 / self->x;
  self->y = 1 / self->y;
  
  return self;
}

-(id)floor {
  self->x = floor(self->x);
  self->y = floor(self->y);
  
  return self;
}

-(id)round {
  self->x = round(self->x);
  self->y = round(self->y);
  
  return self;
}

-(id)ceil {
  self->x = ceil(self->x);
  self->y = ceil(self->y);
  
  return self;
}

-(id)square {
  self->x *= self->x;
  self->y *= self->y;
  
  return self;
}

-(id)root {
  self->x = sqrt(self->x);
  self->y = sqrt(self->y);
  
  return self;
}

-(id)ratio {
  CGFloat max = MAX(self->x, self->y);
  CGFloat min = MIN(self->x, self->y);
  if (min < 0 && -min > max) {
    max = -min;
  }
  
  if (max != 0) {
    self->x /= max;
    self->y /= max;
  }
  
  return self;
}

-(id)moveTo:(id)object {
  self->x = 0;
  self->y = 0;
  
  return [self moveBy:object];
}

-(id)moveTowards:(id)object withDistance:(CGFloat)relativeDistance {
  return [self moveTowardsPoint:[[THPoint pointOf:object] point] 
                   withDistance:relativeDistance
          ];
}

-(id)moveTowardsPoint:(NSPoint)pt withDistance:(CGFloat)relativeDistance {
  NSPoint delta = NSMakePoint((self.x - pt.x) * relativeDistance,
                              (self.y - pt.y) * relativeDistance);

  return [self moveByPoint:delta];
}

-(id)moveBy:(id)object {
  if (object == nil) {
    return self;
  }
  
  THPoint *p = [THPoint pointOf:object];
  self->x += p.x;
  self->y += p.y;
  
  return self;
}

-(id)moveByNegative:(id)object {
  if (object == nil) {
    return self;
  }
  
  THPoint *p = [THPoint pointOf:object];
  self->x -= p.x;
  self->y -= p.y;
  
  return self;
}

-(id)moveByPoint:(NSPoint)pt {
  self->x += pt.x;
  self->y += pt.y;
  
  return self;
}

-(id)moveByX:(CGFloat)xv andY:(CGFloat)yv {
  self->x += xv;
  self->y += yv;
  
  return self;
}

-(id)multiplyBy:(id)object {
  if (object == nil) {
    return self;
  }
  
  THPoint *p = [THPoint pointOf:object];
  self->x *= p.x;
  self->y *= p.y;
  
  return self;
}

-(id)divideBy:(id)object {
  if (object == nil) {
    return self;
  }
  
  THPoint *p = [THPoint pointOf:object];
  self->x /= p.x;
  self->y /= p.y;
  
  return self;
}

-(BOOL)equals:(id)object {
  if (object == nil) {
    return NO;
  }
  
  THPoint *p = [THPoint pointOf:object];
  
  return self->x == p->x && self->y == p->y;
}

-(BOOL)equalsPoint:(NSPoint)p {
  return self->x == p.x && self->y == p.y;
}

-(BOOL)isWithin:(id)object {
  if (object == nil) {
    return NO;
  }
  
  THRect *rect = [THRect rectOf:object];
  
  return [rect containsPoint:self.point];
}

-(NSString *)description {
  return [NSString stringWithFormat:@"%@(%4.f,%4.f)",
          self.className, x, y];
}

@end
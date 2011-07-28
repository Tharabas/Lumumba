//
//  THSize.m
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 28.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "THSize.h"

@implementation THSize

+(THSize *)size {
  return [[[THSize alloc] init] autorelease];
}

+(THSize *)sizeOf:(id)object {
  THSize *re = [[THSize alloc] initWithWidth:0 height:0];
  
  if (object == nil) {
    return [re autorelease];
  }
  
  if ([object isKindOfClass:[NSNumber class]]) {
    NSNumber *n = (NSNumber *)object;
    re.width  = n.floatValue;
    re.height = n.floatValue;
  } else if ([object isKindOfClass:[THPoint class]]) {
    THPoint *pt = (THPoint *)object;
    re.width  = pt.x;
    re.height = pt.y;
  } else if ([object isKindOfClass:[THSize class]]) {
    THSize *s = (THSize *)object;
    re.width  = s.width;
    re.height = s.height;
  } else if ([object isKindOfClass:[NSView class]]) {
    NSView *v = (NSView *)object;
    re.width = v.frame.size.width;
    re.height = v.frame.size.height;
  } else if ([object isKindOfClass:[CALayer class]]) {
    CALayer *l = (CALayer *)object;
    re.width = l.frame.size.width;
    re.height = l.frame.size.height;
  }
  
  return [re autorelease];
}

+(THSize *)sizeWithSize:(NSSize)s {
  return [[[THSize alloc] initWithSize:s] autorelease];
}

+(THSize *)sizeWithWidth:(CGFloat)w height:(CGFloat)h {
  return [[[THSize alloc] initWithWidth:w height:h] autorelease];
}

+(BOOL)maybeSize:(id)object {
  if (object == nil) {
    return NO;
  }
  
  NSArray *allowedClasses = 
    [NSArray arrayWithObjects:
     [NSNumber class], [THPoint class], [THSize class], [THRect class],
     [NSView class], [CALayer class], 
     nil];
  
  for (id clazz in allowedClasses) {
    if ([object isKindOfClass:clazz]) {
      return YES;
    }
  }
  
  return NO;
}

-(id)copy {
  return [[THSize alloc] initWithWidth:width height:height];
}

-(id)copyWithZone:(NSZone *)zone {
  return [[THSize allocWithZone:zone] initWithWidth:width height:height];
}

-(id)initWithWidth:(CGFloat)w height:(CGFloat)h {
  if ((self = [super init])) {
    width = w;
    height = h;
  }
  
  return self;
}

-(id)initWithSize:(NSSize)s {
  return [self initWithWidth:s.width height:s.height];
}

@synthesize width, height;

-(CGFloat)min {
  return MIN(self->width, self->height);
}

-(CGFloat)max {
  return MAX(self->width, self->height);
}

-(CGFloat)wthRatio {
  return self->width / self->height;
}

-(NSSize)size {
  return NSMakeSize(width, height);
}

-(void)setSize:(NSSize)s {
  width = s.width;
  height = s.height;
}

-(id)growBy:(id)factor {
  if (factor == nil) {
    return self;
  }
  
  THSize *size = [THSize sizeOf:factor];
  
  self->width += size.width;
  self->height += size.height;
  
  return self;
}

-(id)growByWidth:(CGFloat)w height:(CGFloat)h {
  self->width += w;
  self->height += h;
  
  return self;
}

-(id)multipyBy:(id)factor {
  if (factor == nil) {
    return self;
  }
  
  THSize *f = [THSize sizeOf:factor];
  
  self->width *= f.width;
  self->height *= f.height;
  
  return self;
}

-(id)multipyByWidth:(CGFloat)w height:(CGFloat)h {
  self->width *= w;
  self->height *= h;
  
  return self;
}

-(id)multipyByPoint:(NSPoint)point {
  self->width *= point.x;
  self->height *= point.y;
  
  return self;
}

-(id)multipyBySize:(NSSize)s {
  self->width *= s.width;
  self->height *= s.height;
  
  return self;
}

-(id)divideBy:(id)factor {
  if (factor == nil) {
    return self;
  }
  
  THSize *f = [THSize sizeOf:factor];
  
  self->width /= f.width;
  self->height /= f.height;
  
  return self;
}

-(id)divideByWidth:(CGFloat)w height:(CGFloat)h {
  self->width /= w;
  self->height /= h;
  
  return self;
}

-(id)divideByPoint:(NSPoint)point {
  self->width /= point.x;
  self->height /= point.y;
  
  return self;
}

-(id)divideBySize:(NSSize)s {
  self->width /= s.width;
  self->height /= s.height;
  
  return self;
}

-(id)swap {
  CGFloat t = self->width;
  self->width = self->height;
  self->height = t;
  
  return self;
}

-(id)negate {
  self->width = -self->width;
  self->height = -self->height;
  
  return self;
}

-(id)invert {
  self->width = 1 / self->width;
  self->height = 1 / self->height;
  
  return self;
}

-(NSString *)description {
  return [NSString stringWithFormat:@"%@(%4.f x %4.f)",
          self.className, width, height];
}

@end

//
//  THGradient.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 28.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "THGradient.h"
#import "NSArray+TH.h"
#import "NSColor+Conversion.h"

@interface THGradient (Private)
-(void)_init;
@end

@implementation THGradient

-(void)_init {
  self->transition = nil;
}

-(id)init {
  if ((self = super.init)) {
    [self _init];
  }
  
  return self;
}

-(id)initWithColors:(NSArray *)colorArray {
  if (![colorArray allKindOfClass:NSColor.class]) {
    NSMutableArray *colors = NSMutableArray.array;
    for (id o in colorArray) {
      if ([o isKindOfClass:NSColor.class]) {
        [colors addObject:o];
      } else if ([o isKindOfClass:NSString.class]) {
        NSColor *color = [o colorValue];
        if (color != nil) {
          [colors addObject:color];
        }
      } else {
        // unknown type
      }
    }
    
    colorArray = colors;
  }
  
  if ((self = [super initWithColors:colorArray])) {
    [self _init];
  };
  
  return self;
}

-(void)dealloc {
  if (self->transition != nil) {
    [transition release];
  }
  
  [super dealloc];
}

@synthesize transition;

-(NSColor *)interpolatedColorAtLocation:(CGFloat)location {
  if (transition != nil) {
    return [super interpolatedColorAtLocation:transition(location)];
  }
  
  return [super interpolatedColorAtLocation:location];
}

+(THGradient *)glossyGradientWithColor:(NSColor *)color {
  THGradient *re = THGradient.alloc;
  
  NSColor *rgbColor = color.calibratedRGBColor;
  NSColor *darker   = rgbColor.darker;
  NSColor *brighter = rgbColor.brighter;
  NSColor *contrast = brighter.brighter;
  NSColor *mixin    = NSColor.yellowColor;
  mixin = [mixin blendedColorWithFraction:1.0 - rgbColor.saturationComponent 
                                  ofColor:NSColor.whiteColor];
  
  NSColor *highlight = [[rgbColor blendedColorWithFraction:0.2 ofColor:mixin]
                        colorWithAlphaComponent:rgbColor.alphaComponent];
  
  const CGFloat distance = 0.05;
  
  [re initWithColorsAndLocations:
   darker, 0.0,
   brighter, distance,
   color, 0.5,
   contrast, 0.5000001,
   highlight, 1.0 - distance,
   color, 1.0,
   nil
   ];
  
  return re.autorelease;
}

@end

@implementation NSColor (THGradient)

-(THGradient *)glossyGradient {
  return [THGradient glossyGradientWithColor:self];
}

@end

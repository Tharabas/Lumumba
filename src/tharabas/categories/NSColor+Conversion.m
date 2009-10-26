//
//  NSColor+Conversion.m
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 16.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "NSColor+Conversion.h"
#import "NSString+TH.h"
#import "NSArray+TH.h"
#import "THArgList.h"
#import "THWebNamedColors.h"

@implementation NSColor (THColorConversion)

+ (NSColor *)colorWithName:(NSString *)colorName {
  // name lookup
  NSString *lcc = colorName.lowercaseString;
  NSColorList *list = [THWebNamedColors webNamedColors];
  for (NSString *key in list.allKeys) {
    if ([key.lowercaseString isEqual:lcc]) {
      return [list colorWithKey:key];
    }
  }
  
  for (list in [NSColorList availableColorLists]) {
    for (NSString *key in list.allKeys) {
      if ([key.lowercaseString isEqual:lcc]) {
        return [list colorWithKey:key];
      }
    }
  }
  
  return nil;
}

+ (NSColor *)colorFromString:(NSString *)string {
  if ([string hasPrefix:@"#"]) {
    return [NSColor colorFromHexString:string];
  }
  
  // shifting operations
  NSRange shiftRange = [string rangeOfAny:@"<! <= << <> >> => !>".wordSet];
  if (shiftRange.location != NSNotFound) {
    CGFloat p = 0.5;
    // determine the first of the operations
    NSString *op = [string substringWithRange:shiftRange];
    if ([op isEqual:@"<>"]) {
      // this will stay 50/50
    } else if ([op isEqual:@"<!"]) {
      p = 0.95;
    } else if ([op isEqual:@"<="]) {
      p = 0.85;
    } else if ([op isEqual:@"<<"]) {
      p = 0.66;
    } else if ([op isEqual:@">>"]) {
      p = 0.33;
    } else if ([op isEqual:@"=>"]) {
      p = 0.15;
    } else if ([op isEqual:@"!>"]) {
      p = 0.05;
    }

    // shift operators
    NSString *head = [string substringToIndex:
                      shiftRange.location];
    NSString *tail = [string substringFromIndex:
                      shiftRange.location + shiftRange.length];
    
    NSColor *first = head.trim.colorValue;
    NSColor *second = tail.trim.colorValue;
    
    if (first != nil && second != nil) {
      return [first blendedColorWithFraction:p ofColor:second];
    }
    if (first != nil) {
      return first;
    }
    return second;
  }
  
  if ([string contains:@" "]) {
    NSString *head = nil, *tail = nil;
    list(&head, &tail) = string.decapitate;
    
    head = head.lowercaseString;
    NSColor *tailColor = [NSColor colorFromString:tail];
    
    if (tailColor) {
      if ([head isEqualToString:@"translucent"]) {
        return tailColor.translucent;
      } else if ([head isEqualToString:@"watermark"]) {
        return tailColor.watermark;
      } else if ([head isEqualToString:@"bright"]) {
        return tailColor.bright;
      } else if ([head isEqualToString:@"brighter"]) {
        return tailColor.brighter;
      } else if ([head isEqualToString:@"dark"]) {
        return tailColor.dark;
      } else if ([head isEqualToString:@"darker"]) {
        return tailColor.darker;
      } else if ([head hasSuffix:@"%"]) {
        return [tailColor colorWithAlphaComponent:head.popped.floatValue / 100.0];
      }
    }
  }
  
  if ([string contains:@","]) {
    NSString *comp = string;
    NSString *func = @"rgb";
    
    if ([string contains:@"("] && [string hasSuffix:@")"]) {
      comp = [string substringBetweenPrefix:@"(" andSuffix:@")"];
      func = [[string substringBefore:@"("] lowercaseString];
    }
    
    NSArray *vals = [comp componentsSeparatedByString:@","];
    CGFloat values[5];
    for (int i = 0; i < 5; i++) {
      values[i] = 1.0;
    }
    
    for (int i = 0; i < vals.count; i++) {
      NSString *v = [[vals objectAtIndex:i] trim];
      if ([v hasSuffix:@"%"]) {
        values[i] = [[v substringBefore:@"%"] floatValue] / 100.0;
      } else {
        // should be a float
        values[i] = v.floatValue;
        if (values[i] > 1) {
          values[i] /= 255.0;
        }
      }
      values[i] = MIN(MAX(values[i], 0), 1);
    }
    
    if (vals.count <= 2) {
      // grayscale + alpha
      return [NSColor colorWithDeviceWhite:values[0] 
                                     alpha:values[1]
              ];
    } else if (vals.count <= 5) {
      // rgba || hsba
      if ([func hasPrefix:@"rgb"]) {
        return [NSColor colorWithDeviceRed:values[0]
                                     green:values[1]
                                      blue:values[2]
                                     alpha:values[3]
                ];
      } else if ([func hasPrefix:@"hsb"]) {
        return [NSColor colorWithDeviceHue:values[0]
                                saturation:values[1]
                                brightness:values[2]
                                     alpha:values[3]
                ];
      } else if ([func hasPrefix:@"cmyk"]) {
        return [NSColor colorWithDeviceCyan:values[0]
                                    magenta:values[1]
                                     yellow:values[2]
                                      black:values[3]
                                      alpha:values[4]
                ];
      } else {
        NSLog(@"Unrecognized Prefix <%@> returning nil", func);
      }
    }
  }
  
  return [NSColor colorWithName:string];
}

+ (NSColor *)colorFromHexString:(NSString *)hexString
{
	BOOL useHSB = NO;
  BOOL useCalibrated = NO;
  
  if (hexString.length == 0) {
		return NSColor.blackColor;
	}
	
	hexString = hexString.trim.uppercaseString;
	
	if ([hexString hasPrefix:@"#"]) {
		hexString = hexString.shifted;
	}
  
  if ([hexString hasPrefix:@"!"]) {
    useCalibrated = YES;
    hexString = hexString.shifted;
  }

  if ([hexString hasPrefix:@"*"]) {
    useHSB = YES;
    hexString = hexString.shifted;
  }
  
	int mul = 1;
  int max = 3;
	CGFloat v[4];
  
  // full opacity by default
  v[3] = 1.0;
	
  if (hexString.length == 8 || hexString.length == 4) {
    max++;
  }
  
	if (hexString.length == 6 || hexString.length == 8) {
		// #RRGGBB || #RRGGBBAA
		mul = 2;
	} else if (hexString.length == 3 || hexString.length == 4) {
		// #RGB || #RGBA
		mul = 1;
	} else {
		return nil;
	}
	
	for (int i = 0; i < max; i++) {
		NSString *sub = [hexString substringWithRange:NSMakeRange(i * mul, mul)];
		NSScanner *scanner = [NSScanner scannerWithString:sub];
		uint value = 0;
		[scanner scanHexInt: &value];
		v[i] = (float) value / (float) 0xFF;
	}
	
	// only at full color
  
	if (useHSB) {
    if (useCalibrated) {
      return [NSColor colorWithCalibratedHue:v[0] 
                                  saturation:v[1] 
                                  brightness:v[2] 
                                       alpha:v[3]
              ];
      
    }
    
    return [NSColor colorWithDeviceHue:v[0] 
                            saturation:v[1] 
                            brightness:v[2] 
                                 alpha:v[3]
            ];
  }

  if (useCalibrated) {
    return [NSColor colorWithCalibratedRed:v[0] 
                                     green:v[1] 
                                      blue:v[2] 
                                     alpha:v[3]
            ];
  }
  
	return [NSColor colorWithDeviceRed:v[0] 
                               green:v[1] 
                                blue:v[2] 
                               alpha:v[3]
          ];
}

- (NSColor *)deviceRGBColor {
  return [self colorUsingColorSpaceName:NSDeviceRGBColorSpace];
}

- (NSColor *)calibratedRGBColor {
  return [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
}

- (NSString *)toHex
{
  CGFloat r,g,b,a;
  [[self calibratedRGBColor] getRed:&r green:&g blue:&b alpha:&a];
  
	int ri = r * 0xFF;
	int gi = g * 0xFF;
	int bi = b * 0xFF;

  return [[NSString stringWithFormat:@"%02x%02x%02x", ri, gi, bi] uppercaseString];
}

//
// Convenienct Methods to mess a little with the color values
//

- (CGFloat)relativeBrightness {
  CGFloat r, g, b, a;
  [[self calibratedRGBColor] getRed:&r green:&g blue:&b alpha:&a];
  return sqrt((r * r * 0.241) + (g * g * 0.691) + (b * b * 0.068));
}

- (BOOL)isBright {
  return self.relativeBrightness > 0.57;
}

- (NSColor *)bright {
  return [NSColor colorWithDeviceHue:self.hueComponent
                          saturation:0.3
                          brightness:1.0
                               alpha:self.alphaComponent];
}

- (NSColor *)brighter {
  CGFloat h,s,b,a;
  [[self calibratedRGBColor] getHue:&h saturation:&s brightness:&b alpha:&a];
  return [NSColor colorWithDeviceHue:h
                          saturation:s
                          brightness:MIN(1.0, MAX(b * 1.10, b + 0.05))
                               alpha:a
          ];
}

- (BOOL)isDark {
  return self.relativeBrightness < 0.42;
}

- (NSColor *)dark {
  return [NSColor colorWithDeviceHue:self.hueComponent
                          saturation:0.8
                          brightness:0.3
                               alpha:self.alphaComponent];
}
- (NSColor *)darker {
  CGFloat h,s,b,a;
  [[self calibratedRGBColor] getHue:&h saturation:&s brightness:&b alpha:&a];
  return [NSColor colorWithDeviceHue:h
                          saturation:s
                          brightness:MAX(0.0, MIN(b * 0.9, b - 0.05))
                               alpha:a
          ];
}

- (NSColor *)redshift {
  CGFloat h,s,b,a;
  [self.deviceRGBColor getHue:&h saturation:&s brightness:&b alpha:&a];
  h += h > 0.5 ? 0.1 : -0.1;
  if (h < 1) {
    h++;
  } else if (h > 1) {
    h--;
  }
  return [NSColor colorWithDeviceHue:h saturation:s brightness:b alpha:a];
  
}

- (NSColor *)blueshift {
  CGFloat c = self.hueComponent;
  c += c < 0.5 ? 0.1 : -0.1;
  return [NSColor colorWithDeviceHue:c
                          saturation:self.saturationComponent
                          brightness:self.brightnessComponent
                               alpha:self.alphaComponent];
}

- (NSColor *)blend:(NSColor *)other {
  return [self blendedColorWithFraction:0.5 ofColor:other];
}

- (NSColor *)whitened {
  return [self blend:NSColor.whiteColor];
}

- (NSColor *)blackened {
  return [self blend:NSColor.blackColor];
}

- (NSColor *)contrastingForegroundColor {
  NSColor *c = self.calibratedRGBColor;
  if (!c) {
    NSLog(@"Cannot create contrastingForegroundColor for color %@", self);
    return NSColor.blackColor;
  }
  if (!c.isBright) {
    return NSColor.whiteColor;
  }
  return NSColor.blackColor;
}

- (NSColor *)complement {
  NSColor *c = self.calibratedRGBColor;
  if (!c) {
    NSLog(@"Cannot create complement for color %@", self);
    return self;
  }
  
  CGFloat h,s,b,a;
  [c getHue:&h saturation:&s brightness:&b alpha:&a];
  h += 0.5;
  if (h > 1) {
    h -= 1.0;
  }
  return [NSColor colorWithDeviceHue:h
                          saturation:s
                          brightness:b
                               alpha:a];
}

- (NSColor *)rgbComplement {
  NSColor *c = self.calibratedRGBColor;
  if (!c) {
    NSLog(@"Cannot create complement for color %@", self);
    return self;
  }
  
  CGFloat r,g,b,a;
  [c getRed:&r green:&g blue:&b alpha:&a];
  return [NSColor colorWithDeviceRed:1.0 - r
                               green:1.0 - g
                                blue:1.0 - b
                               alpha:a];
}

// 
// convenience for alpha shifting
//

- (NSColor *)opaque {
  return [self colorWithAlphaComponent:1.0];
}

- (NSColor *)lessOpaque {
  return [self colorWithAlphaComponent:MAX(0.0, self.alphaComponent * 0.8)];
}

- (NSColor *)moreOpaque {
  return [self colorWithAlphaComponent:MIN(1.0, self.alphaComponent / 0.8)];
}

- (NSColor *)translucent {
  return [self colorWithAlphaComponent:0.65];
}

- (NSColor *)watermark {
  return [self colorWithAlphaComponent:0.25];
}

//
// comparison methods
//
-(NSColor *)rgbDistanceToColor:(NSColor *)color {
  if (!color) {
    return nil;
  }
  
  CGFloat mr,mg,mb,ma, or,og,ob,oa;
  [self.calibratedRGBColor  getRed:&mr green:&mg blue:&mb alpha:&ma];
  [color.calibratedRGBColor getRed:&or green:&og blue:&ob alpha:&oa];

  return [NSColor colorWithCalibratedRed:ABS(mr - or)
                                   green:ABS(mg - og)
                                    blue:ABS(mb - ob)
                                   alpha:ABS(ma - oa)
          ];
}

-(NSColor *)hsbDistanceToColor:(NSColor *)color {
  CGFloat mh,ms,mb,ma, oh,os,ob,oa;
  [self.calibratedRGBColor  getHue:&mh saturation:&ms brightness:&mb alpha:&ma];
  [color.calibratedRGBColor getHue:&oh saturation:&os brightness:&ob alpha:&oa];
  
  // as the hue is circular 0.0 lies next to 1.0
  // and thus 0.5 is the most far away from both
  // distance values exceeding 0.5 will result in a fewer real distance
  CGFloat hd = ABS(mh - oh);
  if (hd > 0.5) {
    hd = 1 - hd;
  }
  
  return [NSColor colorWithCalibratedHue:hd
                              saturation:ABS(ms - os)
                              brightness:ABS(mb - ob)
                                   alpha:ABS(ma - oa)
          ];
}

-(CGFloat)rgbWeight {
  CGFloat r,g,b,a;
  [self.calibratedRGBColor getRed:&r green:&g blue:&b alpha:&a];
  
  return (r + g + b) / 3.0;
}

-(CGFloat)hsbWeight {
  CGFloat h,s,b,a;
  [self.calibratedRGBColor getHue:&h saturation:&s brightness:&b alpha:&a];
  
  return (h + s + b) / 3.0;
}

-(BOOL)isBlueish {
  CGFloat r,g,b,a;
  [self getRed:&r green:&g blue:&b alpha:&a];
  return b - MAX(r,g) > 0.2;
}

-(BOOL)isRedish {
  CGFloat r,g,b,a;
  [self getRed:&r green:&g blue:&b alpha:&a];
  return r - MAX(b,g) > 0.2;
}

-(BOOL)isGreenish {
  CGFloat r,g,b,a;
  [self getRed:&r green:&g blue:&b alpha:&a];
  return g - MAX(r,b) > 0.2;
}

-(BOOL)isYellowish {
  CGFloat r,g,b,a;
  [self getRed:&r green:&g blue:&b alpha:&a];
  return ABS(r - g) < 0.1 && MIN(r,g) - b > 0.2;
}

@end

@implementation NSString (THColorConversion)

- (NSColor *)colorValue {
  return [NSColor colorFromString:self];
}

@end

@implementation NSArray (THColorConversion)

- (NSArray *)colorValues {
  return [self arrayPerformingSelector:@selector(colorValue)];
}

@end

//
//  NSColor+Conversion.h
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 16.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (THColorConversion)

+ (NSColor *)colorWithName:(NSString *)colorName;
+ (NSColor *)colorFromString:(NSString *)string;
+ (NSColor *)colorFromHexString:(NSString *)hexString;

- (NSString *)toHex;

@property (readonly) NSColor *deviceRGBColor;
@property (readonly) NSColor *calibratedRGBColor;

@property (readonly) CGFloat relativeBrightness;

@property (readonly) BOOL isBright;
@property (readonly) NSColor *bright;
@property (readonly) NSColor *brighter;

@property (readonly) BOOL isDark;
@property (readonly) NSColor *dark;
@property (readonly) NSColor *darker;

@property (readonly) NSColor *redshift;
@property (readonly) NSColor *blueshift;

-(NSColor *)blend:(NSColor *)other;

@property (readonly) NSColor *whitened;
@property (readonly) NSColor *blackened;

@property (readonly) NSColor *contrastingForegroundColor;
@property (readonly) NSColor *complement;
@property (readonly) NSColor *rgbComplement;

@property (readonly) NSColor *opaque;
@property (readonly) NSColor *lessOpaque;
@property (readonly) NSColor *moreOpaque;
@property (readonly) NSColor *translucent;
@property (readonly) NSColor *watermark;

-(NSColor *)rgbDistanceToColor:(NSColor *)color;
-(NSColor *)hsbDistanceToColor:(NSColor *)color;
@property (readonly) CGFloat rgbWeight;
@property (readonly) CGFloat hsbWeight;

@property (readonly) BOOL isBlueish;
@property (readonly) BOOL isRedish;
@property (readonly) BOOL isGreenish;
@property (readonly) BOOL isYellowish;

@end

@interface NSString (THColorConversion)
@property (readonly) NSColor *colorValue;
@end

@interface NSArray (THColorConversion)
@property (readonly) NSArray *colorValues;
@end



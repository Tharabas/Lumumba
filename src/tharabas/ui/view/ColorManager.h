//
//  ColorManager.h
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 27.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Lumumba/THFunctions.h>
#import <Lumumba/THCategories.h>
#import "THGradient.h"

@interface ColorManager : NSObject {
  NSMutableDictionary *colors;
  NSMutableDictionary *gradients;
  NSMutableDictionary *fonts;

  NSString *alternative;
  BOOL useAlternativeColoring;
  
  NSColor *fallbackColor;
  NSGradient *fallbackGradient;
  NSFont *fallbackFont;
  
  NSMutableSet *sourceFiles;
}

+(ColorManager *)sharedManager;

+(NSColor *)colorWithName:(NSString *)name;
-(NSColor *)colorWithName:(NSString *)name;
-(NSColor *)colorWithName:(NSString *)name fallbackColor:(NSColor *)fallback;
-(void)setColor:(NSColor *)color forName:(NSString *)name;

+(NSGradient *)gradientWithName:(NSString *)name;
-(NSGradient *)gradientWithName:(NSString *)name;
-(NSGradient *)gradientWithName:(NSString *)name fallbackGradient:(NSGradient *)fallback;
-(void)setGradient:(NSGradient *)gradient forName:(NSString *)name;

+(NSFont *)fontWithName:(NSString *)name;
-(NSFont *)fontWithName:(NSString *)name;
-(NSFont *)fontWithName:(NSString *)name fallbackFont:(NSFont *)font;
-(void)setFont:(NSFont *)font forName:(NSString *)name;

-(void)loadFile:(NSString *)path;
-(void)loadResourceFile:(NSString *)name;
-(void)loadDefaultColors;
-(void)reload;

@property (nonatomic, assign) BOOL useAlternativeColoring;
@property (nonatomic, retain) NSString *alternative;

@end

@interface NSString (ColorManager)

@property (readonly) NSColor *managedColor;
@property (readonly) NSGradient *managedGradient;
@property (readonly) NSFont *managedFont;

@end


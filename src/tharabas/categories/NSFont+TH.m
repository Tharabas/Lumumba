//
//  NSFont+TH.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 30.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "NSFont+TH.h"
#import "THSugar.h"
#import "NSString+TH.h"
#import "THArgList.h"

@implementation NSFont(TH)

#define NSFontAutoSizesMAX 25
#define NSFontAutoSizeFactor 1.2
static const CGFloat NSFontAutoSizes[NSFontAutoSizesMAX] = {
  // 10 each line
  4,   5,  6,  7,  8,  9, 10, 11, 12, 14, 
  16, 18, 20, 22, 24, 28, 32, 36, 40, 48, 
  56, 62, 72, 92, 112
};

+(CGFloat)fontSizeByName:(NSString *)name {
  static NSDictionary *namedFontSizes = nil;
  if (!namedFontSizes) {
#define $F(S, N) [NSNumber numberWithFloat:S], @#N
    namedFontSizes = [NSDictionary dictionaryWithObjectsAndKeys:
                      $F(11, normal),
                      $F(10, small),
                      $F( 8, x-small),
                      $F( 6, xx-small),
                      $F( 4, micro),
                      $F(14, large),
                      $F(18, x-large),
                      $F(24, xx-large),
                      $F(32, 3x-large),
                      $F(64, huge),
                      nil];
#undef $F
  }
  
  NSNumber *n = [namedFontSizes valueForKey:name];
  
  if (!n) {
    return 11.0;
  }
  
  return n.floatValue;
}

+(NSFont *)fontWithDescription:(NSString *)description {
  NSFont *re = nil;
  
  CGFloat fSize = 12.0;
  NSString *name = nil, *size = nil, *options = nil;
  list(&name, &size, &options) = description.splitByComma;
  
  if (name) {
    if (size && !size.isEmpty) {
      fSize = size.floatValue;
    }
    
    re = [NSFont fontWithName:name.trim size:fSize];
    
    if (options) {
      options = options.trim.lowercaseString;
      
      if ([options contains:@"bold"]) {
        re = re.bold;
      }
      if ([options contains:@"italic"]) {
        re = re.italic;
      }
      if ([options contains:@"expanded"]) {
        re = re.expanded;
      } else if ([options contains:@"condensed"]) {
        re = re.condensed;
      }
      if ([options contains:@"vertical"]) {
        re = re.vertical;
      }
      if ([options contains:@"optimized"]) {
        re = re.UIOptimized;
      }
    }
  }
  
  return re;
}

-(NSFont *)fontWithSize:(CGFloat)size {
  return [NSFont fontWithName:self.fontName size:size];
}

+(NSUInteger)subjectiveFontSizeIndex:(CGFloat)fontSize {
  for (NSUInteger i = 0; i < NSFontAutoSizesMAX; i++) {
    if (fontSize <= NSFontAutoSizes[i]) {
      return i;
    }
  }
  
  return NSNotFound;
}

-(NSFont *)bigger {
  NSUInteger index = [NSFont subjectiveFontSizeIndex:self.pointSize];
  if (index > NSFontAutoSizesMAX - 2) {
    return [self fontWithSize:self.pointSize * NSFontAutoSizeFactor];
  }
  return [self fontWithSize:NSFontAutoSizes[index + 1]];
}

-(NSFont *)smaller {
  NSUInteger index = [NSFont subjectiveFontSizeIndex:self.pointSize];
  if (index == NSNotFound) {
    return [self fontWithSize:self.pointSize * (1 / NSFontAutoSizeFactor)];
  }
  if (index == 0) {
    return self;
  }
  return [self fontWithSize:NSFontAutoSizes[index - 1]];
}

-(NSFont *)bold {
  return [[NSFontManager sharedFontManager] convertFont:self
                                            toHaveTrait:NSFontBoldTrait];
}

-(NSFont *)italic {
  return [[NSFontManager sharedFontManager] convertFont:self
                                            toHaveTrait:NSFontItalicTrait];
}

-(NSFont *)expanded {
  return [[NSFontManager sharedFontManager] convertFont:self
                                            toHaveTrait:NSFontExpandedTrait];
}

-(NSFont *)condensed {
  return [[NSFontManager sharedFontManager] convertFont:self
                                            toHaveTrait:NSFontCondensedTrait];
}

-(NSFont *)monospaced {
  return [[NSFontManager sharedFontManager] convertFont:self
                                            toHaveTrait:NSFontMonoSpaceTrait];
}

-(NSFont *)vertical {
  return [[NSFontManager sharedFontManager] convertFont:self
                                            toHaveTrait:NSFontVerticalTrait];
}

-(NSFont *)UIOptimized {
  return [[NSFontManager sharedFontManager] convertFont:self
                                            toHaveTrait:NSFontUIOptimizedTrait];
}

@end

@implementation NSString (NSFont_TH)
-(NSFont *)fontValue {
  return [NSFont fontWithDescription:self];
}
@end

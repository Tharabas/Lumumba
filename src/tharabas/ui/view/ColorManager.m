//
//  ColorManager.m
//  LumumbaFramework
//
//  Created by Benjamin Schüttler on 27.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "ColorManager.h"

@implementation ColorManager

typedef enum _ValueType {
  TypeColor    = 0,
  TypeGradient = 1,
  TypeFont     = 2
} ValueType;

static ColorManager *ColorManager_sharedInstance = nil;

+(ColorManager *)sharedManager {
  if (ColorManager_sharedInstance == nil) {
    ColorManager_sharedInstance = [[self alloc] init];
  }
  
  return ColorManager_sharedInstance;
}

-(id)init {
  self = super.init;
  
  alternative = nil;
  useAlternativeColoring = @"useAlternativeColoring".boolInDefaults;
  
  fallbackColor = NSColor.clearColor;
  fallbackGradient = [[NSGradient alloc] initWithColors:$array(fallbackColor)];
  fallbackFont = nil;
  
  colors    = NSMutableDictionary.new;
  gradients = NSMutableDictionary.new;
  fonts     = NSMutableDictionary.new;
  
  sourceFiles = NSMutableSet.new;
  
  // some named colors
  [self loadDefaultColors];
    
  return self;
}

-(void)dealloc {
  [colors release];
  [gradients release];
  
  [fallbackColor release];
  [fallbackGradient release];
  
  [sourceFiles release];
  
  [super dealloc];
}

-(void)loadFile:(NSString *)path {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSError *error = nil;
  
  if (![fileManager fileExistsAtPath:path]) {
    NSLog(@"Could not initialize colors from unknown file: %@", path);
    return;
  }
  
  [sourceFiles addObject:path];
  
  // ready the input data
  NSString *data = [NSString stringWithContentsOfFile:path
                                             encoding:NSUTF8StringEncoding
                                                error:&error
                    ];
  
  // prepare some traversal vars
  NSMutableArray *arr = [[NSMutableArray alloc] init];
  NSString *gradientName = nil;
  NSString *lastName = nil;

  // a default alternative suffix
  NSString *altName = @"alt"; 
  NSMutableArray *prefix = NSMutableArray.array;

  int i = 0;
  NSArray *lines = data.lines;
  NSString *line = lines.first;
  
  // traverse those lines
  while (line) {
    NSString *nextLine = nil;
    // for parsing reasons we'll add a whitespace at the end of the line
    line = [line stringByAppendingString:@" "];
    // if the line contains a "# ", cut that
    if ([line contains:@"# "]) {
      line = [line substringBefore:@"#"];
    }

    line = line.trim;
    if (!line.isEmpty) {
      // the line is not empty
      // determine what we should do with that line
      
      if ([line hasPrefix:@"::"]) {
        // set prefix
        NSString *nextPre = line.shifted.shifted.trim;
        if (nextPre.isEmpty) {
          [prefix removeLastObject];
        } else {
          prefix.last = nextPre;
        }
        // empty a previously set name
        lastName = nil;
      } else if ([line hasPrefix:@":"]) {
        // command
        NSString *cmd = nil, *args = nil;
        list(&cmd, &args) = line.decapitate;
        
        if ([cmd isEqualToString:@"alternative"]) {
          [altName release];
          altName = args.retain;
        }
      } else if (gradientName) {
        // if we're within a gradient there should be only colors or the
        // stop delimiter }
        
        if ([line isEqualToString:@"}"]) {
          // create the gradient
          THGradient *gradient = [[THGradient alloc] initWithColors:arr];
          [self setGradient:gradient forName:gradientName];
          [gradient release];
          [gradientName release];
          gradientName = nil;
          [arr removeAllObjects];
        } else {
          if ([line hasSuffix:@"}"]) {
            // put a ; before the }
            line = $(@"%@;}", line.popped);
          }
          
          // add the current color
          NSString *colorDefinition;
          list(&colorDefinition, &nextLine) = [line splitAt:@";"];
          
          if (!colorDefinition.isEmpty) {
            [arr addObject:colorDefinition];
          }
        }
      } else {
        // should be "name definition"
        NSString *name = nil, *definition = nil;
        list(&name, &definition) = line.decapitate;
        
        if (lastName && [name hasPrefix:@"~"]) {
          // replace the tilde with the lastName
          name = [lastName stringByAppendingString:name.shifted.trim];
        }
        
        // store a name as lastName
        lastName = name;
        if ([lastName contains:@":"]) {
          // ensure the name to be without an alterative
          lastName = [lastName substringBefore:@":"];
        }
        
        name = [prefix.glue stringByAppendingString:name];
        
        if ([name hasSuffix:@":"]) {
          // this means "use the default alternative"
          name = [name stringByAppendingString:altName];
        }
        
        // Addition 1: check for types
        ValueType type = TypeColor;
        
        if ([name hasSuffix:@"Font"]) {
          type = TypeFont;
        } else if ([definition.lowercaseString hasPrefix:@"font "]) {
          type = TypeFont;
          definition = [definition substringAfter:@" "];
        }

        // Addition 2: check for reference names, starting with an @
        if ([definition hasPrefix:@"@"]) {
          if (type == TypeFont) {
            [fonts setObject:definition.shifted forKey:name];
          } else {
            [colors setObject:definition.shifted forKey:name];
          }
          definition = nil;
        }
        
        if (definition && !definition.isEmpty) {
          if (type == TypeFont) {
            NSFont *font = definition.fontValue;
            if (font) {
              [self setFont:font forName:name];
            }
          } else if ([definition hasPrefix:@"{"]) {
            gradientName = name.retain;
            nextLine = definition.shifted;
          } else {
            //NSLog(@"Parsing color %@ from %@", name, definition);
            NSColor *color = definition.colorValue;
            if (color) {
              [self setColor:color forName:name];
            } else {
              NSLog(@"Could not parse definition of color %@", definition);
            }
          }
        }
      }
    }
            
    if (!nextLine || nextLine.isEmpty) {
      i++;
      if (i < lines.count) {
        line = [lines objectAtIndex:i];
      } else {
        line = nil;
        break;
      }
    }
  }
  
  alternative = [altName retain];
  [altName release];
  [arr release];
}

-(void)loadResourceFile:(NSString *)name {
  if (!name) {
    @throw [NSException 
            exceptionWithName:@"ColorManagerNoFile"
            reason:@"No name provided" 
            userInfo:nil
            ];
    return;
  }
  NSString *path;
  if ([name hasPrefix:@"/"]) {
    path = name;
  } else {
    path = [[[NSBundle mainBundle] resourcePath] 
            stringByAppendingPathComponent:name];
  }
  
  [self loadFile:path];
}

-(void)loadDefaultColors {
  [self loadResourceFile:@"color.defaults"];
}

-(void)reload {
  BOOL alt = [self useAlternativeColoring];
  for (NSString *path in sourceFiles) {
    [self loadResourceFile:path];
  }
  self.useAlternativeColoring = alt;
  // just fire a coloring changed, just in case something might have changed
  [[NSNotificationCenter defaultCenter] 
   postNotificationName:@"ColoringChanged" object:self];
}

-(id)valueFromDictionary:(NSDictionary *)dict forKey:(NSString *)key {
  NSMutableArray *checked = NSMutableArray.array;
  NSString *hkey;
  id re = key;
  
  while ([re isKindOfClass:NSString.class]) {
    hkey = (NSString *)re;
    
    if ([checked containsObject:hkey]) {
      @throw [NSException 
              exceptionWithName:@"ColorManagerCircularReference"
              reason:$(@"Cannot resolve circular references: %@", 
                       [checked join]) 
              userInfo:nil
              ];
      return nil;
    }
    
    re = [dict objectForKey:hkey];

    if (useAlternativeColoring && alternative) {
      id alt = [dict objectForKey:$(@"%@:%@", hkey, alternative)];
      if (alt) {
        re = alt;
      }
    }
    
    [checked addObject:hkey];
  }
  
  return re;
}


//
// colors
// 
+(NSColor *)colorWithName:(NSString *)name {
  return [[self sharedManager] colorWithName:name];
}

-(NSColor *)colorWithName:(NSString *)name {
  return [self colorWithName:name fallbackColor:fallbackColor];
}

-(NSColor *)colorWithName:(NSString *)name fallbackColor:(NSColor *)fallback {
  id re = [self valueFromDictionary:colors forKey:name];
  
  if (re) {
    return re;
  }
  
  return fallback;
}

-(void)setColor:(NSColor *)color forName:(NSString *)name {
  if ([name contains:@":"]) {
    NSString *rawName = [name substringBefore:@":"];
    if (![colors valueForKey:rawName]) {
      [colors setObject:color forKey:rawName];
    }
  }
  [colors setObject:color forKey:name];
}

//
// gradients
//
+(NSGradient *)gradientWithName:(NSString *)name {
  return [[self sharedManager] gradientWithName:name];
}

-(NSGradient *)gradientWithName:(NSString *)name {
  return [self gradientWithName:name fallbackGradient:fallbackGradient];
}

-(NSGradient *)gradientWithName:(NSString *)name 
               fallbackGradient:(NSGradient *)fallback
{
  id re = [self valueFromDictionary:gradients forKey:name];
  
  if (re) {
    return re;
  }
  
  return fallback;
}

-(void)setGradient:(NSGradient *)gradient forName:(NSString *)name {
  if ([name contains:@":"]) {
    NSString *rawName = [name substringBefore:@":"];
    if (![gradients valueForKey:rawName]) {
      [gradients setObject:gradient forKey:rawName];
    }
  }
  [gradients setObject:gradient forKey:name];
}

+(NSFont *)fontWithName:(NSString *)name {
  return [[self sharedManager] fontWithName:name];
}

-(NSFont *)fontWithName:(NSString *)name {
  return [self fontWithName:name fallbackFont:fallbackFont];
}

-(NSFont *)fontWithName:(NSString *)name fallbackFont:(NSFont *)fallback {
  id re = [self valueFromDictionary:fonts forKey:name];
  
  if (re) {
    return re;
  }
  
  return fallback;
}

-(void)setFont:(NSFont *)font forName:(NSString *)name {
  if ([name contains:@":"]) {
    NSString *rawName = [name substringBefore:@":"];
    if (![fonts valueForKey:rawName]) {
      [fonts setObject:font forKey:rawName];
    }
  }
  [fonts setObject:font forKey:name];
}

@synthesize useAlternativeColoring;
-(void)setUseAlternativeColoring:(BOOL)value {
  [self willChangeValueForKey:@"alternativeColoring"];
  useAlternativeColoring = value;
  [self didChangeValueForKey:@"alternativeColoring"];
  [[NSUserDefaults standardUserDefaults] 
   setBool:value forKey:@"useAlternativeColoring"];
  [[NSNotificationCenter defaultCenter] 
   postNotificationName:@"ColoringChanged" object:self];
}

@synthesize alternative;
-(void)setAlternative:(NSString *)altName {
  if (altName == alternative) {
    return;
  }
  [self willChangeValueForKey:@"alternative"];
  [alternative release];
  alternative = altName.retain;
  [self didChangeValueForKey:@"alternative"];
  [[NSNotificationCenter defaultCenter] 
   postNotificationName:@"ColoringChanged" object:self];
}

@end

@implementation NSString (ColorManager)

-(NSColor *)managedColor {
  return [ColorManager colorWithName:self];
}

-(NSGradient *)managedGradient {
  return [ColorManager gradientWithName:self];
}

-(NSFont *)managedFont {
  return [ColorManager fontWithName:self];
}

@end

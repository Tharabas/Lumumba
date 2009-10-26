//
//  NSFont+TH.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 30.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSFont (TH)

+(NSFont *)fontWithDescription:(NSString *)description;
-(NSFont *)fontWithSize:(CGFloat)size;

@property (readonly) NSFont *bigger;
@property (readonly) NSFont *smaller;
@property (readonly) NSFont *bold;
@property (readonly) NSFont *italic;
@property (readonly) NSFont *expanded;
@property (readonly) NSFont *condensed;
@property (readonly) NSFont *monospaced;
@property (readonly) NSFont *vertical;
@property (readonly) NSFont *UIOptimized;

@end

@interface NSString (NSFont_TH)
-(NSFont *)fontValue;
@end
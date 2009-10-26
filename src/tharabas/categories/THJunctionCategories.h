//
//  THJunctionCategories.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 25.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSArray (THJunctionCategories)
- (NSString *)keys:(NSString *)keyPath joinedByString:(NSString *)separator;

- (NSString *)joinWithKey:(NSString *)keyPath;
- (NSString *)join;
- (NSString *)glue;
- (NSString *)colonize;
@end

@interface NSSet (THJunctionCategories)
- (NSString *)keys:(NSString *)keyPath joinedByString:(NSString *)separator;

- (NSString *)joinWithKey:(NSString *)keyPath;
- (NSString *)join;
- (NSString *)glue;
- (NSString *)colonize;
@end

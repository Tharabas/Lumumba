//
//  THJunctionCategories.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 25.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "THJunctionCategories.h"

@implementation NSArray (THJunctionCategories)

- (NSString *)keys:(NSString *)keyPath joinedByString:(NSString *)separator {
  NSMutableArray *re = [NSMutableArray arrayWithCapacity:[self count]];
  
  for (id o in self) {
    [re addObject:[o valueForKeyPath:keyPath]];
  }
  
  return [re componentsJoinedByString:separator];
}

- (NSString *)join {
	return [self componentsJoinedByString:@", "];
}

- (NSString *)joinWithKey:(NSString *)keyPath {
  return [self keys:keyPath joinedByString:@", "];
}

- (NSString *)glue {
	return [self componentsJoinedByString:@""];
}

- (NSString *)colonize {
	return [self componentsJoinedByString:@":"];
}

@end

@implementation NSSet (THJunctionCategories)

- (NSString *)keys:(NSString *)keyPath joinedByString:(NSString *)separator {
  NSMutableArray *re = [NSMutableArray arrayWithCapacity:[self count]];
  
  for (id o in self) {
    if (keyPath == nil) {
      [re addObject:o];
    } else {
      [re addObject:[o valueForKeyPath:keyPath]];
    }
  }
  
  return [re componentsJoinedByString:separator];
}

- (NSString *)join {
	return [self keys:nil joinedByString:@", "];
}

- (NSString *)joinWithKey:(NSString *)keyPath {
  return [self keys:keyPath joinedByString:@", "];
}

- (NSString *)colonize {
	return [self keys:nil joinedByString:@":"];
}

- (NSString *)glue {
	return [self keys:nil joinedByString:@""];
}

@end
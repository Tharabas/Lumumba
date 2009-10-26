//
//  NSData+TH.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 11.12.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "NSData+TH.h"


@implementation NSData (TH)

+(NSData *)dataArchivingRootObject:(id)object {
  return [NSKeyedArchiver archivedDataWithRootObject:object];
}

-(id)unarchive {
  return [NSKeyedUnarchiver unarchiveObjectWithData:self];
}

@end

@implementation NSObject (TH_DATA)

-(NSData *)archivedData {
  return [NSKeyedArchiver archivedDataWithRootObject:self];
}

@end


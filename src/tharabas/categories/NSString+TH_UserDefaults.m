//
//  NSString+TH_UserDefaults.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 04.08.11.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "NSString+TH_UserDefaults.h"


@implementation NSString (TH_UserDefaults)

#define UVAL(T,N) -(T) N##InDefaults { \
  return [[NSUserDefaults standardUserDefaults] N##ForKey:self]; \
}

UVAL(id, object)
UVAL(BOOL, bool)
UVAL(NSInteger, integer)
UVAL(double, double)
UVAL(NSString *, string)
UVAL(NSURL *, URL)
UVAL(NSArray *, array)

@end

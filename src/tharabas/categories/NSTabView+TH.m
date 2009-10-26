//
//  NSTabView+TH.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 06.01.10.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "NSTabView+TH.h"

@implementation NSTabView (TH)

+(NSSet *)keyPathsForValuesAffectingSelectedIndex {
  return [NSSet setWithObject:@"selectedTabViewItem"];
}
-(NSInteger)selectedIndex {
  NSTabViewItem *s = [self selectedTabViewItem];
  if (!s) {
    return -1;
  }
  
  NSInteger i = 0;
  for (NSTabViewItem *t in [self tabViewItems]) {
    if (t == s) {
      return i;
    }
    i++;
  }
  
  // should not happen
  return -1;
}

+(NSSet *)keyPathsForValuesAffectingFirstTabSelected {
  return [NSSet setWithObject:@"selectedTabViewItem"];
}
-(BOOL)isFirstTabSelected {
  return self.selectedIndex == 0;
}

+(NSSet *)keyPathsForValuesAffectingLastTabSelected {
  return [NSSet setWithObject:@"selectedTabViewItem"];
}
-(BOOL)isLastTabSelected {
  return self.selectedIndex == [[self tabViewItems] count] - 1;
}

@end

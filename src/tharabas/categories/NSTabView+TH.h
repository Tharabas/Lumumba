//
//  NSTabView+TH.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 06.01.10.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSTabView (TH)

@property (readonly) NSInteger selectedIndex;
@property (readonly) BOOL isFirstTabSelected;
@property (readonly) BOOL isLastTabSelected;

@end

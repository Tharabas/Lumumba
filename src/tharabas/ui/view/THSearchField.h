//
//  THSearchField.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 21.02.10.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface THSearchField : NSSearchField {
  NSUInteger lastModifiers;
  unsigned short lastKeyCode;
}

@property (readonly) NSUInteger lastModifiers;
@property (readonly) unsigned short lastKeyCode;

@end

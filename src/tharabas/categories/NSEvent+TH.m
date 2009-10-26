//
//  NSEvent+TH.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 02.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "NSEvent+TH.h"


@implementation NSEvent (TH)

-(NSPoint)locationOnScreen {
  NSPoint pt = self.locationInWindow;
  NSPoint delta = [[self window] frame].origin;
  pt.x -= delta.x;
  pt.y += delta.y;
  
  return pt;
}

-(NSPoint)pointInView:(NSView *)view {
  return [view convertPoint:[self locationInWindow] fromView:nil];
}
-(NSPoint)pointRelativeInView:(NSView *)view {
  NSPoint pt = [self pointInView:view];
  pt.x /= view.frame.size.width;
  pt.y /= view.frame.size.height;
  return pt;
}

// shiftKey
+(BOOL)shiftKey {
  return (self.modifierFlags & NSShiftKeyMask) != 0;
}

-(BOOL)shiftKey {
  return (self.modifierFlags & NSShiftKeyMask) != 0;
}

// altKey
+(BOOL)altKey {
  return (self.modifierFlags & NSAlternateKeyMask) != 0;
}

-(BOOL)altKey {
  return (self.modifierFlags & NSAlternateKeyMask) != 0;
}

// controlKey
+(BOOL)controlKey {
  return (self.modifierFlags & NSControlKeyMask) != 0;
}

-(BOOL)controlKey {
  return (self.modifierFlags & NSControlKeyMask) != 0;
}

// commandKey
+(BOOL)commandKey {
  return (self.modifierFlags & NSCommandKeyMask) != 0;
}

-(BOOL)commandKey {
  return (self.modifierFlags & NSCommandKeyMask) != 0;
}

// fnKey
+(BOOL)fnKey {
  return (self.modifierFlags & NSFunctionKeyMask) != 0;
}

-(BOOL)fnKey {
  return (self.modifierFlags & NSFunctionKeyMask) != 0;
}

@end

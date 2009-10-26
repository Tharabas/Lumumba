//
//  NSView+DOM.m
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 25.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "NSView+TH.h"
#import "THGeometricFunctions.h"

@implementation NSView (TH)

- (NSView *)firstSubview
{
  if ([self.subviews count] == 0) {
    return nil;
  }
  
  return (NSView *)[self.subviews objectAtIndex:0];
}

- (NSView *)lastSubview {
  if (self.subviews.count == 0) {
    return nil;
  }
  
  return (NSView *)[self.subviews objectAtIndex:self.subviews.count - 1];
}

- (void)setLastSubview:(NSView *)view {
  [self addSubview:view];
}

-(NSTrackingArea *)trackFullView {
  NSTrackingArea *area = [NSTrackingArea alloc];
  NSTrackingAreaOptions options = 
      NSTrackingMouseEnteredAndExited
    | NSTrackingMouseMoved
    | NSTrackingActiveInKeyWindow
    | NSTrackingInVisibleRect
  ;
  [area initWithRect:NSMakeRect(0, 0, 0, 0)
             options:options
               owner:self
            userInfo:nil];
  
  [self addTrackingArea:area];
  
  return area;
}

-(NSTrackingArea *)trackAreaWithRect:(NSRect)rect {
  return [self trackAreaWithRect:rect userInfo:nil];
}

-(NSTrackingArea *)trackAreaWithRect:(NSRect)rect 
                            userInfo:(NSDictionary *)context 
{
  NSTrackingArea *area = [NSTrackingArea alloc];
  NSTrackingAreaOptions options = NSTrackingMouseEnteredAndExited
    | NSTrackingMouseMoved
    | NSTrackingActiveInKeyWindow
  ;
  [area initWithRect:rect
             options:options
               owner:self
            userInfo:context];

  [self addTrackingArea:area];
  
  return area;
}

-(BOOL)requestFocus {
  return [[self window] makeFirstResponder:self];
}

-(NSPoint)center {
  return THCenterOfRect(self.bounds);
}

@end

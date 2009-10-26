//
//  THFlowWindow.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 04.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "THFlowWindow.h"

@interface THFlowWindow (Private)

-(void)_updateView;

@end


@implementation THFlowWindow

- (THFlowWindow *)initWithView:(NSView *)view
                    atPosition:(NSPoint)pt
                      inWindow:(NSWindow *)window
                 withAlignment:(NSPoint)align
{
  if (!view) {
    // a displayed view is required
    // so stop here if the view is nil
    return nil;
  }

  // to work with our content view, 
  // we should prepare a rect for that
  THRect *contentRect = [THRect rectOf:view];
  
  if ((self == [super initWithContentRect:contentRect.rect
                              styleMask:NSBorderlessWindowMask
                                backing:NSBackingStoreBuffered
                                  defer:NO])) 
  {
    _view = view;
    _window = window;
    position = pt;
    automaticAlignment = NO;
    alignment = align;
    
    // initialize our super window with some parameters
    super.backgroundColor = NSColor.clearColor;
    //self.movableByWindowBackground = NO;
    //self.excludeFromWindowsMenu = YES;
    //self.alphaValue = 1.0;
    //self.opaque = NO;
    //self.hasShadow = YES;
    //[self useOptimizedDrawing:YES];
  }
  
  // done here, return the FlowWindow
  return self;
}

-(THFlowWindow *)initWithView:(NSView *)view 
                   atPosition:(NSPoint)pt
{
  if ((self == [self initWithView:view 
                     atPosition:pt
                       inWindow:nil 
                  withAlignment:NSZeroPoint]))
  {
    automaticAlignment = YES;
  }
  
  return self;
}

-(THFlowWindow *)initWithView:(NSView *)view 
                   atPosition:(NSPoint)pt
                withAlignment:(NSPoint)align
{
  if ((self = [self initWithView:view 
                     atPosition:pt
                       inWindow:nil
                  withAlignment:align])) 
  {
    
  }
  
  return self;
}

@synthesize position, alignment, automaticAlignment;

@end

//
//  THFlowWindow.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 04.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface THFlowWindow : NSWindow {
  NSPoint position;
  NSPoint alignment;
  BOOL automaticAlignment;
  
  @private
  NSColor *backgroundColor;
  __weak NSView *_view;
  __weak NSWindow *_window;
}

@property (assign) NSPoint position;
@property (assign) NSPoint alignment;
@property (nonatomic, assign) BOOL automaticAlignment;

//
// most generic initializer
//
- (THFlowWindow *)initWithView:(NSView *)view
                    atPosition:(NSPoint)position
                      inWindow:(NSWindow *)window
                 withAlignment:(NSPoint)alignment;

// without parent window
- (THFlowWindow *)initWithView:(NSView *)view 
                    atPosition:(NSPoint)position 
                 withAlignment:(NSPoint)alignment;

// without alignment or window -> autoAlignment
- (THFlowWindow *)initWithView:(NSView *)view 
                    atPosition:(NSPoint)position;
@end

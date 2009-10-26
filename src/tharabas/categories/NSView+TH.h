//
//  NSView+DOM.h
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 25.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (TH) 

-(NSView *)firstSubview;
-(NSView *)lastSubview;
-(void)setLastSubview:(NSView *)view;

-(NSTrackingArea *)trackFullView;
-(NSTrackingArea *)trackAreaWithRect:(NSRect)rect;
-(NSTrackingArea *)trackAreaWithRect:(NSRect)rect 
                            userInfo:(NSDictionary *)context;

-(BOOL)requestFocus;

@property (readonly) NSPoint center;

@end
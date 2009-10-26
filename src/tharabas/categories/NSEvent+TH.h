//
//  NSEvent+TH.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 02.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSEvent (TH)

-(NSPoint)locationOnScreen;
-(NSPoint)pointInView:(NSView *)view;
-(NSPoint)pointRelativeInView:(NSView *)view;

+(BOOL)shiftKey;
@property (readonly) BOOL shiftKey;

+(BOOL)altKey;
@property (readonly) BOOL altKey;

+(BOOL)commandKey;
@property (readonly) BOOL commandKey;

+(BOOL)controlKey;
@property (readonly) BOOL controlKey;

+(BOOL)fnKey;
@property (readonly) BOOL fnKey;

@end

//
//  THGradient.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 28.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Lumumba/th_transition.h>

@interface THGradient : NSGradient {
  THTransitionBlock transition;
}

+(THGradient *)glossyGradientWithColor:(NSColor *)color;

@property (retain) THTransitionBlock transition;

@end

@interface NSColor (THGradient)

-(THGradient *)glossyGradient;

@end
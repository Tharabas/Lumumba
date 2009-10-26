//
//  ColorBlendCell.h
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 16.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Lumumba/NSColor+Conversion.h>

@interface ColorBlendCell : NSTextFieldCell {
	BOOL blend;
  BOOL blendSelected;
  BOOL horizontal;
  BOOL inverted;

	CGFloat colorGain;
	CGFloat shiftPoint;
  CGFloat gradientShift;
	
	NSColor *sourceColor;
	NSColor *targetColor;
}

@property (assign,getter=isBlending) BOOL blend;
@property (assign,getter=isBlendingSelected) BOOL blendSelected;
@property (assign,getter=isHorizontal) BOOL horizontal;
@property (assign,getter=isInverted) BOOL inverted;

@property (assign) CGFloat colorGain;
@property (assign) CGFloat shiftPoint;
@property (assign) CGFloat gradientShift;

@property (retain) NSColor *sourceColor;
@property (retain) NSColor *targetColor;

@end

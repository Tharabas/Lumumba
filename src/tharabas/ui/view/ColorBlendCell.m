//
//  ColorBlendCell.m
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 16.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "ColorBlendCell.h"
#import "NSColor+Conversion.h"
#import "THGradient.h"

@implementation ColorBlendCell

@synthesize blend, blendSelected, horizontal, inverted;
@synthesize colorGain, shiftPoint;
@synthesize sourceColor, targetColor, gradientShift;

- (void)_init 
{
  // init stuff
	blend = NO;
  blendSelected = YES;
  horizontal = YES;
  inverted = NO;
  
  // shifts
	shiftPoint = 0.0;
  gradientShift = 0.0;

  // colors
	colorGain = 1.0;
	sourceColor = nil;
	targetColor = [NSColor blueColor];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
    [self _init];
  }
	
	return self;
}

- (void)awakeFromNib {
	//[self _init];
}

- (void)dealloc {
  [sourceColor release];
  [targetColor release];
  
  [super dealloc];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	[super drawInteriorWithFrame:cellFrame inView:controlView];
	
	if (self->blend) {
    CGFloat posShift = cellFrame.size.width * fabs(self.shiftPoint);
    if (self.shiftPoint >= 1) {
      posShift = self.shiftPoint;
    }
    
    NSColor *alphaColor = self.sourceColor;
    NSColor *omegaColor = self.targetColor;
    if (alphaColor == nil) {
      alphaColor = [omegaColor colorWithAlphaComponent:0];
    }

    NSRect box = NSInsetRect(cellFrame, -2, -1);
    
    CGFloat *aStart, *bStart, *aSize, *bSize;
    if (horizontal) {
      aStart = &box.origin.x;
      bStart = &box.origin.y;
      aSize  = &box.size.width;
      bSize  = &box.size.height;
    } else {
      aStart = &box.origin.y;
      bStart = &box.origin.x;
      aSize  = &box.size.height;
      bSize  = &box.size.width;
    }
    
    *aSize -= posShift;
    if (!inverted) {
      *aStart += posShift;
    }

    NSCompositingOperation op = NSCompositeSourceOver;
    
    CGFloat gain = self.colorGain;
    if (gain == 0) {
      // single color, no blending
      [omegaColor set];
      NSRectFillUsingOperation(box, op);
    } else {
      //
      // gradient calculation
      //
      if (gain < 0) {
        gain = -1 / gain; 
      }
      
      THGradient *grad = [[THGradient alloc] initWithStartingColor:alphaColor
                                                       endingColor:omegaColor];

      grad.transition = ^(double location){
        return pow(location, gain);
      };
      
      CGFloat angle = (horizontal ? 0 : 90) + (inverted ? 180 : 0);
      [grad drawInRect:box angle:angle];
      [grad release];
    }

		[[self attributedStringValue] drawAtPoint: 
     NSMakePoint(cellFrame.origin.x + 2, cellFrame.origin.y)];
	}
}

@end

//
//  NSAffineTransform+TH.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 03.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSAffineTransform (TH)

-(NSAffineTransform *)blendedTransformTo:(NSAffineTransform *)otherTransform
                            atPercentage:(CGFloat)percentage;
-(CGAffineTransform)cgTransform;
-(NSRect)transformRect:(NSRect)rect;

-(void)translateBy:(NSPoint)pt;

@end

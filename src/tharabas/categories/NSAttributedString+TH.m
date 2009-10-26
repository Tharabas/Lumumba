//
//  NSAttributedString+TH.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 29.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "NSAttributedString+TH.h"
#import "NSColor+Conversion.h"
#import "NSAffineTransform+TH.h"
#import "THGeometricFunctions.h"

@implementation NSMutableAttributedString (TH)

-(void)replaceAttribute:(NSString *)name value:(id)value {
  if (!value) {
    return;
  }
  NSRange r = NSMakeRange(0, self.string.length);
  [self removeAttribute:name range:r];
  [self addAttribute:name value:value range:r];
}

-(NSFont *)font {
  return [self attribute:NSFontAttributeName atIndex:0 effectiveRange:nil];
}

-(void)setFont:(NSFont *)font {
  [self replaceAttribute:NSFontAttributeName value:font];
}

-(NSColor *)color {
  return [self attribute:NSForegroundColorAttributeName atIndex:0 effectiveRange:nil];
}

-(void)setColor:(NSColor *)color {
  [self replaceAttribute:NSForegroundColorAttributeName value:color];
}

-(NSColor *)backgroundColor {
  return [self attribute:NSBackgroundColorAttributeName atIndex:0 effectiveRange:nil];
}

-(void)setBackgroundColor:(NSColor *)color {
  [self replaceAttribute:NSBackgroundColorAttributeName value:color];
}

-(void)drawCenteredOnRect:(NSRect)rect {
  [self drawAtPoint:THHalfPoint ofRect:rect];
}

-(void)drawAtPoint:(NSPoint)rel ofRect:(NSRect)rect {
  THRect *outer = [[THRect alloc] initWithRect:rect];
  THRect *mine  = [[THRect alloc] initWithSize:self.size];
  
  [mine moveTo:[THPoint pointWithPoint:rel] ofRect:outer];
  [self drawAtPoint:mine.origin];
  
  [outer release];
  [mine release];
}

-(void)drawCenteredOnRect:(NSRect)rect rotatedBy:(CGFloat)degrees {
  [self drawAtPoint:THHalfPoint ofRect:rect rotatedBy:degrees];
}

-(void)drawAtPoint:(NSPoint)point rotatedBy:(CGFloat)degrees {
  [NSGraphicsContext saveGraphicsState];
  NSAffineTransform *m = NSAffineTransform.transform;
  
  [m translateXBy:point.x yBy:point.y];
  [m rotateByDegrees:degrees];
  [m translateXBy:-point.x yBy:-point.y];

  [m concat];
  [self drawAtPoint:point];
  [NSGraphicsContext restoreGraphicsState];
}

-(void)drawAtPoint:(NSPoint)point 
            ofRect:(NSRect)rect 
         rotatedBy:(CGFloat)angle
{
  [NSGraphicsContext saveGraphicsState];
  NSPoint center = THCenterOfRect(rect);
  NSAffineTransform *m = NSAffineTransform.transform;
  
  [m translateBy:center];
  [m rotateByDegrees:angle];
  [m translateBy:THNegatePoint(center)];
  
  [m concat];
  
  [m invert];
  rect = [m transformRect:rect];
  
  [self drawAtPoint:point ofRect:rect];
  [NSGraphicsContext restoreGraphicsState];
}

-(void)drawBadgeAtPoint:(NSPoint)point {
  [self drawBadgeAtPoint:point onColor:NSColor.grayColor.translucent];
}

-(void)drawBadgeAtPoint:(NSPoint)point onColor:(NSColor *)color {
  NSRect r = NSMakeRect(point.x, point.y, self.size.width, self.size.height);
  
  NSBezierPath *badge = [[NSBezierPath alloc] init];
  [badge appendBezierPathWithRoundedRect:NSInsetRect(r, -6, -1) 
                             xRadius:6 
                             yRadius:6];
  
  [color setFill];
  [badge fill];
  [self drawAtPoint:r.origin];

  [badge release];
}

-(void)drawBadgeCenteredOnRect:(NSRect)rect {
  [self drawBadgeCenteredOnRect:rect onColor:NSColor.grayColor.translucent];
}

-(void)drawBadgeCenteredOnRect:(NSRect)rect onColor:(NSColor *)color {
  THRect *outer = [[THRect alloc] initWithRect:rect];
  THRect *mine  = [[THRect alloc] initWithSize:self.size];
  
  [mine centerOn:outer];
  [self drawBadgeAtPoint:mine.origin onColor:color];
  
  [outer release];
  [mine release];
}

@end

@implementation NSString (NSAttributedString_TH)

-(NSMutableAttributedString *)attributedString {
  return [[[NSMutableAttributedString alloc] initWithString:self] autorelease];
}

@end



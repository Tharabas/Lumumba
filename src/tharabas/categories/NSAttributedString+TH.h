//
//  NSAttributedString+TH.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 29.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSMutableAttributedString (TH)

@property (retain) NSFont *font;
@property (retain) NSColor *color;
@property (retain) NSColor *backgroundColor;

-(void)drawCenteredOnRect:(NSRect)rect;
-(void)drawAtPoint:(NSPoint)point ofRect:(NSRect)rect;

-(void)drawCenteredOnRect:(NSRect)rect rotatedBy:(CGFloat)degrees;
-(void)drawAtPoint:(NSPoint)point rotatedBy:(CGFloat)degrees;
-(void)drawAtPoint:(NSPoint)point 
            ofRect:(NSRect)rect 
         rotatedBy:(CGFloat)degrees;

-(void)drawBadgeAtPoint:(NSPoint)point;
-(void)drawBadgeAtPoint:(NSPoint)point onColor:(NSColor *)color;

-(void)drawBadgeCenteredOnRect:(NSRect)rect;
-(void)drawBadgeCenteredOnRect:(NSRect)rect onColor:(NSColor *)color;

@end

@interface NSString (NSAttributedString_TH)

@property (readonly) NSMutableAttributedString *attributedString;

@end


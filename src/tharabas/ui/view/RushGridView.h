//
//  RushGridView.h
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 25.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>
#import <Lumumba/THGeometry.h>

@interface RushGridView : NSClipView {
  // Rushing
  THGrid *rusher;
  NSView *viewport;
  NSView *overlay;
  
  id previousResponder;
  
  BOOL overview;
  
  NSPoint parallels;
  // selectedIndex
  IBOutlet NSUInteger selectedIndex;
  
  // alignment (major order)
  NSUInteger order;
  
  // cells
  NSUInteger parallelCells;
}

@property (assign) IBOutlet BOOL overview;
@property (assign) NSUInteger order;
@property (assign) NSUInteger parallelCells;
@property (assign) NSUInteger selectedIndex;
@property (readonly) CAScrollLayer *scrollLayer;

-(void)showViewWithIndex:(NSUInteger)index;
-(void)alignWithStyle:(NSUInteger)style;
// short variants for those values
-(void)alignHorizontally;
-(void)alignVertically;
-(void)alignCompact;

-(void)addContentView:(NSView *)view;
-(void)addContentView:(NSView *)view 
              atIndex:(NSUInteger)index;
-(void)setIndexOfView:(NSView *)view 
              toValue:(NSUInteger)index;
-(void)addContentViews:(NSArray *)views;
-(void)addContentViews:(NSArray *)views 
               atIndex:(NSUInteger)index;

-(void)showFirst;
-(void)showLast;
-(void)showNext;
-(void)showPrevious;

-(IBAction)showFirst:(id)sender;
-(IBAction)showLast:(id)sender;
-(IBAction)showNext:(id)sender;
-(IBAction)showPrevious:(id)sender;

-(IBAction)toggleOverview:(id)sender;

@end

//
//  RushGridView.m
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 25.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "RushGridView.h"

@interface RushGridView (Private)
-(void)_init;
-(void)_initLayers;
-(void)updateSize;
-(void)realign;
-(void)realignWithAnimation:(BOOL)animation;
-(void)addContentView:(NSView *)view 
               atIndex:(NSUInteger)index 
        refreshingView:(BOOL)refreshing;
-(void)setIndexOfView:(NSView *)view 
               toValue:(NSUInteger)index 
        refreshingView:(BOOL)refreshing;
-(void)alignWithStyle:(NSUInteger)style 
        refreshingView:(BOOL)refreshing;
-(THSize *)cellSize;
-(CAScrollLayer *)scrollLayer;
-(THPoint *)fittingPointAtIndex:(NSUInteger)i;
@end

@implementation RushGridView

#pragma mark Initialization

-(void)_init
{
  rusher = [[THGrid alloc] init];
  
  viewport = nil;
  overlay = nil;
  
  overview = NO;
  order = 0;
  
  selectedIndex = 0;
  
  parallels = NSMakePoint(1, 1);
  
  [self _initLayers];
}

-(id)init 
{
  if ((self = [super init])) {
    [self _init];
  }

  return self;
}

-(void)_initLayers {
  //NSLog(@"InitLayers");
  
  CGFloat pace = 1.2;
  
  CAScrollLayer *sl = [CAScrollLayer layer];
  sl.speed = pace;
  
  self.wantsLayer = YES;
  self.layer = sl;
  
  // create a new viewport layer
  // it's maintained as a private property for easier access
  CALayer *l = [CALayer layer];
  viewport = [[NSView alloc] initWithFrame:self.frame];
  viewport.autoresizesSubviews = NO;
  viewport.wantsLayer = YES;
  viewport.layer = l;

  // overlay
  overlay = [[NSView alloc] initWithFrame:self.frame];
}

- (id)initWithFrame:(NSRect)frameRect
{
  if ((self = [super initWithFrame:frameRect])) {
    [self _init];
  }
  
  return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
  if ((self = [super initWithCoder:coder])) {
    [self _init];
  }
  
  return self;
}

/**
 * Not really init, but fits in here best
 */
- (void)dealloc {
  [rusher release];
  [viewport release];
  [overlay release];
  [super dealloc];
}

- (void)awakeFromNib
{
  // No matter what the nib might say
  self.wantsLayer = YES;
  viewport.wantsLayer = YES;
  
  // now remove all views that have been put directly onto
  // the layer in the IB by sequentially removing them from
  // the ScrollView and adding them to the viewport
  // ! the viewport must not be set right now
  // ! otherwise this loop would never stop or produce nonsense
  
  while (self.subviews.count > 0) {
    // keep looking for the top-left-most view
    NSView *nextView = nil;
    for (NSView *view in self.subviews) {
      if (nextView == nil) {
        nextView = view;
      } else {
        CGFloat dx = nextView.frame.origin.x - view.frame.origin.x;
        CGFloat dy = nextView.frame.origin.y - view.frame.origin.y;
        
        // this might be a subject of configuration somewhen in the future
        // right now 
        if (dy < 0 || (dy == 0 && dx > 0)) {
          nextView = view;
        }
      }
    }
    // use the private addContentView method to prevent refreshing the view
    [self addContentView:nextView atIndex:rusher.count refreshingView:NO];
  }

  // viewport ist done -> set it to be our document-view
  [self setDocumentView:viewport];
  
  // overlay is the event layer for the overview
  //[overlay setHidden:YES];
  //overlay.autoresizingMask = 63;
  [self addSubview:overlay positioned:NSWindowAbove relativeTo:viewport];
  
  // realign the whole view
  [self alignWithStyle:order refreshingView:NO];
  
  // and realign the whole stuff
  [self updateSize];
  [self realign];
}

/**
 * Will add a view to our clipped content
 */
- (void)addContentView:(NSView *)view
{
  [self addContentView:view atIndex:rusher.count];
}

/**
 * Will add a view to our clipped content with a given index
 */
- (void)addContentView:(NSView *)view atIndex:(NSUInteger)index
{
  [self addContentView:view atIndex:index refreshingView:YES];
}

/**
 * same as the previous one but this really is the controller
 * allowing us to prevent out view to be redrawn
 */
- (void)addContentView:(NSView *)view 
               atIndex:(NSUInteger)index 
        refreshingView:(BOOL)refreshing
{
  [rusher insertObject:view atIndex:MIN(index, rusher.count)];
  [viewport addSubview:view];
  
  if (refreshing) {
    [self updateSize];
    [self realign];
  }
}

-(void)addContentViews:(NSArray *)views {
  [self addContentViews:views atIndex:rusher.count];
}

-(void)addContentViews:(NSArray *)views atIndex:(NSUInteger)index {
  NSUInteger i = MIN(index, rusher.count);
  for (id o in views) {
    if ([o isKindOfClass:[NSView class]]) {
      [self addContentView:(NSView *)o atIndex:i refreshingView:NO];
      i++;
    }
  }

  [self updateSize];
  //[self realign];
}

/**
 * pushes a view around in our views array
 */
- (void)setIndexOfView:(NSView *)view 
               toValue:(NSUInteger)index
{
  [self setIndexOfView:view toValue:index refreshingView:YES];
}

- (void)setIndexOfView:(NSView *)view 
               toValue:(NSUInteger)index 
        refreshingView:(BOOL)refreshing
{
  if (refreshing) {
    [self realign];
  }
}

- (BOOL)drawsBackground {
  return NO;
}

-(CAScrollLayer *)scrollLayer {
  return (CAScrollLayer *)self.layer;
}

#pragma mark Properties

@synthesize order, parallelCells;

/**
 * This property 
 */
-(NSUInteger)selectedIndex {
  return selectedIndex;
}

-(void)setSelectedIndex:(NSUInteger)index
{
  self.overview = NO;

  NSUInteger i = MIN(rusher.count - 1, index);
  
  if (i == self->selectedIndex) {
    return;
  }
  
  //NSLog(@"Changed Index from %i to %i", self->selectedIndex, i);

  self->selectedIndex = i;

  [self realignWithAnimation:YES];
}

-(void)showViewWithIndex:(NSUInteger)index
{
  self.selectedIndex = index;
}

-(void)showFirst {
  self.selectedIndex = 0;
}

-(IBAction)showFirst:(id)sender {
  [self showFirst];
}

-(void)showLast {
  self.selectedIndex = rusher.count - 1;
}

-(IBAction)showLast:(id)sender {
  [self showLast];
}

-(void)showNext {
  self.selectedIndex = (self.selectedIndex + 1) % rusher.count;
}

-(IBAction)showNext:(id)sender {
  [self showNext];
}

-(void)showPrevious {
  self.selectedIndex = (self.selectedIndex + rusher.count - 1) % rusher.count;
}

-(IBAction)showPrevious:(id)sender {
  [self showPrevious];
}

-(void)alignWithStyle:(NSUInteger)style {
  [self alignWithStyle:style refreshingView:YES];
}

-(void)alignWithStyle:(NSUInteger)style 
       refreshingView:(BOOL)refreshing
{
  rusher.style = style;

  if (refreshing) {
    if (overview) {
      self->overview = NO;
      self.overview = YES;
    }
    //[self realignWithAnimation:self.overview];
    [self realign];
  }
}

-(void)alignHorizontally
{
  [self alignWithStyle:THGridStyleHorizontal refreshingView:YES];
}

-(void)alignVertically
{
  [self alignWithStyle:THGridStyleVertical refreshingView:YES];
}

-(void)alignCompact
{
  [self alignWithStyle:THGridStyleCompact refreshingView:YES];
}

#pragma mark Events

-(void)resizeWithOldSuperviewSize:(NSSize)oldSize {
  [super resizeWithOldSuperviewSize:oldSize];

  if (!NSEqualSizes(self.frame.size, oldSize)) {
    //NSLog(@"resizeSuperview");
    [self updateSize];
    [self realign];
  }
}

-(void)resizeSubviewsWithOldSize:(NSSize)oldSize {
  //[super resizeSubviewsWithOldSize:oldSize];
  
  if (!NSEqualSizes(self.frame.size, oldSize)) {
    //NSLog(@"resizeSubviews");
    [self updateSize];
    [self realign];
  }
}

-(void)mouseUp:(NSEvent *)event {
  if (overview) {
    THPoint *pt = [THPoint pointOf:event];
    [pt moveByNegative:viewport];
    [pt multiplyBy:[NSNumber numberWithFloat:rusher.max]];
    for (NSUInteger i = 0; i < rusher.count; i++) {
      NSView *view = [rusher objectAtIndex:i];
      if ([[THRect rectOf:view] contains:pt]) {
        self.selectedIndex = i;
      }
    }
  }
}

-(BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
  return self->overview;
}

-(BOOL)acceptsFirstResponder {
  return self->overview;
}

#pragma mark Drawing

-(void)updateSize {
  // determine the size of this view
  THSize *size = [THSize sizeOf:self];
  [overlay setFrameOrigin:NSMakePoint(0, 0)];
  [overlay setFrameSize:size.size];
  // and the size of any subview
  // usually (with parallels = {1,1}) it should be the same as size
  THSize *cellSize = [size copy];
  [cellSize divideByPoint:parallels];
  
  THSize *viewSize = [cellSize copy];
  [viewSize multipyBy:rusher.size];

  CGAffineTransform at = [viewport.layer affineTransform];
  [viewport setFrameSize:viewSize.size];

  [CATransaction begin];
  [CATransaction setValue:(id)kCFBooleanTrue
                   forKey:kCATransactionDisableActions];
  [viewport.layer setAffineTransform:at];
  [CATransaction commit];

  [viewSize release];
  [cellSize release];
}

-(THSize *)cellSize {
  // determine the size of this view
  THSize *size = [THSize sizeOf:self];
  // and the size of any subview
  // usually (with parallels = {1,1}) it should be the same as size
  return [[[size copy] autorelease] divideByPoint:parallels];
}

-(void)realign {
  [self realignWithAnimation:NO];
}

-(void)realignWithAnimation:(BOOL)animate
{
  if (rusher.count == 0) {
    return;
  }
  
  //NSLog(@"------{ realign: %@", animate ? @"YES" : @"NO");
  
  THSize *cellSize = self.cellSize;
  THPoint *ptScroll = [THPoint point];
 
  for (NSUInteger i = 0; i < rusher.count; i++) {
    NSView* view = [rusher objectAtIndex:i];
    THPoint *pt = [self fittingPointAtIndex:i];
    [pt multiplyBy:cellSize];
    
    NSRect vr = NSMakeRect(pt.x, pt.y, cellSize.width, cellSize.height);
    view.frame = vr;

    if (i == selectedIndex) {
      [ptScroll moveTo:pt];
    }
  }

  CAScrollLayer *sl = self.scrollLayer;
  [CATransaction begin];
  if (overview) {
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    [sl scrollToPoint:NSPointToCGPoint(viewport.frame.origin)];
  } else {
    [ptScroll moveBy:viewport];
    if (animate) {
      // with animation we've got to delay the scrolling
      CATransaction.completionBlock = ^{
        [self scrollToPoint:ptScroll.point];
      };
    } else {
      // without an animation directly move the scroll-point
      [self scrollToPoint:ptScroll.point];
      [CATransaction setValue:(id)kCFBooleanTrue
                       forKey:kCATransactionDisableActions];
    }
    //NSLog(@"Scrolling View to %@", ptScroll);
    [sl scrollToPoint:ptScroll.cgpoint];
  }
  
  [CATransaction commit];
}

-(void)updateScrollPosition {
  
}

-(IBAction)toggleOverview:(id)sender {
  if ([sender isKindOfClass:[NSButton class]]) {
    NSButton *button = (NSButton *)sender;
    self.overview = button.state == NSOnState;
  } else {
    self.overview = !self.overview;
  }
}

-(BOOL)overview {
  return overview;
}

-(void)setOverview:(BOOL)o {
  if (o == self->overview) {
    return;
  }
  
  self->overview = o;
  
  THPoint *ptScroll = [THPoint point];
  CALayer *l = viewport.layer;
  //CAScrollLayer *sl = self.scrollLayer;

  CGAffineTransform m;
  if (o) {
    previousResponder = [self.window firstResponder];
    [self.window makeFirstResponder:self];
    
    CGFloat max = rusher.max;
    m = CGAffineTransformMakeScale(1 / max, 1 / max);
  } else {
    if (previousResponder != nil) {
      [self.window makeFirstResponder:previousResponder];
      previousResponder = nil;
    }
    
    m = CGAffineTransformMakeScale(1.0, 1.0);
    [ptScroll moveTo:[self fittingPointAtIndex:selectedIndex]];
  }

  [ptScroll multiplyBy:self.cellSize];
  [ptScroll moveBy:viewport];
  
  //NSLog(@"From (%.f, %.f) to %@", sl.frame.origin.x, sl.frame.origin.y, ptScroll);

  [self.scrollLayer scrollToPoint:ptScroll.cgpoint];

  [CATransaction begin];
  l.affineTransform = m;

  if (!o) {
    CATransaction.completionBlock = ^{
      //NSLog(@"overview finished at %@", ptScroll);
      //[self scrollToPoint:ptScroll.point];
      [self updateScrollPosition];
    };
  }
  [CATransaction commit];
}

-(THPoint *)fittingPointAtIndex:(NSUInteger)i {
  THPoint *pt = [rusher pointAtIndex:i];
  pt.y = rusher.size.height - pt.y - 1;
  CGFloat wth = rusher.size.wthRatio;
  if (overview && wth != 1) {
    if (wth < 1) {
      pt.x += ((1.0 / wth) / 2.0) - 0.5;
    } else {
      pt.y += (wth / 2.0) - 0.5;
    }
  }
  return pt;
}

@end

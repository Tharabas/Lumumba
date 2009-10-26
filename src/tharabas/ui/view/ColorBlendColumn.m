//
//  ColorBlendColumn.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 24.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "ColorBlendColumn.h"

@protocol ColorBlendCellUpdater
-(void)updateCell:(id)cell forColumn:(NSTableColumn *)column atRow:(NSInteger)row;
@end

@implementation ColorBlendColumn

-(id)init {
  if ((self = [super init])) {
    self->cellDelegate = nil;
  }
  
  return self;
}

-(id)dataCellForRow:(NSInteger)row {
  id cell = [super dataCellForRow:row];
  
  SEL method = @selector(updateCell:forColumn:atRow:);
  if (cellDelegate != nil && [cellDelegate respondsToSelector:method]) {
    id<ColorBlendCellUpdater> d = (id<ColorBlendCellUpdater>)cellDelegate;
    [d updateCell:cell forColumn:self atRow:row];
  }
  
  return cell;
}

@end

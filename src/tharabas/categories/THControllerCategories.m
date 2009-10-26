//
//  THControllerCategories.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 11.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "THControllerCategories.h"
#import "NSString+TH.h"
#import "NSArray+TH.h"
#import "NSMutableArray+TH.h"

@implementation NSArray (THControllerCategories)

+(NSArray *)arrayForSorting:(NSString *)sortDescription {
  NSMutableArray *re = NSMutableArray.array;
  
  for (NSString *element in [[sortDescription splitByComma] trimmedStrings]) {
    BOOL ascending = YES;
    
    if ([[element uppercaseString] hasSuffix:@" ASC"]) {
      element = [element substringToIndex:element.length - 4];
    } else if ([[element uppercaseString] hasSuffix:@" DESC"]) {
      element = [element substringToIndex:element.length - 5];
      ascending = NO;
    }
    
    NSString *key = element.trim;
    
    if (key && !key.isEmpty) {
      //NSLog(@"Adding %@, %@", key, ascending ? @"ASC" : @"DESC");
      [re addObject:[NSSortDescriptor sortDescriptorWithKey:key 
                                                  ascending:ascending]];
    }
  }
  
  return re;
}

-(NSArray *)sortedBy:(NSString *)sd {
  return [self sortedArrayUsingDescriptors:[NSArray arrayForSorting:sd]];
}

-(NSIndexPath *)indexPath {
  NSIndexPath *re = nil;
  for (id o in self) {
    if ([o isKindOfClass:NSNumber.class]) {
      if (re) {
        re = [re indexPathByAddingIndex:[o intValue]];
      } else {
        re = [NSIndexPath indexPathWithIndex:[o intValue]];
      }
    }
  }
  
  return re;
}

@end


@implementation NSArrayController (THControllerCategories)
- (void)setSorting:(NSString *)v {
  [self setSortDescriptors:[NSArray arrayForSorting:v]];
}
- (NSString *)sorting {
  return [[self sortDescriptors] joinWithKey:@"key"];
}
-(NSPredicate *)filterWithFormat {
  return self.filterPredicate;
}
-(void)setFilterWithFormat:(NSString *)format,... {
  va_list args;
  va_start(args, format);
  [self setFilterPredicate:[NSPredicate 
                            predicateWithFormat:format 
                            arguments:args]];
  va_end(args);
}

@end

@implementation NSTreeController (THControllerCategories)
- (void)setSorting:(NSString *)v {
  [self setSortDescriptors:[NSArray arrayForSorting:v]];
}
- (NSString *)sorting {
  return [[self sortDescriptors] joinWithKey:@"key"];
}
-(NSPredicate *)fetchWithFormat {
  return self.fetchPredicate;
}
-(void)setFetchWithFormat:(NSString *)format,... {
  va_list args;
  va_start(args, format);
  [self setFetchPredicate:[NSPredicate 
                           predicateWithFormat:format 
                           arguments:args]];
  va_end(args);
}

-(id)objectAtPath:(NSIndexPath *)path {
  id re = self.arrangedObjects;
  
  if (!path || !path.length) {
    return re;
  }

  for (int i = 0; i < path.length; i++) {
    NSUInteger index = [path indexAtPosition:i];
    re = [[re children] objectAtIndex:index];
  }
  
  return re;
}

-(NSTreeNode *)nodeAtPath:(NSIndexPath *)path {
  if (!path) {
    return nil; 
  }
  return [self objectAtPath:path];
}

-(NSTreeNode *)selectedAncestorOf:(NSTreeNode *)node {
  for (id ancestor in node.lineage.reverseObjectEnumerator) {
    if ([[self selectedNodes] containsObject:ancestor]) {
      return ancestor;
    }
  }
  
  return nil;
}

-(BOOL)isPathSelected:(NSIndexPath *)path {
  return [[self selectionIndexPaths] containsObject:path];
}

-(void)setSelectionIndexPath:(NSIndexPath *)path 
                     toState:(BOOL)selected 
{
  if ([self isPathSelected:path] == selected) {
    return;
  }
  
  NSArray *newSelection;
  if (selected) {
    newSelection = [[self selectionIndexPaths] arrayByAddingObject:path];
  } else {
    newSelection = [[self selectionIndexPaths] arrayWithoutObject:path];
  }
  
  [self setSelectionIndexPaths:newSelection];
}

-(void)toggleSelectionIndexPath:(NSIndexPath *)path {
  [self setSelectionIndexPath:path toState:![self isPathSelected:path]];
}

-(void)addSelectionIndexDroppingChildren:(NSIndexPath *)path {
  if (!path) {
    return;
  }
  
  NSMutableArray *newSelection = self.selectionIndexPaths.mutableCopy;
  [newSelection removeObjectsInArray:[self selectedPathsBelowPath:path]];
  if (![newSelection containsObject:path]) {
    [newSelection addObject:path];
  }
  [self setSelectionIndexPaths:newSelection];
  
  [newSelection release];
}
                            
-(NSArray *)selectedPathsBelowPath:(NSIndexPath *)path {
  NSMutableArray *re = NSMutableArray.array;
  
  for (NSIndexPath *p in self.selectionIndexPaths) {
    if ([p isDescendantOf:path]) {
      re.last = p;
    }
  }
  
  return re;
}

-(NSArray *)selectedNodesBelowNode:(NSTreeNode *)node {
  NSMutableArray *re = NSMutableArray.array;
  
  for (NSTreeNode *compareNode in self.selectedNodes) {
    if ([node isAncestorOfNode:compareNode]) {
      re.last = compareNode;
    }
  }
  
  return re;
}



@end

//
// NSIndexPath
//

@implementation NSIndexPath (THControllerCategories)

-(NSIndexPath *)subpathWithRange:(NSRange)range {
  NSIndexPath *re = nil;
  
  NSUInteger min = range.location;
  NSUInteger max = MIN(range.location + range.length - 1, self.length - 1);
  
  for (int i = min; i <= max; i++) {
    NSUInteger index = [self indexAtPosition:i];
    if (re) {
      re = [re indexPathByAddingIndex:index];
    } else {
      re = [NSIndexPath indexPathWithIndex:index];
    }
  }
  
//  NSLog(@"Subpath of %@ in range [%u-%u] = %@",
//        self.path, min, max, re.path
//        );
  
  return re;
}

-(NSIndexPath *)subpathToIndex:(NSUInteger)index {
  return [self subpathWithRange:NSMakeRange(0, index + 1)];
}

-(NSIndexPath *)subpathFromIndex:(NSUInteger)index {
  return [self subpathWithRange:NSMakeRange(index, self.length - index)];
}

-(NSIndexPath *)mostCommonPathWithPath:(NSIndexPath *)path {
  if (!path) {
    return nil;
  }
  if (path == self) {
    return path;
  }
  
  int level = 0;
  int max = MIN(self.length, path.length);
  while (level < max) {
    NSUInteger si = [self indexAtPosition:level];
    NSUInteger ci = [path indexAtPosition:level];
    if (si != ci) {
//      NSLog(@"Break of equality at %u: first is %u but second is %u",
//            level, si, ci);
      break;
    }
    level++;
  }
  
  if (level) {
    return [self subpathToIndex:level - 1];
  }
  
  return nil;
}

-(BOOL)isAncestorOf:(NSIndexPath *)path {
  return [path isDescendantOf:self];
}

-(BOOL)isDescendantOf:(NSIndexPath *)path {
  if (!path || path.length >= self.length) {
    return NO;
  }
  return [self subpathToIndex:path.length - 1] == path;
}

-(NSString *)path {
  NSMutableString *re = NSMutableString.string;
  
  [re appendFormat:@"%i", [self indexAtPosition:0]];
  for (int i = 1; i < self.length; i++) {
    [re appendFormat:@".%i", [self indexAtPosition:i]];
  }
  
  return re;
}

@end

//
// NSTreeNode
//

@implementation NSTreeNode (THControllerCategories)

-(NSTreeNode *)mostCommonNodeWithNode:(id)node {
  if ([node isKindOfClass:NSTreeNode.class]) {
    return nil;
  }
  NSIndexPath *common = 
    [self.indexPath mostCommonPathWithPath:[node indexPath]];

  if (common) {
    NSTreeNode *re = self;
    for (int level = self.indexPath.length - common.length; level > 0; level--) {
      re = re.parentNode;
    }
    return re;
  }
  
  return nil;
}

-(BOOL)isAncestorOfNode:(NSTreeNode *)node {
  return [self isDescendantOfNode:node];
}

-(BOOL)isDescendantOfNode:(NSTreeNode *)node {
  NSTreeNode *here = self;
  
  while ([here parentNode]) {
    if (here == node) {
      return YES;
    }
    here = [here parentNode];
  }
  
  return NO;
}

-(NSArray *)lineage {
  NSMutableArray *re = NSMutableArray.array;
  
  id here = self;
  
  while (here) {
    re.last = here;
    here = [here parentNode];
  }
  [re reverse];
  
  return re;
}

-(NSUInteger)depth {
  NSUInteger re = 0;
  id here = self;
  while (here) {
    here = [here parentNode];
    re++;
  }
  
  return re;
}

-(NSTreeNode *)ancestorAtDepth:(NSUInteger)depth {
  NSArray *lineage = [self lineage];
  if (depth >= lineage.count) {
    return self;
  }
  
  return [lineage objectAtIndex:depth];
}

@end


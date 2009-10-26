//
//  THControllerCategories.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 11.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//
// NSArray
//

@interface NSArray (THControllerCategories)
+(NSArray *)arrayForSorting:(NSString *)sortDescription;
-(NSArray *)sortedBy:(NSString *)sortDescription;

/**
 * Will return an NSIndexPath containing all NSNumber intValues
 * that are part of this array
 * a length of 0 will return nil
 */
-(NSIndexPath *)indexPath;
@end

//
// NSArrayController
//

@interface NSArrayController (THControllerCategories)
@property (nonatomic, assign) NSString *sorting;
// this is actually a fake and will simply return self.filterPredicate
-(NSPredicate *)filterWithFormat;
-(void)setFilterWithFormat:(NSString *)format,...;
@end

//
// NSTreeController
//

@interface NSTreeController (THControllerCategories)
@property (nonatomic, assign) NSString *sorting;
// this is actually a fake and will simply return self.filterPredicate
-(NSPredicate *)fetchWithFormat;
-(void)setFetchWithFormat:(NSString *)format,...;

-(id)objectAtPath:(NSIndexPath *)path;
-(NSTreeNode *)nodeAtPath:(NSIndexPath *)path;

-(NSTreeNode *)selectedAncestorOf:(NSTreeNode *)node;

-(BOOL)isPathSelected:(NSIndexPath *)path;
-(void)setSelectionIndexPath:(NSIndexPath *)path toState:(BOOL)selected;
-(void)toggleSelectionIndexPath:(NSIndexPath *)path;
-(void)addSelectionIndexDroppingChildren:(NSIndexPath *)path;

-(NSArray *)selectedNodesBelowNode:(NSTreeNode *)node;
-(NSArray *)selectedPathsBelowPath:(NSIndexPath *)path;

@end

//
// NSIndexPath
//

@interface NSIndexPath (THControllerCategories)

-(NSIndexPath *)subpathWithRange:(NSRange)range;
-(NSIndexPath *)subpathToIndex:(NSUInteger)index;
-(NSIndexPath *)subpathFromIndex:(NSUInteger)index;

-(NSIndexPath *)mostCommonPathWithPath:(NSIndexPath *)path;

-(BOOL)isAncestorOf:(NSIndexPath *)path;
-(BOOL)isDescendantOf:(NSIndexPath *)path;

-(NSString *)path;

@end

//
// NSTreeNode
//

@interface NSTreeNode (THControllerCategories)

-(NSTreeNode *)mostCommonNodeWithNode:(id)node;
-(BOOL)isAncestorOfNode:(NSTreeNode *)node;
-(BOOL)isDescendantOfNode:(NSTreeNode *)node;
-(NSArray *)lineage;
-(NSUInteger)depth;
-(NSTreeNode *)ancestorAtDepth:(NSUInteger)depth;

@end

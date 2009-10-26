//
//  THQueue.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 26.01.10.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define THSimpleBlock dispatch_block_t

@interface THQueue : NSObject {
  dispatch_queue_t queue;
  dispatch_group_t group;
}

-(id)initWithName:(NSString *)name;
-(id)initWithName:(NSString *)name attributes:(dispatch_queue_attr_t)attr;

+(void)sync:(THSimpleBlock)block;
-(void)sync:(THSimpleBlock)block;

+(void)async:(THSimpleBlock)block;
-(void)async:(THSimpleBlock)block;

+(void)delay:(THSimpleBlock)block seconds:(NSTimeInterval)seconds;
-(void)delay:(THSimpleBlock)block seconds:(NSTimeInterval)seconds;

@end

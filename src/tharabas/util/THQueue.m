//
//  THQueue.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 26.01.10.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "THQueue.h"

#define GLOBAL_Q dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface THQueue (Private)

+(NSString *)generateQueueName;

@end


@implementation THQueue

-(id)init {
  return [self initWithName:[THQueue generateQueueName]];
}

-(id)initWithName:(NSString *)name {
  return [self initWithName:name attributes:0];
}

-(id)initWithName:(NSString *)name attributes:(dispatch_queue_attr_t)attr {
  if ((self = super.init)) {
    queue = dispatch_queue_create([name UTF8String], attr);
  }
  
  return self;
}

-(void)dealloc {
  [super dealloc];
}

+(NSString *)generateQueueName {
  static uint64_t qCounter = 0;
  return [NSString stringWithFormat:@"de.tharabas.THQueue.q%lu", qCounter];
}

+(void)sync:(THSimpleBlock)block {
  dispatch_sync(GLOBAL_Q, block);
}

-(void)sync:(THSimpleBlock)block {
  dispatch_sync(queue, block);
}

+(void)async:(THSimpleBlock)block {
  dispatch_async(GLOBAL_Q, block);
}

-(void)async:(THSimpleBlock)block {
  dispatch_async(queue, block);
}

+(void)delay:(THSimpleBlock)block seconds:(NSTimeInterval)seconds {
  dispatch_after(seconds * NSEC_PER_SEC, GLOBAL_Q, block);
}

-(void)delay:(THSimpleBlock)block seconds:(NSTimeInterval)seconds {
  dispatch_after(seconds * NSEC_PER_SEC, queue, block);
}

@end

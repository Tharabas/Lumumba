//
//  NSObject+ezKVC.m
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 30.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "NSObject+TH.h"

@implementation NSObject (TH)

-(void)setIntValue:(NSInteger)i forKey:(NSString *)key {
  [self setValue:[NSNumber numberWithInt:i] forKey:key];
}

-(void)setIntValue:(NSInteger)i forKeyPath:(NSString *)keyPath {
  [self setValue:[NSNumber numberWithInt:i] forKeyPath:keyPath];
}

-(void)setFloatValue:(CGFloat)f forKey:(NSString *)key {
  [self setValue:[NSNumber numberWithFloat:f] forKey:key];
}

-(void)setFloatValue:(CGFloat)f forKeyPath:(NSString *)keyPath {
  [self setValue:[NSNumber numberWithFloat:f] forKeyPath:keyPath];
}

-(BOOL)isEqualToAnyOf:(id<NSFastEnumeration>)enumerable {
  for (id o in enumerable) {
    if ([self isEqual:o]) {
      return YES;
    }
  }
  
  return NO;
}

-(void)fire:(NSString *)notificationName {
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:notificationName object:self];
}

-(void)fire:(NSString *)notificationName userInfo:(NSDictionary *)context {
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:notificationName object:self userInfo:context];
}

-(id)observeName:(NSString *)notificationName 
      usingBlock:(void (^)(NSNotification *))block
{
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  return [nc addObserverForName:notificationName
                         object:self
                          queue:nil
                     usingBlock:block];
}

-(void)observeObject:(NSObject *)object
             forName:(NSString *)notificationName
             calling:(SEL)selector
{
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self 
         selector:selector 
             name:notificationName
           object:object];
}

-(void)stopObserving:(NSObject *)object forName:(NSString *)notificationName {
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self name:notificationName object:object];
}

-(void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)seconds {
  [self performSelector:aSelector withObject:nil afterDelay:seconds];
}

-(void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
  [self addObserver:observer
         forKeyPath:keyPath
            options:0
            context:nil
   ];
}

-(void)addObserver:(NSObject *)observer 
       forKeyPaths:(id<NSFastEnumeration>)keyPaths
{
  for (NSString *keyPath in keyPaths) {
    [self addObserver:observer forKeyPath:keyPath];
  }
}

-(void)removeObserver:(NSObject *)observer 
          forKeyPaths:(id<NSFastEnumeration>)keyPaths
{
  for (NSString *keyPath in keyPaths) {
    [self removeObserver:observer forKeyPath:keyPath];
  }
}

-(void)willChangeValueForKeys:(id<NSFastEnumeration>)keys {
  for (id key in keys) {
    [self willChangeValueForKey:key];
  }
}

-(void)didChangeValueForKeys:(id<NSFastEnumeration>)keys {
  for (id key in keys) {
    [self didChangeValueForKey:key];
  }
}

@end

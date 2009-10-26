//
//  NSObject+TH.h
//  Lumumba Framework
//
//  Created by Benjamin Schüttler on 30.09.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSObject (TH)

-(void)setIntValue:(NSInteger)i forKey:(NSString *)key;
-(void)setIntValue:(NSInteger)i forKeyPath:(NSString *)keyPath;

-(void)setFloatValue:(CGFloat)f forKey:(NSString *)key;
-(void)setFloatValue:(CGFloat)f forKeyPath:(NSString *)keyPath;

-(BOOL)isEqualToAnyOf:(id<NSFastEnumeration>)enumerable;

-(void)fire:(NSString *)notificationName;
-(void)fire:(NSString *)notificationName userInfo:(NSDictionary *)userInfo;

-(id)observeName:(NSString *)notificationName 
      usingBlock:(void (^)(NSNotification *))block;

-(void)observeObject:(NSObject *)object
             forName:(NSString *)notificationName
             calling:(SEL)selector;

-(void)stopObserving:(NSObject *)object forName:(NSString *)notificationName;

-(void)performSelector:(SEL)aSelector afterDelay:(NSTimeInterval)seconds;
-(void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
-(void)addObserver:(NSObject *)observer 
       forKeyPaths:(id<NSFastEnumeration>)keyPaths;
-(void)removeObserver:(NSObject *)observer 
          forKeyPaths:(id<NSFastEnumeration>)keyPaths;

-(void)willChangeValueForKeys:(id<NSFastEnumeration>)keys;
-(void)didChangeValueForKeys:(id<NSFastEnumeration>)keys;

@end

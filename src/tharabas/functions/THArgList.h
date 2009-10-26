//
//  THArgList.h
//  Lumumba - Framework
//
//  Created by Benjamin Schüttler on 08.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

//
// This nasty little bit of code augments the objectiv-c syntax to support
// the php style list(...) construction
// 
// The THArgList class itself isn't that interesting,
// but together with the macro list(...) it can be used to 'fill' id objects
// with values from an array
//
// example:
//
// NSString *subject, *predicate, *object;
// list(&subject, &predicate, &object) = 
//   [@"Steve likes apples" componentsSeperatedByString:@" "];
// 
// note that this will currently not affect their retainCount at all
// 
// when the array is too short the to-be-filled values will be nil,
// even when they've been set before!
// 
// list(&one, &two, &three, &four, &five) = 
//   [@"Steve likes apples" componentsSeperatedByString:@" "];
//
// -> one   = @"Steve"
//    two   = @"likes"
//    three = @"apples"
//    four  = nil
//    five  = nil

#import <Cocoa/Cocoa.h>

#define list(...) [THArgList listWithReferences:__VA_ARGS__,nil].arrayValues

@interface THArgList : NSObject {
  id** arguments;
  NSUInteger count;
}

+(THArgList *)listWithReferences:(id*)ref,... NS_REQUIRES_NIL_TERMINATION;
-(id)initWithReferences:(id*)ref,... NS_REQUIRES_NIL_TERMINATION;

-(NSArray *)arrayValues;
-(void)setArrayValues:(NSArray *)values;

@end

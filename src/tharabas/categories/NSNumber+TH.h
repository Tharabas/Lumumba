//
//  NSNumber+TH.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 11.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSNumber(TH)

+(NSNumber *)zero;
+(NSNumber *)one;
+(NSNumber *)two;

-(NSNumber *)abs;
-(NSNumber *)negate;
-(NSNumber *)transpose;

-(NSArray *)times:(id (^)(void))block;

-(NSArray *)to:(NSNumber *)to;
-(NSArray *)to:(NSNumber *)to by:(NSNumber *)by;

@end

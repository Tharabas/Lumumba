//
//  NSString+TH_UserDefaults.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 04.08.11.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (TH_UserDefaults)

@property (readonly) NSString *stringInDefaults;
@property (readonly) BOOL boolInDefaults;
@property (readonly) NSInteger integerInDefaults;
@property (readonly) double doubleInDefaults;
@property (readonly) NSURL *URLInDefaults;
@property (readonly) NSArray *arrayInDefaults;
@property (readonly) id objectInDefaults;

@end

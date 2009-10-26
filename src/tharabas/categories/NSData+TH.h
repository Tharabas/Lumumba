//
//  NSData+TH.h
//  Lumumba
//
//  Created by Benjamin Schüttler on 11.12.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSData (TH)

+(NSData *)dataArchivingRootObject:(id)object;
-(id)unarchive;

@end

@interface NSObject (TH_DATA)

-(NSData *)archivedData;

@end


//
//  THDateRange.h
//  iQ
//
//  Created by Benjamin Schüttler on 31.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef enum _DateRangeType {
  DateRangeDay = 0,
  DateRangeWeek,
  DateRangeMonth,
  DateRangeQuarter,
  DateRangeYear,
  // rather seldomly used ones
  DateRangeDecade,
  DateRangeCentury,
  DateRangeMillenium,
  DateRangeAeon
} DateRangeType;

@interface THDateRange : NSObject {
  NSDate *start;
  NSDate *end;
}

+(THDateRange *)range;
+(THDateRange *)rangeFromDate:(NSDate *)start 
                 withDuration:(NSTimeInterval)duration;
+(THDateRange *)rangeFromDate:(NSDate *)start 
                       toDate:(NSDate *)end;
+(THDateRange *)rangeFromRanges:(NSArray *)ranges;

-(id)initWithDate:(NSDate *)start end:(NSDate *)end;
-(id)initWithDate:(NSDate *)start duration:(NSTimeInterval)duration;

@property (retain) NSDate *start;
@property (retain) NSDate *end;

@property (readonly) NSTimeInterval duration;

@property (readonly) BOOL closed;
@property (readonly) NSUInteger days;

-(void)setStart:(NSDate *)start end:(NSDate *)end;

-(void)moveByTimeInterval:(NSTimeInterval)seconds;
-(void)moveByDays:(NSTimeInterval)days;
-(void)moveByMonths:(NSTimeInterval)months;

@property (readonly) NSString *info;

-(CGFloat)coverageInRange:(THDateRange *)other;

/*
 * The comparison may be either an NSDate or a THDateRange
 */
-(BOOL)contains:(id)date;

/**
 * Will return 
 * - NSOrderedAscending   when the date lies before the range
 * - NSOrderedDescending  when the date lies after the range
 * - NSOrderedSame        when the range contains the date
 */
-(NSComparisonResult)compareWithDate:(NSDate *)date;

-(BOOL)containsDate:(NSDate *)date;
-(BOOL)containsAnyDate:(NSSet *)dates;
-(BOOL)containsRange:(THDateRange *)range;
-(BOOL)intersectsWithRange:(THDateRange *)range;

-(THDateRange *)intersectWithRange:(THDateRange *)range;
-(THDateRange *)combineWithRange:(THDateRange *)range;

-(THDateRange *)previousRangeOfType:(DateRangeType)type;
-(THDateRange *)nextRangeOfType:(DateRangeType)type;

@end

@interface NSDate (THDateRange)

@property (readonly) THDateRange *dayRange;
@property (readonly) THDateRange *weekRange;
@property (readonly) THDateRange *monthRange;
@property (readonly) THDateRange *quarterRange;
@property (readonly) THDateRange *yearRange;

-(THDateRange *)rangeOfType:(DateRangeType)type;
-(THDateRange *)nextRangeOfType:(DateRangeType)type;
-(THDateRange *)previousRangeOfType:(DateRangeType)type;

@end


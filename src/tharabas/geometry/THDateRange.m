//
//  THDateRange.m
//  iQ
//
//  Created by Benjamin Schüttler on 31.10.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "THDateRange.h"
#import "NSDate+TH.h"
#import "THSugar.h"

@implementation THDateRange

+(THDateRange *)range {
  return [[[self alloc] init] autorelease];
}
+(THDateRange *)rangeFromDate:(NSDate *)dv toDate:(NSDate *)ev {
  return [[[self alloc] initWithDate:dv end:ev] autorelease];
}
+(THDateRange *)rangeFromDate:(NSDate *)dv withDuration:(NSTimeInterval)ti {
  return [[[self alloc] initWithDate:dv duration:ti] autorelease];
}
+(THDateRange *)rangeFromRanges:(NSArray *)ranges {
  NSDate *startDate = nil;
  NSDate *endDate   = nil;
  
  for (THDateRange *r in ranges) {
    if ([r isKindOfClass:THDateRange.class]) {
      if (!startDate || [startDate isAfter:r.start]) {
        startDate = r.start;
      }
      if (!endDate || [endDate isBefore:r.end]) {
        endDate = r.end;
      }
    }
  }

  return [self rangeFromDate:startDate toDate:endDate];
}

-(id)init {
  if ((self = super.init)) {
    start = nil;
    end = nil;
  }
  
  return self;
}

-(id)initWithDate:(NSDate *)startDate end:(NSDate *)endDate {
  if ((self = self.init)) {
    if ([startDate isAfter:endDate]) {
      self.start = endDate;
      self.end = startDate;
    } else {
      self.start = startDate;
      self.end = endDate;
    }
  }
  
  return self;
}

-(id)initWithDate:(NSDate *)dv duration:(NSTimeInterval)ti {
  if ((self = super.init)) {
    self.start = dv;
    self.end = [start dateByAddingTimeInterval:ti];
  }
  
  return self;
}

-(void)dealloc {
  [start release];
  [end release];
  [super dealloc];
}

-(NSDate *)start {
  return start;
}

-(void)setStart:(NSDate *)date {
  if ([start isEqual:date]) {
    return;
  }
  
  [start release];
  if ([date isAfter:end]) {
    start = end;
    end = date.retain;
  } else {
    start = date.retain;
  }
}

-(NSDate *)end {
  return end;
}

-(void)setEnd:(NSDate *)date {
  if ([end isEqual:date]) {
    return;
  }
  
  [end release];
  if ([date isBefore:start]) {
    end = start;
    start = date.retain;
  } else {
    end = date.retain;
  }
}

-(BOOL)isEmpty {
  return start == nil && end == nil;
}

-(BOOL)isEqualTo:(id)object {
  if ([object isKindOfClass:THDateRange.class]) {
    THDateRange *r = (THDateRange *)object;
    return [start isEqualTo:r.start] && [end isEqualTo:r.end];
  }
  return NO;
}

/*
 * The comparison may be either an NSDate or a THDateRange
 */
-(BOOL)contains:(id)date {
  if ([date isKindOfClass:NSDate.class]) {
    return [self containsDate:date];
  }
  if ([date isKindOfClass:THDateRange.class]) {
    return [self containsRange:date];
  }
  return NO;
}

-(NSComparisonResult)compareWithDate:(NSDate *)date {
  if ([start isAfter:date]) {
    return NSOrderedAscending;
  }
  if ([end isBefore:date]) {
    return NSOrderedDescending;
  }
  return NSOrderedSame;
}

-(BOOL)containsDate:(NSDate *)date {
  return !([start isAfter:date] || [end isBefore:date]);
}

-(BOOL)containsAnyDate:(NSSet *)dates {
  for (NSDate *date in dates) {
    if ([self contains:date]) {
      return YES;
    }
  }
  return NO;
}

-(BOOL)containsRange:(THDateRange *)range {
  return !([start isAfter:range.start] || [end isBefore:range.end]);
}

-(BOOL)intersectsWithRange:(THDateRange *)range {
  NSDate *first = [start laterDate:range.start];
  NSDate *second = [end earlierDate:range.end];
  
  return ![first isAfter:second];
}

-(THDateRange *)intersectWithRange:(THDateRange *)range {
  NSDate *first = [start laterDate:range.start];
  NSDate *second = [end earlierDate:range.end];
  
  if ([first isAfter:second]) {
    return THDateRange.range;
  }
  
  return [THDateRange rangeFromDate:first toDate:second];
}

-(THDateRange *)combineWithRange:(THDateRange *)range {
  return [THDateRange rangeFromDate:[start earlierDate:range.start]
                             toDate:[end laterDate:range.end]];
}

-(THDateRange *)previousRangeOfType:(DateRangeType)type {
  if (start) {
    return [[start oneSecondAgo] rangeOfType:type];
  }
  
  return nil;
}

-(THDateRange *)nextRangeOfType:(DateRangeType)type {
  if (end) {
    return [[end oneSecondLater] rangeOfType:type];
  }
  
  return nil;
}

-(NSTimeInterval)duration {
  if (!start || !end) {
    return 0;
  }
  return [end timeIntervalSinceDate:start];
}

-(BOOL)closed {
  return !!start && !!end;
}

-(NSUInteger)days {
  if (!self.closed) {
    return 0;
  }
  
  //return [end daysSinceDate:start] + 1;
  return round(self.duration / 86400);
}

-(void)setStart:(NSDate *)sv end:(NSDate *)ev {
  [start release];
  [end release];
  
  if ([ev timeIntervalSinceDate:sv] > 0) {
    start = sv.retain;
    end = ev.retain;
  } else {
    end = sv.retain;
    start = ev.retain;
  }
}

-(void)moveByTimeInterval:(NSTimeInterval)seconds {
  NSDate *newStart = [start dateByAddingTimeInterval:seconds];
  NSDate *newEnd   = [end   dateByAddingTimeInterval:seconds];
  
  [start release];
  start = newStart;
  
  [end release];
  end = newEnd;
}

-(void)moveByDays:(NSTimeInterval)dv {
  NSDate *newStart = [start dateWithDaysFromToday:dv];
  NSDate *newEnd   = [end   dateWithDaysFromToday:dv];
  
  [start release];
  start = newStart;
  
  [end release];
  end = newEnd;
}

-(void)moveByMonths:(NSTimeInterval)mv {
  NSDate *newStart = [start dateWithMonthsFromToday:mv];
  NSDate *newEnd   = [end   dateWithMonthsFromToday:mv];
  
  [start release];
  start = newStart;
  
  [end release];
  end = newEnd;
}

-(CGFloat)coverageInRange:(THDateRange *)other {
  if (!self.closed || !other || !other.closed) {
    // failsafe return
    return 0.0;
  }
  THDateRange *intersection = [other intersectWithRange:self];
  NSTimeInterval idur = intersection.duration;
  NSTimeInterval odur = other.duration;
  
  if (odur > 0) {
    return idur / odur;
  }
  
  return 0.0;
}

-(NSString *)info {
  NSString *first  = start ? start.sqlDay : @"-";
  NSString *second = end   ? end.sqlDay   : @"-";
  NSString *third  = start && end ? $(@" = %i", self.days) : @"";
  return $(@"[%@ ; %@]%@", first, second, third);
}

-(NSString *)description {
  return $(@"THDateRange(%@ >> %@)", start.sqlDate, end.sqlDate);
}

@end

@implementation NSDate (THDateRange)

-(THDateRange *)dayRange {
  NSDate *from = self.today;
  NSDate *to = from.tomorrow.oneSecondAgo;
  return [THDateRange rangeFromDate:from toDate:to];
}

-(THDateRange *)weekRange {
  NSDate *from = self.firstDayOfWeek;
  NSDate *to = [[from dateWithDaysFromToday:7] oneSecondAgo];
  return [THDateRange rangeFromDate:from toDate:to];
}

-(THDateRange *)monthRange {
  NSDate *from = self.primo;
  NSDate *to = [[from dateWithMonthsFromToday:1] oneSecondAgo];
  return [THDateRange rangeFromDate:from toDate:to];
}

-(THDateRange *)quarterRange {
  NSDate *from = self.primo;
  // there is a quarter change on every first of three months
  NSInteger m = (self.month - 1) % 3;
  if (m) {
    from = [from dateWithMonthsFromToday:-m];
  }
  NSDate *to = [[from dateWithMonthsFromToday:3] oneSecondAgo];
  return [THDateRange rangeFromDate:from toDate:to];
}

-(THDateRange *)yearRange {
  NSInteger year = self.year;
  NSDate *from = [NSDate dateWithYear:year month:1 day:1];
  NSDate *to   = [[NSDate dateWithYear:year + 1 month:1 day:1] oneSecondAgo];
  return [THDateRange rangeFromDate:from toDate:to];
}

-(THDateRange *)rangeOfType:(DateRangeType)type {
  switch (type) {
    case DateRangeDay: 
      return self.dayRange;
    case DateRangeWeek: 
      return self.weekRange;
    case DateRangeMonth: 
      return self.monthRange;
    case DateRangeQuarter: 
      return self.quarterRange;
    case DateRangeYear: 
      return self.yearRange;
    default:
      break;
  }
  
  return nil;
}

-(THDateRange *)nextRangeOfType:(DateRangeType)type {
  return [[[[self rangeOfType:type] end] oneSecondLater] rangeOfType:type];
}

-(THDateRange *)previousRangeOfType:(DateRangeType)type {
  return [[[[self rangeOfType:type] start] yesterday] rangeOfType:type];
}

@end

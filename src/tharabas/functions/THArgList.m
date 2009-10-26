//
//  THArgList.m
//  Lumumba
//
//  Created by Benjamin Schüttler on 08.11.09.
//  Copyright 2011 Rogue Coding. All rights reserved.
//

#import "THArgList.h"

@interface THArgList (Private)

-(id)initWithList:(va_list)argList;

@end


@implementation THArgList

+(THArgList *)listWithReferences:(id*)ref,... {
  THArgList *re = [[THArgList alloc] init];
  
  va_list args, argc;
  va_start(args, ref);
  va_copy(argc, args);
  
  re->count = 0;
  for (id* r = ref; r; r = va_arg(argc, id*)) {
    re->count++;
  }
  va_end(argc);

  re->arguments = malloc(sizeof(id*) * re->count);
  re->count = 0;
  for (id* r = ref; r; r = va_arg(args, id*)) {
    re->arguments[re->count] = r;
    re->count++;
  }
  va_end(args);
  
  return [re autorelease];
}

-(id)initWithReferences:(id *)ref,... {
  self = super.init;
  
  va_list args, argc;
  va_start(args, ref);
  va_copy(argc, args);
  
  count = 0;
  for (id* r = ref; r; r = va_arg(argc, id*)) {
    count++;
  }
  va_end(argc);
  
  arguments = malloc(sizeof(id*) * count);
  count = 0;
  for (id* r = ref; r; r = va_arg(args, id*)) {
    arguments[count] = r;
    count++;
  }
  va_end(args);
  
  return self;
}

-(void)dealloc {
  free(arguments);
  [super dealloc];
}

-(NSArray *)arrayValues {
  NSMutableArray *re = NSMutableArray.array;
  
  for (int i = 0; i < count; i++) {
    id o = *arguments[i];
    if (o) {
      [re addObject:o];
    } else {
      [re addObject:NSNull.null];
    }
  }
  
  return re;
}

-(void)setArrayValues:(NSArray *)values {
  if (!count || !values || !values.count) {
    return;
  }
  
  NSUInteger max = MIN(count, values.count);
  
  int i = 0;
  // fill all arguments with the values from the array
  for (; i < max; i++) {
    *arguments[i] = [values objectAtIndex:i];
  }
  // pass nil for non existing elements in the array
  for (; i < count; i++) {
    *arguments[i] = nil;
  }
}

@end

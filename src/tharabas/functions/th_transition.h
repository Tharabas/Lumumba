/*
 *  th_transition.h
 *  Lumumba
 *
 *  Created by Benjamin Schüttler on 25.10.09.
 *  Copyright 2011 Rogue Coding. All rights reserved.
 *
 */

#include <Foundation/Foundation.h>

#define EASE_IN [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]
#define EASE_OUT [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]
#define EASE_INOUT [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]

typedef double (^THTransitionBlock)(double location);
typedef double (*THTransitionFunction)(double location);

#define THTransitionBlockWithFunction(FN) \
  ^(double location) { return FN(location); }
#define THT_DEX(FN) \
  ^(double location) { return FN(FN(location)); }
#define THT_TREX(FN) \
  ^(double location) { return FN(FN(FN(location))); }
#define THT_QUADEX(FN) \
  ^(double location) { return FN(FN(FN(FN(location)))); }
#define THT_NEX(FN, N) ^(double location) { \
  double re = location; \
  for (NSUInteger nindex; nindex < N; nindex++) { re = FN(re); } \
  return re; \
}

//
// transition methods
//

/**
 * linear transition will return simply the location value
 */
double tht_linear(double location);

/**
 * reverse transition will return (1 - location)
 */
double tht_reverse(double location);

/**
 * sinoidal will return a sinoidal curve (ease in + ease out)
 */
double tht_sinoidal(double location);

/**
 * cubic will return a pow(location, 2)
 */
double tht_cubic(double location);

/**
 * rooty will return 
 */
double tht_rooty(double location);

/**
 *
 */
double tht_damped(double location, 
                  THTransitionFunction func, 
                  THTransitionFunction damper);

/**
 * harmonic_wave will return a shifted sine wave with 'waves' peaks
 * within the range of 0 to 1
 */
double tht_harmonic_wave(double location, double waves);

/**
 *
 */
double tht_damped_harmonic_wave(double location, 
                                double waves, 
                                THTransitionFunction damper);

/**
 * spring will return a damped harmonic wave with 5 peaks and cubic decay
 */
double tht_spring(double location);
/**
 * caged damped harmonic wave with 4 peaks
 */
double tht_bounce(double location);

double tht_cage(double value);

double tht_blend(double from, double to, double location);

//
// random methods
//
BOOL lucky(double chance);

double pbias(double bias);

double ranf();
double rranf(double min, double max);

double branf(double bias);
double brranf(double min, double max, double bias);

int ran(int max);
int rran(int min, int max);

int bran(int max, double bias);
int brran(int min, int max, double bias);

int fran(int max, THTransitionFunction transition);
int frran(int min, int max, THTransitionFunction transition);

int tran(int max, THTransitionBlock transition);
int trran(int min, int max, THTransitionBlock transition);

double rounds(double value, double snap);
double floors(double value, double snap);
double ceils(double value, double snap);

double fac(uint n);
double binom(uint n, uint k);
double bernstein(uint degree, uint curve, double spot);
double *bernsteins(uint degree, uint curve, uint spots);
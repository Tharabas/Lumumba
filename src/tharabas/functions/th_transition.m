/*
 *  th_transition.c
 *  Lumumba
 *
 *  Created by Benjamin Schüttler on 25.10.09.
 *  Copyright 2011 Rogue Coding. All rights reserved.
 *
 */

#include "th_transition.h"
#define RAN_MAX (1L << 30)

//
// transition methods
//
double tht_linear(double location) {
  return location;
}
double tht_reverse(double location) {
  return 1.0 - location;
}
double tht_sinoidal(double location) {
  return -cos(location * M_PI) / 2.0 + .5;
}
double tht_cubic(double location) {
  return pow(location, 2);
}
double tht_rooty(double location) {
  return pow(location, .5);
}
double tht_spring(double location) {
  return tht_damped_harmonic_wave(location, 5, tht_cubic);
}
double tht_bounce(double location) {
  return tht_cage(tht_damped_harmonic_wave(location, 3, tht_cubic));
}

double tht_damped(double location, 
                  THTransitionFunction func, 
                  THTransitionFunction damper) 
{
  return tht_reverse(damper(location)) * func(location);
}
double tht_harmonic_wave(double location, double waves) {
  return -cos(location * M_PI * ABS(waves)) + 1;
}
double tht_damped_harmonic_wave(double location, 
                                double waves, 
                                THTransitionFunction damper) 
{
  return 
    damper(tht_reverse(location)) 
    * (tht_harmonic_wave(location, waves) - 1)
    + 1;
}

double tht_cage(double value) {
  while (TRUE) {
    if (value >= 0 && value <= 1) {
      return value;
    }
    if (value > 1) {
      value = 2 - value;
    }
    if (value < 0) {
      value *= -1;
    }
  }
  
  return 0;
}

double tht_blend(double from, double to, double location) {
  return (1 - location) * from + location * to;
}

//
// random methods
//

BOOL lucky(double chance) {
  if (chance > 1) {
    return YES;
  } else if (chance <= 0) {
    return NO;
  }
  
  return ranf() <= chance;
}

double pbias(double bias) {
  return bias >= 0 ? bias : -1 / bias;
}

double ranf() {
  return (arc4random() % RAN_MAX) / (double)RAN_MAX;
}

double rranf(double min, double max) {
  return ranf() * (max - min + 1) + min;
}

double branf(double bias) {
  if (bias == 0) {
    return ranf();
  }
  return pow(ranf(), pbias(bias));             
}

int ran(int max) {
  return arc4random() % max;
}

int rran(int min, int max) {
  return ran((max - min) + 1) + min;
}

int bran(int max, double bias) {
  double r = (ran(max) + 1) / (double)max;
  r = pow(r, pbias(bias));
  r = r * max - 1;
  return round(r);
}

int brran(int min, int max, double bias) {
  if (bias == 0.0) {
    return rran(min, max);
  }

  return bran((max - min) + 1, bias) + min;
}

int fran(int max, THTransitionFunction t) {
  return t((ran(max) + 1) / (double)max) * max - 1;
}

int frran(int min, int max, THTransitionFunction t) {
  return fran((max - min) + 1, t) + min;
}

int tran(int max, THTransitionBlock t) {
  return t((ran(max) + 1) / (double)max) * max - 1;
}

int trran(int min, int max, THTransitionBlock t) {
  return tran((max - min) + 1, t) + min;
}

double rounds(double value, double snap) {
  if (snap == 0) {
    return round(value);
  }
  
  return round(value / snap) * snap;
}

double floors(double value, double snap) {
  if (snap == 0) {
    return floor(value);
  }
  
  return floor(value / snap) * snap;
}

double ceils(double value, double snap) {
  if (snap == 0) {
    return ceil(value);
  }
  
  return ceil(value / snap) * snap;
}

double fac(uint n) {
  double re = 1;
  for (int i = 2; i < n; i++) re *= i;
  return re;
}

double binom(uint n, uint k) {
  return fac(n) / (fac(k) * fac(n - k));
}

double bernstein(uint degree, uint curve, double spot) {
  return binom(degree, curve) 
    * pow(spot, curve) 
    * pow(1.0 - spot, .0 + degree - curve);
}

double *bernsteins(uint degree, uint curve, uint spots) {
  if (spots == 0) return nil;
  double *re = malloc(sizeof(double) * spots);
  if (spots == 1) {
    re[0] = 1.0;
    return re;
  }
  double step = 1.0 / (spots - 1);
  double spot = 0.0;
  double b = binom(degree, curve);
  
  for (int i = 0; i < spots; i++, spot += step) {
    re[i] = b * pow(spot, curve) * pow(1.0 - spot, .0 + degree - curve);
  }
  
  return re;
}

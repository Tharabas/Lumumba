# CURRENTLY OUT OF SUPPORT #

I'm quite sorry to tell you guys, but at this time, i cannot afford the time in keeping up this Project as it should be.

The Categories inside may still be worth taken a look, but I can not recommend using them in any production system.

But the development of the __Lumumba__ framework hasn't been completely abandoned. I'm just focusing on the Mobile part,
so have a look at https://github.com/Tharabas/lumobile for the iOS version of this framework.

-- Ben, December 2012

# Cocoa best practice extensions

Lumumba contains a disjoint set of features

## Extensions to standard Objective-C classes aka. Categories

### NSColor / UIColor

Especially the color classes needed an easy access point.
The ``THWebNamedColors`` caches a map of named colors with the default web names (css) of the colors.
Thus you can grab an NSColor with the value of __skyblue__ via ``[NSColor colorWithName:@"skyblue"]``

A more generic parser version of this is ``[NSColor colorFromString:colorString]`` wich tries to parse
any string into a NSColor.

That string2color parser allows even more stuff, like blending colors:

50% white, 50% blue -> ``[NSColor colorFromString:@"white <> blue"]`` (see NSColor+Conversion for more details on this)

It even defines a (readonly) property __colorValue__ on a NSString, allowing you to use this:

```
NSColor *magenta   = @"magenta".colorValue;
NSColor *pinkGlass = @"pink".colorValue.translucent;
```

As well as another (readonly) property __colorValues__ on NSArray

```
NSArray *colors = [NSArray arrayWithObjects:[NSColor blackColor], 
                                            [NSColor colorNamed:@"pink"],
                                            [NSColor colorNamed:@"gold"],
                                            nil
                  ];
// or simply
NSArray *colors = @"black pink gold".words.colorValues;
```

## Some Objective-C Sugar

Lots and lots of times, you usually need to format NSStrings.
Each time with `` [NSString stringWithFormat:format, arg1, arg2, arg3, ...] ``

This can be shortened to `` $(format, arg1, arg2, arg3, ...) `` using the ``$`` macro.

As well as `` [NSArray arrayWithObjects:o1, o2, o3, ..., nil] ``

May be written as `` $array(o1,o2,o3) ``

There are other _preprocessor macros_ that do similar things.

## A thin layer for geometric calculus

Look for ``THPoint``, ``THSize``, ``THRect`` in the sources.

_... more details on that later ..._

## Own UI components, for use with MacOS and iOS

_... more details on that later ..._

## DISCLAIMER

All those components, snippets and code fragments have been created,
because I either used them very often and thought, there should be
an easier way to do this, or because I simply did not know that there
is another way to do this in Objective-C.

I do neither claim all things to be flawless nor perfect to fit _your_ Apps.

I'm absolutely aware, that _preprocessor macros_ may be considered evil,
as they obscure code. That may be right, but they can also be used to considerably
_clean up the code_, what would be desired behaviour.

Anyway they are a feature of the c environment.

You may use it or you may leave it. Still your decision.

Constructive comments are welcome, anytime, though.
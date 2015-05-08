//
//  MusicBackground.m
//  Chubby
//
//  Created by Luan Lima on 5/7/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "MusicBackground.h"

static MusicBackground *musicBgd = nil;

@implementation MusicBackground

+ (id)sharedInstance{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    // executes a block object once and only once for the lifetime of an application
        dispatch_once(&p, ^{
            _sharedObject = [[self alloc] init];
        });
    // returns the same object each time
    return _sharedObject;
}

@end

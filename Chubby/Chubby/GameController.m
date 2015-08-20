//
//  GameController.m
//  Chubby
//
//  Created by Danilo Barros Mendes on 5/7/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "GameController.h"

@implementation GameController

+(id)sharedInstance{
    
    static dispatch_once_t p =0;
    
    __strong static id _sharedObject = nil;
    
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    return _sharedObject;
}

@end

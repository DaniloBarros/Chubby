//
//  FrenchFries.m
//  Chubby
//
//  Created by Ludimila da Bela Cruz on 24/04/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "FrenchFries.h"

@implementation FrenchFries


-(id)initWithPosition: (CGPoint)position{

    FrenchFries *_frenchFries;
    
    _frenchFries = [FrenchFries spriteNodeWithImageNamed:@"FrenchFries"];
    _frenchFries.position = position;
    
    return _frenchFries;

}

@end

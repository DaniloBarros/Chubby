//
//  ItensNode.m
//  Chubby
//
//  Created by Ludimila da Bela Cruz on 17/04/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "ItensNode.h"

@implementation ItensNode

+(id)initWithPosition: (CGPoint)position{

    SKSpriteNode *_candy;
    SKSpriteNode *_frenchFries;
    SKSpriteNode *_iceCream;
    
    _candy = [self spriteNodeWithImageNamed:@"Candy"];
    _candy.anchorPoint = CGPointZero;
    _candy.position = CGPointMake(_candy.size.width/2, _candy.size.height/2);
    
    
    _frenchFries = [self spriteNodeWithImageNamed:@"FrenchFries"];
    _frenchFries.anchorPoint = CGPointZero;
    _frenchFries.position = CGPointMake(_frenchFries.size.width/2, _frenchFries.size.height/2);
    
    _iceCream = [self spriteNodeWithImageNamed:@"IceCream"];
    _iceCream.anchorPoint = CGPointZero;
    _iceCream.position = CGPointMake(_iceCream.size.width/2, _iceCream.size.height/2);
    
    [_candy addChild:_frenchFries];
    [_candy addChild:_iceCream];
    
    return _candy;


}

@end

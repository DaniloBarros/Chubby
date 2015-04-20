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
    _candy.position = position;
    _candy.name = @"Candy";
    
    _frenchFries = [self spriteNodeWithImageNamed:@"FrenchFries"];
    _frenchFries.position = position;
    
    _iceCream = [self spriteNodeWithImageNamed:@"IceCream"];
    _iceCream.position = position;
    
    NSArray *_items = [ NSArray arrayWithObjects:_frenchFries, _iceCream, _candy, nil];
    
    int selectItem = arc4random()%[_items count];
        
    return _items[selectItem];

}


@end

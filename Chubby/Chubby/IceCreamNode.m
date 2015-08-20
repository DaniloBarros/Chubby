//
//  IceCreamNode.m
//  Chubby
//
//  Created by Ludimila da Bela Cruz on 24/04/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "IceCreamNode.h"

@implementation IceCreamNode

-(id)initWithPosition: (CGPoint)position{


    IceCreamNode *_iceCream;

    _iceCream = [IceCreamNode spriteNodeWithImageNamed:@"IceCream"];
    _iceCream.position = position;
    
    return _iceCream;
}

@end

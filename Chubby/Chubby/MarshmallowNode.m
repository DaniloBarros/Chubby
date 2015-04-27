//
//  MarshmallowNode.m
//  Chubby
//
//  Created by Ludimila da Bela Cruz on 22/04/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "MarshmallowNode.h"

@implementation MarshmallowNode

+(id)initWithPosition:(CGPoint)position{

    SKSpriteNode *_marshmallow;
    
    _marshmallow = [MarshmallowNode spriteNodeWithImageNamed:@"Marshmallow"];
    _marshmallow.anchorPoint = CGPointMake(0.5, 0);
    _marshmallow.position = position;
    _marshmallow.zPosition = -1;
    [_marshmallow setScale:0.9];
    [_marshmallow setXScale:1.2];
    
    return _marshmallow;

}

@end

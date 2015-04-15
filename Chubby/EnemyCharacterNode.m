//
//  EnemyCharacterNode.m
//  Chubby
//
//  Created by Ludimila da Bela Cruz on 15/04/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "EnemyCharacterNode.h"

@implementation EnemyCharacterNode

+(id)initWithPosition:(CGPoint)position{
    
    EnemyCharacterNode *enemy = [self spriteNodeWithImageNamed:@"magrelo0"];
    enemy.position = position;
    [enemy setScale:0.5];
    return enemy;
}


@end

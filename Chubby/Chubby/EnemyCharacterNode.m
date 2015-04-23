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
    
    EnemyCharacterNode *_tank;
    SKSpriteNode *_enemyHead;
    SKSpriteNode *_wheel;
    
    
    _tank = [self spriteNodeWithImageNamed:@"Tank"];
    _tank.anchorPoint = CGPointZero;
    _tank.position =CGPointMake(_tank.size.width*1.8 + 200, _tank.size.height*0.2);
    
    [_tank setScale:0.3];
    
    _enemyHead = [self spriteNodeWithImageNamed:@"HeadSkinny"];
    _enemyHead.anchorPoint = CGPointZero;
    
    [_tank addChild:_enemyHead];

    _enemyHead.position = CGPointMake(_enemyHead.size.width*1.9 , _enemyHead.size.height*0.55);
    [_enemyHead setScale:0.8];
    
    
    _wheel = [self spriteNodeWithImageNamed:@"Wheel"];
    _wheel.anchorPoint = CGPointMake(0.2, 0);
    
    [_tank addChild:_wheel];
    
    _wheel.position = CGPointMake(_wheel.size.width/2, -_wheel.size.height/2);
    [_wheel setScale:1.3];
    
    
    
    
    return _tank;
}


-(SKAction *)playShotAnimation{
    
    NSMutableArray *textures = [[NSMutableArray alloc] init];

    for (int i=6; i>0; i--) {
        
        NSString *name = [NSString stringWithFormat:@"Bullet"];
        SKTexture *texture = [SKTexture textureWithImageNamed:name];
        [textures addObject:texture];
    }
    
    for (int i=0; i<6; i++) {
        NSString *name = [NSString stringWithFormat:@"Bullet"];
        SKTexture *texture = [SKTexture textureWithImageNamed:name];
        [textures addObject:texture];
    }
    
    SKAction *action = [SKAction animateWithTextures:textures timePerFrame:0.2];
    
    return action;
}

@end

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
    SKSpriteNode *_midTank;
    SKSpriteNode *_wheel;
    SKSpriteNode *_pipe;
    
    _tank = [self spriteNodeWithImageNamed:@"TopTank"];
    [_tank setScale:0.3];
    _tank.anchorPoint = CGPointMake(0.5, 0.5);
    _tank.position = position;

    
    _enemyHead = [self spriteNodeWithImageNamed:@"HeadSkinny"];
    _enemyHead.anchorPoint = CGPointMake(0.5, 0);
    [_enemyHead setScale:0.8];
    _enemyHead.position = CGPointMake(_tank.size.width/2 - _enemyHead.size.width/2 + 10,
                                      _tank.size.height + 5);
    _enemyHead.name = @"enemyHead";
    [_tank addChild:_enemyHead];
    
    _midTank = [self spriteNodeWithImageNamed:@"MidTank"];
    _midTank.position = CGPointMake(0,
                                    0 - _midTank.size.height/2 + 10);
    _midTank.name = @"midTank";
    [_tank addChild:_midTank];
    
    _wheel = [self spriteNodeWithImageNamed:@"Wheel"];
    _wheel.anchorPoint = CGPointMake(0.5, 0);
    _wheel.position = CGPointMake(_midTank.position.x,
                                  _midTank.position.y - _wheel.size.height/2 - _midTank.size.height/2 -10);
    [_wheel setScale:1.3];
    _wheel.name = @"wheel";
    [_tank addChild:_wheel];
    
    _pipe = [self spriteNodeWithImageNamed:@"PipeTank"];
    _pipe.anchorPoint = CGPointMake(0.5, 0);
    _pipe.position = CGPointMake(_midTank.position.x - _midTank.size.width/2 + 55,
                                 _midTank.position.y + _pipe.size.height/2 - 20);
    
    _pipe.zRotation = M_PI_4;
    
    _pipe.name=@"pipe";
    [_tank addChild:_pipe];
    
    
    
    return _tank;
}

-(void)runningAnimation{
    
    SKAction *action = [SKAction moveByX:0 y:5 duration:0.1];
    SKAction *sequence = [SKAction sequence:@[action, [action reversedAction]]];
    [[self childNodeWithName:@"wheel"] runAction:[SKAction repeatActionForever:sequence] withKey:@"runningWheel"];
}

-(void)stopChildrenAnimations{
    [[self childNodeWithName:@"wheel"] removeAllActions];
    [[self childNodeWithName:@"midTank"] removeAllActions];
    [[self childNodeWithName:@"enemyHead"] removeAllActions];
}

@end

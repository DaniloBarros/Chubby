//
//  MainCharacterNode.m
//  Chubby
//
//  Created by Danilo Barros Mendes on 4/15/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "MainCharacterNode.h"

@implementation MainCharacterNode

+(id)initWithPosition:(CGPoint)position{
    
    MainCharacterNode *main = [self spriteNodeWithImageNamed:@"animacao_pulo1"];
    main.position = position;
    
    [main setScale:0.3/3];
    main.anchorPoint = CGPointMake(0.5, 0);
    
    SKAction *repeat = [SKAction repeatActionForever:[main preJumpAnimation]];
    
    [main runAction:repeat withKey:@"preJump"];
    
    return main;
    
}

-(SKAction *)preJumpAnimation{
    
    NSMutableArray *textures = [[NSMutableArray alloc] init];
    
    for (int i=1; i<6; i++) {
        NSString *name = [NSString stringWithFormat:@"animacao_pulo%d",i];
        SKTexture *texture = [SKTexture textureWithImageNamed:name];
        [textures addObject:texture];
    }
    
    for (int i=6; i>0; i--) {
        NSString *name = [NSString stringWithFormat:@"animacao_pulo%d",i];
        SKTexture *texture = [SKTexture textureWithImageNamed:name];
        [textures addObject:texture];
    }
    
    SKAction *action = [SKAction animateWithTextures:textures timePerFrame:0.2];
    
    return action;
    
}

-(SKAction *)fallAnimation{
    
    NSMutableArray *textures = [[NSMutableArray alloc] init];
    
    for (int i=7; i<15; i++) {
        NSString *name = [NSString stringWithFormat:@"animacao_pulo%d",i];
        SKTexture *texture = [SKTexture textureWithImageNamed:name];
        [textures addObject:texture];
    }
    
    for (int i=15; i>7; i--) {
        NSString *name = [NSString stringWithFormat:@"animacao_pulo%d",i];
        SKTexture *texture = [SKTexture textureWithImageNamed:name];
        [textures addObject:texture];
    }
    
    SKAction *action = [SKAction animateWithTextures:textures timePerFrame:0.2];
    
    return action;
}

-(SKAction *)flyAnimation{
    NSMutableArray *textures = [[NSMutableArray alloc] init];
    
    for (int i=16; i<29; i++) {
        NSString *name = [NSString stringWithFormat:@"animacao_pulo%d",i];
        SKTexture *texture = [SKTexture textureWithImageNamed:name];
        [textures addObject:texture];
    }
    
    for (int i=29; i>16; i--) {
        NSString *name = [NSString stringWithFormat:@"animacao_pulo%d",i];
        SKTexture *texture = [SKTexture textureWithImageNamed:name];
        [textures addObject:texture];
    }

    /*
    SKAction *leftWiggle = [SKAction rotateByAngle:M_PI_4/10 duration:0.3];
    SKAction *middleWiggle = [leftWiggle reversedAction];
    SKAction *rightWiggle = [SKAction rotateByAngle:-M_PI_4/10 duration:0.3];
    SKAction *fullWiggle = [SKAction repeatActionForever:
                            [SKAction sequence:@[leftWiggle,
                                                 middleWiggle,
                                                 rightWiggle,
                                                 [rightWiggle reversedAction]]
                             ]];
    */
    SKAction *action = [SKAction animateWithTextures:textures timePerFrame:0.2];
    
    return [SKAction group:@[[SKAction repeatActionForever:action]]];

}


@end

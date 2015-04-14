//
//  GameScene.m
//  Chubby
//
//  Created by Ludimila da Bela Cruz on 13/04/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "GameScene.h"

#define MAX_IMPULSE 100.0

@implementation GameScene

{
    SKSpriteNode *_mainCharacter;
    BOOL _first;
    
    CGFloat _impulse;
    
    CGFloat _impulsePlus;
    
}

-(id)initWithSize:(CGSize)size{
    
    if(self = [super initWithSize:size]){
        
        self.backgroundColor = [SKColor whiteColor];
        
        //add background game
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        bg.anchorPoint = CGPointZero;
        bg.position = CGPointZero;
        [bg setScale:1.17];
        [self addChild:bg];

        //add main caracter
        _mainCharacter = [SKSpriteNode spriteNodeWithImageNamed:@"bolinha"];
        _mainCharacter.position = CGPointMake(self.size.width/8, self.size.height/2 + 50);
        [_mainCharacter setScale:0.3];
        [self addChild:_mainCharacter];
        _impulsePlus = 0;
        
        
        _first = YES;
        
    }
    return self;
}

-(void)fall:(BOOL)jump{
    
    CGPoint characterPos = [_mainCharacter position];
    SKAction *action;
    float duration=0.5;
    
    if(jump){
        _impulse = 50;
        SKAction *jump = [SKAction customActionWithDuration:duration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
            
            //Ele caí de acordo com a duração de tempo, pois ele roda várias vezes enquanto o tempo ainda não estiver completo
            float fraction = elapsedTime/(duration/1.58);
            float yOff = (_impulse + _impulsePlus) * 4 * fraction * (1 - fraction);
            float xOff = (_impulse/30) * (_impulse/30) * fraction;
            
            node.position = CGPointMake(node.position.x + xOff, characterPos.y + yOff);

        }];
        
        action = [SKAction sequence:@[jump]];
        
    }else{
        
        action = [SKAction customActionWithDuration:0.2 actionBlock:^(SKNode *node, CGFloat elapsedTime) {
            
        }];
        
    }
    [_mainCharacter runAction:action];
    _first=NO;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //UITouch *touch = [touches anyObject];
    
    [self fall:_first];
    

}

-(void)update:(NSTimeInterval)currentTime{
    
    
}

@end

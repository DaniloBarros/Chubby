//
//  GameScene.m
//  Chubby
//
//  Created by Ludimila da Bela Cruz on 13/04/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "GameScene.h"

#define MAX_IMPULSE 100.0
//static const float SECOND_CHARACTER_MOVE_POINTS_PER_SEC = 50.0;

@implementation GameScene

{
    SKSpriteNode *_mainCharacter;
    SKSpriteNode *_secondCharacter;
    SKAction *_mainAction;
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
        _mainCharacter = [SKSpriteNode spriteNodeWithImageNamed:@"animacao_pulo0"];
        _mainCharacter.position = CGPointMake(self.size.width/8, self.size.height/2 + 50);
        [_mainCharacter setScale:0.3/3];
        
        //addAnimation
        
        SKAction *action = [self animation:1 second:6 animationName:@"animacao_pulo%d" duration:0.2];
        [_mainCharacter runAction:  [SKAction repeatActionForever:action]];
        
        [self addChild:_mainCharacter];
        
        _impulsePlus = 0;
        
        //add a second character
        _secondCharacter = [SKSpriteNode spriteNodeWithImageNamed:@"segundo"];
        _secondCharacter.position = CGPointMake(self.size.width/15, self.size.height/19);
        [_secondCharacter setScale:0.2];
        [self addChild:_secondCharacter];
        
        
        _first = YES;
        
    }
    return self;
}

-(void)fall:(BOOL)jump{
    
    CGPoint characterPos = [_mainCharacter position];
    SKAction *action1;
    float duration=0.5;
    
    if(jump){
        _impulse = 50;
        
        SKAction *action = [self animation:7 second:15 animationName:@"animacao_pulo%d" duration:0.1];
        [_mainCharacter runAction:  [SKAction repeatActionForever:action]];
        
        SKAction *jump = [SKAction customActionWithDuration:duration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
            
            //Ele caí de acordo com a duração de tempo, pois ele roda várias vezes enquanto o tempo ainda não estiver completo
            float fraction = elapsedTime/(duration/1.58);
            float yOff = (_impulse + _impulsePlus) * 4 * fraction * (1 - fraction);
            float xOff = (_impulse/30) * (_impulse/30) * fraction;
            
            node.position = CGPointMake(node.position.x + xOff, characterPos.y + yOff);
            
        }];
        
        action1 = [SKAction sequence:@[jump]];
        
    }else{
        
        SKAction *actionFirst = [self animation:16 second:29 animationName:@"animacao_pulo%d" duration:0.2];
        [_mainCharacter runAction:  [SKAction repeatActionForever:actionFirst]];
        action1 = [SKAction customActionWithDuration:0.2 actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        }];
    }
    [_mainCharacter runAction:action1];
    
    _first=NO;
}

-(SKAction *)animation: (int)first
                second:(int)second
         animationName: (NSString *)animation
              duration: (float)duration {
    
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:29];
    
    for (int i = first; i < second; i++) {
        NSString *textureName = [NSString stringWithFormat:@"animacao_pulo%d", i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
        
    }
    
    for (int i = second; i > first; i--) {
        NSString *textureName = [NSString stringWithFormat:@"animacao_pulo%d", i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
        
        
    }
    _mainAction = [SKAction animateWithTextures:textures timePerFrame:duration];
    
    
    
    return _mainAction;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //UITouch *touch = [touches anyObject];
    
    [self fall:_first];
    
    
}

- (void)update:(CFTimeInterval)currentTime {
    
    _secondCharacter.position = CGPointMake(_secondCharacter.position.x + 2, _secondCharacter.position.y);
}

@end
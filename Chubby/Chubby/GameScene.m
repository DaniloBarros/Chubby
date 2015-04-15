//
//  GameScene.m
//  Chubby
//
//  Created by Ludimila da Bela Cruz on 13/04/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "GameScene.h"
#import "MainCharacterNode.h"

#define MAX_IMPULSE 100.0
//static const float SECOND_CHARACTER_MOVE_POINTS_PER_SEC = 50.0;

@implementation GameScene

{
    MainCharacterNode *_mainCharacter;
    SKSpriteNode *_secondCharacter;
    SKSpriteNode *_trampoline;
    
    SKAction *_mainAction;
    
    BOOL _first;
    
    CGFloat _impulse;
    CGFloat _impulsePlus;
    
}

-(id)initWithSize:(CGSize)size{
    
    if(self = [super initWithSize:size]){
        
        self.backgroundColor = [SKColor whiteColor];
        
        //add scenario game
        //add sky
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"ceu0"];
        bg.anchorPoint = CGPointZero;
        bg.position = CGPointZero;
        [self addChild:bg];

        //add building
        SKSpriteNode *building = [SKSpriteNode spriteNodeWithImageNamed:@"predio0"];
        building.position = CGPointMake(self.size.width/6.5, self.size.height/2.7) ;
        [self addChild:building];
        
        //add trampoline
        _trampoline = [SKSpriteNode spriteNodeWithImageNamed:@"trampolim0"];
        _trampoline.position = CGPointMake(self.size.width/3.5, self.size.height/4.5);
        [_trampoline setScale:0.6];
        [self addChild:_trampoline];
        
        //add tree
        SKSpriteNode *tree = [SKSpriteNode spriteNodeWithImageNamed:@"arvore0"];
        tree.position = CGPointMake(self.size.width*0.7, self.size.height/3);
        [tree setScale:0.9];
        [self addChild:tree];
        
        //add ground
        SKSpriteNode *ground = [SKSpriteNode spriteNodeWithImageNamed:@"chao0"];
        ground.position = CGPointMake(self.size.width/6, self.size.height/15);
        [self addChild:ground];
        
        //add main caracter
        _mainCharacter = [MainCharacterNode initWithPosition:
                          CGPointMake(self.size.width/5.5, self.size.height*0.81)];
        
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
        
        [_mainCharacter removeActionForKey:@"preJump"];
        
        SKAction *jump = [SKAction customActionWithDuration:duration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
            
            //Ele caí de acordo com a duração de tempo, pois ele roda várias vezes enquanto o tempo ainda não estiver completo
            float fraction = elapsedTime/(duration/1.58);
            float yOff = (_impulse + _impulsePlus) * 4 * fraction * (1 - fraction);
            float xOff = (_impulse/30) * (_impulse/30) * fraction;
            
            node.position = CGPointMake(node.position.x + xOff, characterPos.y + yOff);
            
        }];
        
        action1 = [SKAction group:@[jump,[_mainCharacter fallAnimation]]];
        
    }else{
        
        //[_mainCharacter runAction:[_mainCharacter flyAnimation]];
        action1 = [SKAction repeatActionForever:[_mainCharacter fallAnimation]];
        
    }
    
    [_mainCharacter runAction:action1 withKey:@"fall"];
    
    _first=NO;
}

-(void)fly{
    
//    [_mainCharacter removeAllActions];
    
    [_mainCharacter runAction:
     [SKAction repeatActionForever:[_mainCharacter flyAnimation]]
                      withKey:@"fly" ];
    
    SKAction *move = [SKAction moveTo:
                      CGPointMake(self.size.width, self.size.height/1.1)
                             duration:0.7];
    
    [_mainCharacter runAction:move];
    
}

-(SKAction *)animation: (int)first
                second:(int)second
         animationName: (NSString *)animation
              duration: (float)duration {
    
    NSMutableArray *textures = [NSMutableArray arrayWithCapacity:29];
    
    for (int i = first; i < second; i++) {
        NSString *textureName = [NSString stringWithFormat:animation, i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
        
    }
    
    for (int i = second; i > first; i--) {
        NSString *textureName = [NSString stringWithFormat:animation, i];
        SKTexture *texture = [SKTexture textureWithImageNamed:textureName];
        [textures addObject:texture];
        
        
    }
    SKAction *action = [SKAction animateWithTextures:textures timePerFrame:duration];
    
    
    
    return action;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //UITouch *touch = [touches anyObject];
    
    [self fall:_first];
    
    
}

-(void)collisionCheck{
    
    CGRect smallerFrame = CGRectInset(_trampoline.frame, 30, 30);
    
    if (CGRectIntersectsRect(_mainCharacter.frame, smallerFrame)) {
        
        NSMutableArray *texture = [[NSMutableArray alloc] initWithObjects:
                                   [SKTexture textureWithImageNamed:@"trampolim0"],
                                   [SKTexture textureWithImageNamed:@"trampolim1"],
                                   [SKTexture textureWithImageNamed:@"trampolim2"],
                                   [SKTexture textureWithImageNamed:@"trampolim3"],
                                   [SKTexture textureWithImageNamed:@"trampolim4"],
                                   nil];
        
        
        
        SKAction *actionTrampoline = [SKAction animateWithTextures:texture timePerFrame:0.03];
        [_trampoline runAction:actionTrampoline withKey:@"trampoline"];
        
        
        [self fly];
    }
    
}

- (void)update:(CFTimeInterval)currentTime {
    
    _secondCharacter.position = CGPointMake(_secondCharacter.position.x + 2, _secondCharacter.position.y);
    
    [self collisionCheck];
    
}





























@end
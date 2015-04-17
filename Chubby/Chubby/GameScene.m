//
//  GameScene.m
//  Chubby
//
//  Created by Ludimila da Bela Cruz on 13/04/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "GameScene.h"
#import "MainCharacterNode.h"
#import "EnemyCharacterNode.h"
#import "PBParallaxScrolling.h"

//#define MAX_IMPULSE 100.0
#define ARC4RANDOM_MAX  0x100000000


static const float SECOND_CHARACTER_MOVE_POINTS_PER_SEC = 50.0;

static const CGFloat gravityY = -5.0;


static inline CGFloat ScalarRandomRange(CGFloat min, CGFloat max){
    return floorf( ((double)arc4random() / ARC4RANDOM_MAX) * (max - min)+min);
}
/*
static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b){
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointSubtract(const CGPoint a, const CGPoint b){
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat x){
    return CGPointMake(a.x * x, a.y * x);
}
*/
static inline CGFloat CGPointLenght(const CGPoint a){
    return sqrt(a.x * a.x + a.y * a.y);
}

static inline CGPoint CGPointNormalize(const CGPoint a){
    CGFloat lenght = CGPointLenght(a);
    return CGPointMake(a.x/lenght, a.y/lenght);
}
 
static inline CGFloat CGPointToAgle(const CGPoint a){
    return atan2f(a.y, a.x);
}

static inline CGFloat CGPointDistance(const CGPoint a, const CGPoint b){
    return sqrtf(powf(a.x - a.y, 2.0) + powf(b.x - b.y, 2.0));
}

static inline CGFloat ScalarSign(CGFloat a){
    return a >= 0 ? 1 : -1;
}

static inline CGFloat ScalarShortestAngleBetween(const CGFloat a, const CGFloat b){
    
    CGFloat difference = b - a;
    CGFloat angle = fmodf(difference, M_PI * 2);
    
    if (angle >= M_PI) {
        angle -= M_PI * 2;
        
    }else if (angle <= -M_PI){
        angle += M_PI * 2;
    }
    return angle;
}

 

@implementation GameScene

{
    MainCharacterNode *_mainCharacter;
    EnemyCharacterNode *_enemy;
    
    SKSpriteNode *_trampoline;
    SKSpriteNode *_bullet;

    SKSpriteNode *_ground;
    SKSpriteNode *_tree;
    SKSpriteNode *_building;
    
    SKAction *_mainAction;
    
    BOOL _first, _parallaxIsOn;
    
    CGFloat _impulse;
    CGFloat _impulsePlus;
    
    NSTimeInterval _lastUpdatedTime;
    NSTimeInterval _dt;
    
    NSArray *_imageParallax;
    PBParallaxScrolling *_parallax;
    
    CGFloat _speed;
    
}

-(id)initWithSize:(CGSize)size{
    
    if(self = [super initWithSize:size]){
        
        //self.backgroundColor = [SKColor whiteColor];
        
        //add scenario game
        //add sky
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"ceu1"];
        bg.anchorPoint = CGPointZero;
        bg.position = CGPointZero;
        bg.zPosition = -1000;
        [self addChild:bg];
        
        //add MainCharacter
        _mainCharacter = [MainCharacterNode initWithPosition:
                          CGPointMake(self.size.width/5.5, self.size.height*0.7)];
        
        //add ground
        _ground = [SKSpriteNode spriteNodeWithImageNamed:@"chaoParallax@2x"];
        _ground.anchorPoint = CGPointMake(0, .07);
        _ground.position = CGPointMake(0, _ground.size.height*.07);
        _ground.zPosition = -996;
        

        //add building
        _building = [SKSpriteNode spriteNodeWithImageNamed:@"predio1"];
        _building.position = CGPointZero;
        _building.anchorPoint = CGPointZero;
        _building.zPosition = -999;
        [_building setScale:0.5];
        
        
        //add trampoline
        _trampoline = [SKSpriteNode spriteNodeWithImageNamed:@"trampolim0"];
        _trampoline.position = CGPointMake(self.size.width/3.5, self.size.height/4.5);
        [_trampoline setScale:0.6];
        _trampoline.zPosition = -998;
        
        
        //add tree
        _tree = [SKSpriteNode spriteNodeWithImageNamed:@"arvore1"];
        _tree.anchorPoint = CGPointMake(0.5, 0);
        _tree.position = CGPointMake(self.size.width*0.7, _ground.position.y);
        [_tree setScale:0.45];
        _tree.zPosition = -997;
        
        
        _impulsePlus = 0;
        
        //add a enemy character
        _enemy = [EnemyCharacterNode initWithPosition:
                  CGPointMake(self.size.width/20, self.size.height/10)];
        
        

        [self addChild:_building];
        [self addChild:_trampoline];
        [self addChild:_tree];
        [self addChild:_ground];
        [self addChild:_mainCharacter];
        
        //[self addChild:_enemy];
        
        _first = YES;
        
        _imageParallax = @[@"chaoParallax@2x",
                           @"arvoreParallax@2x",
                           @"NuvemParallax@2x"];
        _parallaxIsOn = NO;
        
        _speed = 0;
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
            float xOff = (_impulse/26) * (_impulse/26) * fraction;
            
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

-(void)launch{
    
    [_mainCharacter runAction:
     [SKAction repeatActionForever:[_mainCharacter flyAnimation]]
                      withKey:@"launch" ];
    
    SKAction *move = [SKAction moveTo:
                      CGPointMake(self.size.width, self.size.height/1.3)
                             duration:0.7];
    
    [_mainCharacter runAction:move];
    
}

-(void)playShot{
    
    //add bullet
    _bullet = [SKSpriteNode spriteNodeWithImageNamed:@"Bullet"];
    _bullet.anchorPoint = CGPointZero;
    _bullet.position = CGPointMake(_bullet.size.width*2.5-30, _bullet.size.height*2-20);
    [_bullet setScale:0.4];
    [self addChild:_bullet];


    [_bullet runAction:[SKAction repeatActionForever:[_enemy playShotAnimation]]withKey:@"shot"];
    
    SKAction *shot = [SKAction moveTo:CGPointMake(self.size.width, self.size.width/1.1) duration:5];
    SKAction *sequenceShot = [SKAction sequence:@[shot, [SKAction waitForDuration:50]]];
    
    [_bullet runAction:sequenceShot];
  

    

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
        
        
        [self launch];
    }
    
    CGPoint mainPosition = _mainCharacter.position;
    
    if (mainPosition.x >= self.size.width && !_parallaxIsOn) {
        
        _speed = 6;
        
        _parallax = [[PBParallaxScrolling alloc] initWithBackgrounds:_imageParallax
                                                                size:self.size
                                                           direction:kPBParallaxBackgroundDirectionLeft
                                                        fastestSpeed:_speed
                                                    andSpeedDecrease:kPBParallaxBackgroundDefaultSpeedDifferential];
        
        [self addChild:_parallax];
        
        _parallaxIsOn = YES;
        
    }
    
}

-(void)moveLeft{
    
    if (_speed) {
        if (_building) {
            _building.position = CGPointMake(_building.position.x - _speed, _building.position.y);
        }
        if (_ground) {
            _ground.position = CGPointMake(_ground.position.x - _speed, _ground.position.y);
        }
        if (_trampoline) {
            _trampoline.position = CGPointMake(_trampoline.position.x - _speed, _trampoline.position.y);
        }
        if (_tree) {
            _tree.position = CGPointMake(_tree.position.x - _speed, _tree.position.y);
        }
        if (_mainCharacter && _mainCharacter.position.x >= self.size.width/5.5) {
            _mainCharacter.position = CGPointMake(_mainCharacter.position.x - _speed, _mainCharacter.position.y);
            
            
            CGPoint velocity = CGPointNormalize(CGPointMake(0, -10));
            
            
            [self rotateSprite:(SKSpriteNode*)_mainCharacter
                        toFace:velocity
            rotateRadiasPerSec:M_PI_4
                         speed:velocity];
        }
    }
}


-(void)rotateSprite:(SKSpriteNode *)sprite
             toFace:(CGPoint)direction
 rotateRadiasPerSec:(CGFloat)rotateRadiansPerSec
              speed:(CGPoint)speed{
    
    float targetAngle = CGPointToAgle(speed);
    float shortest = ScalarShortestAngleBetween(sprite.zRotation, targetAngle);
    float amountToRotate = rotateRadiansPerSec * _dt;
    
    if (ABS(shortest) < amountToRotate) {
        amountToRotate = ABS(shortest);
    }
    
    sprite.zRotation += ScalarSign(shortest) * amountToRotate;
    
}


- (void)update:(CFTimeInterval)currentTime {
    
    if (_lastUpdatedTime) {
        _dt = currentTime - _lastUpdatedTime;
    }else{
        _dt = 0;
    }
    
    _lastUpdatedTime = currentTime;
    
    [self moveLeft];
    
    [_parallax update:currentTime];
    
}

-(void) didEvaluateActions{
    
    [self collisionCheck];
    
}


@end
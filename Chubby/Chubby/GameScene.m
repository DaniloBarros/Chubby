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
#import "GameViewController.h"
#import "GameOverScene.h"
#import "Bullet.h"
#import "MarshmallowNode.h"
#import "CottonCandyNode.h"
#import "FrenchFries.h"
#import "IceCreamNode.h"

//#define MAX_IMPULSE 100.0
#define ARC4RANDOM_MAX  0x100000000
#define SUPER_FALL 7
#define NATURAL_FALL 0.4

static const float SHOT_MOVE_POINTS_PER_SEC = 200;

static const CGPoint gravity(){
    return CGPointMake(0, -0.03);
}

static inline CGFloat ScalarRandomRange(CGFloat min, CGFloat max){
    return floorf( ((double)arc4random() / ARC4RANDOM_MAX) * (max - min)+min);
}

static inline CGPoint CGPointAdd(const CGPoint a, const CGPoint b){
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint CGPointSubtract(const CGPoint a, const CGPoint b){
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint CGPointMultiplyScalar(const CGPoint a, const CGFloat x){
    return CGPointMake(a.x * x, a.y * x);
}
static inline CGFloat CGPointLenght(const CGPoint a){
    return sqrt(a.x * a.x + a.y * a.y);
}

static inline CGPoint CGPointNormalize(const CGPoint a){
    CGFloat lenght = CGPointLenght(a);
    return CGPointMake(a.x/lenght, a.y/lenght);
}

static inline CGFloat CGPointToAgle(const CGPoint a){
    return atan2f(a.x, a.y);
}

//static inline CGFloat CGPointDistance(const CGPoint a, const CGPoint b){
//    return sqrtf(powf(a.x - a.y, 2.0) + powf(b.x - b.y, 2.0));
//}

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
    FrenchFries *_frenchFriesItem;
    IceCreamNode *_iceCreamItem;
    CottonCandyNode *_cottonCandyItem;
    
    MarshmallowNode *_marshmallow;
    
    
    SKSpriteNode *_trampoline;
    SKSpriteNode *_pipeTank;
    
    Bullet *_bullet;
    
    
    SKSpriteNode *_bulletCollision;
    SKSpriteNode *_bulletCopy;
    SKSpriteNode *_ground;
    SKSpriteNode *_tree;
    SKSpriteNode *_building;
    
    SKTexture *_idCandy;
    SKTexture *_idFrenchFries;
    SKTexture *_idIceCream;
    
    SKAction *_mainAction;
    
    BOOL _first, _parallaxIsOn, _musicSound;
    BOOL _isImmune;
    
    int frenchFriesPoint;
    
    NSTimeInterval _lastUpdatedTime;
    NSTimeInterval _dt;
    
    NSArray *_imageParallax;
    PBParallaxScrolling *_parallax;
    
    CGFloat _speed;
    CGFloat _fall;
    CGFloat _timeToNextShot;
    CGFloat _impulse;
    CGFloat _impulsePlus;
    CGFloat _timeToNextMarshmallow;
    CGFloat _timeToNextFrenchFries ;
    CGFloat _timeToNextCottonCandy;
    CGFloat _timeToNextIceCream;
    
    CGPoint _inicio;
    
    SKSpriteNode *_pause;
    SKSpriteNode *_play;
    SKSpriteNode *_musicButton;
    SKSpriteNode *_selectedNode;
    CGVector _force;
    
    SKShapeNode *_pauseScreen;
    SKLabelNode *_mensage;
    
    
    AVAudioPlayer *_audio;

    SKSpriteNode *_backgroundPaused;
    
    SKSpriteNode *_logo;
    
    SKSpriteNode *_restart;
    SKSpriteNode *_exit;
    
}

-(id)initWithSize:(CGSize)size{
        
        if(self = [super initWithSize:size]){
            //add scenario game
            [self addScenario];
            //AddMensage
            [self addMensage];
            //AddLogo
            [self addLogo];
            //add MainCharacter
            [self addMainCharacter];
            //add ground
            [self addGround];
            //add building
            [self addBuilding];
            //add trampoline
            [self addTrampoline];
            //add tree
            [self addTree];
            //AddBullet
            [self addBullet];
            //Add Enemy
            [self addEnemy];
//-----------------------------------
            //AddMusic
            [self addMusic];
            [self addMusicIcon];
            
            //AddExit
            [self addExit];
//-----------------------------------
            _impulsePlus = 0;
            _first = YES;
            _imageParallax = @[@"chaoParallax@2x",
                               @"arvoreParallax@2x",
                               @"NuvemParallax@2x"];
            _parallaxIsOn = NO;
            
            _speed = 10;
            _force = CGVectorMake(0, 0);
            
            _isImmune = NO;
            
            
            
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
        
        [_mainCharacter runAction:action1 withKey:@"preLaunch"];
        
    }
    _first=NO;
}

-(void)applyForce:(CGFloat) dx dy:(CGFloat) dy{
    _force = CGVectorMake(_force.dx + dx, _force.dy + dy);
}

-(void)immunity:(BOOL)immune{
    _isImmune = immune;
}

//Make him fall fast
-(void)tapInChubby{
    SKAction *action1;
    action1 = [SKAction repeatActionForever:[_mainCharacter fallAnimation]];
    [_mainCharacter runAction:action1];
    [self applyForce: 0 dy:-7];
    _fall = SUPER_FALL;
}

-(void)actionEverythingUnFocus{
    _mainCharacter.zPosition = -1;
    _enemy.zPosition = -1;
    _bullet.zPosition = -1;
    _cottonCandyItem.zPosition = -1;
    _frenchFriesItem.zPosition = -1;
    _iceCreamItem.zPosition = -1;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touche in touches) {
        CGPoint final = [touche locationInNode:self];
        CGPoint resultado = CGPointMake((final.x+_inicio.x)/2 , (final.y+_inicio.y)/2);
        SKSpriteNode *node = (SKSpriteNode*)[self nodeAtPoint:resultado];//Pega o node na posição que é mandando
        if ([node.name isEqualToString:@"bullet"]) {
            [node removeFromParent];
        }
    }
    
}

-(void)launch{
    [_mainCharacter runAction:
     [SKAction repeatActionForever:[_mainCharacter flyAnimation]]
                      withKey:@"launch" ];

    [self applyForce:3 dy:3];
    
    //Take Out music symbol
    [_musicButton removeFromParent];
    //   Add Pause
    [self pauseNode];
}

-(void)playShot{

    
    CGPoint positionBullet = CGPointMake(_enemy.position.x - _bullet.size.width - _enemy.size.width +12,
                                         _enemy.position.y + _enemy.size.height + _bullet.size.height/2 -2);
    
    _bullet = [[Bullet alloc] initWithPosition:positionBullet
                                     andVelocity:_mainCharacter.position];
    
    _bullet.zRotation = M_PI_4;
    CGPoint offset = CGPointSubtract(_mainCharacter.position, _bullet.position);
    
    //NSLog(@"Offset %lf %lf", offset.x, offset.y);
    
    CGPoint direction = CGPointNormalize(offset);
    
    CGPoint velocity = CGPointMultiplyScalar(direction, SHOT_MOVE_POINTS_PER_SEC);
    
    NSLog(@"%lf %lf", velocity.x, velocity.y);
    
    [_bullet setTarget:velocity];
    
    [self addChild:[_bullet copy]];
    
}

-(void)moveShot{
    
    [self enumerateChildNodesWithName:@"bullet" usingBlock:^(SKNode *node, BOOL *stop) {
        
        Bullet *bullet = (Bullet*)node;
        
        CGPoint velocity = CGPointMake([[[bullet userData] valueForKey:@"X"] doubleValue], [[[bullet userData] valueForKey:@"Y"] doubleValue]);
        [self moveSprite:bullet velocity:velocity];
        CGPoint toFace = CGPointMultiplyScalar(velocity, -1);
        toFace = CGPointMake(velocity.x*-1, velocity.y);
        [self rotateSprite:bullet toFace:toFace rotateRadiasPerSec:M_PI];
        
    }];
    
}

-(void)moveSprite:(SKSpriteNode*)sprite velocity:(CGPoint)velocity {
    
    CGPoint amountToMove = CGPointMultiplyScalar(velocity, (float)_dt);
    
    sprite.position = CGPointAdd(sprite.position, amountToMove);
    
}

-(void)rotateSprite:(SKSpriteNode *)sprite
             toFace:(CGPoint)direction
 rotateRadiasPerSec:(CGFloat)rotateRadiansPerSec{
    
    float targetAngle = CGPointToAgle(direction);
    float shortest = ScalarShortestAngleBetween(sprite.zRotation, targetAngle);
    float amountToRotate = rotateRadiansPerSec * _dt;
    
    if (ABS(shortest) < amountToRotate) {
        amountToRotate = ABS(shortest);
    }
    
    sprite.zRotation += ScalarSign(shortest) * amountToRotate;
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
    UITouch *touch = [touches anyObject];
    _inicio = [touch locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode*)[self nodeAtPoint:_inicio];
    if (_first) {
        [self firstTime:node];
    }else{
        //Tap actions
        if([node.name isEqualToString:@"pause"]){
            [self pauseAction];
        } else if([node.name isEqualToString:@"chubby"]){
            [self tapInChubby];
        }else if ([node.name isEqualToString:@"play"]) {
            [self playAction];
            self.paused = NO;
        }else if ([node.name isEqualToString:@"restart"]){
            [_audio stop];
            GameScene *scene = [[GameScene alloc]initWithSize:self.frame.size];
            [self.view presentScene:scene];
        } else if([node.name isEqualToString:@"music"]){
            [self stopPauseMusic];
        }
    }
}

-(void)firstTime:(SKSpriteNode*)node{
    if ([node.name isEqualToString:@"music"]) {
        [self playStopMusic];
    }else if([node.name isEqualToString:@"exit"]){
        exit(0);
    }else{
        [_mensage removeFromParent];
        [_logo removeFromParent];
        [_exit removeFromParent];
        [_musicButton removeFromParent];
        [self fall:_first];
    }
}



-(void)blinkSprite:(SKSpriteNode *)sprite
        blinkTimes:(float)blinkTimes
     blinkDuration:(float)blinkDuration{
    
    SKAction *blinkAction = [SKAction customActionWithDuration:blinkDuration
                                                   actionBlock:^(SKNode *node, CGFloat elapsedTime){
                                                       float slice = blinkDuration / blinkTimes;
                                                       float remainder = fmodf(elapsedTime, slice);
                                                       node.hidden = remainder > slice / 2;
                                                   }];
    SKAction *notHidden = [SKAction customActionWithDuration:0
                                                 actionBlock:^(SKNode *node, CGFloat elapsedTime){
                                                     node.hidden = NO;
                                                     _isImmune = NO;
                                                 }];
    [sprite runAction:[SKAction sequence:@[blinkAction, notHidden]]];
}

-(void)collisionCheck{
    CGRect smallerFrame = CGRectInset(_trampoline.frame, 30, 30);
    if (CGRectIntersectsRect(_mainCharacter.frame, smallerFrame)) {
        NSMutableArray *texture = [[NSMutableArray alloc] initWithObjects:
                                   [SKTexture textureWithImageNamed:@"trampolim0000"],
                                   [SKTexture textureWithImageNamed:@"trampolim0001"],
                                   [SKTexture textureWithImageNamed:@"trampolim0002"],
                                   [SKTexture textureWithImageNamed:@"trampolim0003"],
                                   [SKTexture textureWithImageNamed:@"trampolim0004"],
                                   nil];
        SKAction *actionTrampoline = [SKAction animateWithTextures:texture timePerFrame:0.03];
        [_trampoline runAction:actionTrampoline withKey:@"trampoline"];
        [self launch];
    }

    [self enumerateChildNodesWithName:@"marshmallow" usingBlock:^(SKNode *node, BOOL *stop){
    
        SKSpriteNode *marshmallow = (SKSpriteNode *)node;
        marshmallow.position = CGPointMake(marshmallow.position.x - _speed, marshmallow.position.y);
        
        if (CGRectIntersectsRect(marshmallow.frame, _mainCharacter.frame)) {
                
            [self applyForce:0.0 dy:.5];
            SKAction *flyBack = [SKAction repeatActionForever:[_mainCharacter flyAnimation]];
            [_mainCharacter runAction:flyBack];

        }
    
    }];

    [self enumerateChildNodesWithName:@"items" usingBlock:^(SKNode *node, BOOL *stop){
        
        _idCandy = [SKTexture textureWithImageNamed:@"Candy"];
        _idFrenchFries = [SKTexture textureWithImageNamed:@"FrenchFries"] ;
        _idIceCream = [SKTexture textureWithImageNamed:@"IceCream"];
        
        SKSpriteNode *item = (SKSpriteNode *)node;
        item.position = CGPointMake(item.position.x - _speed, item.position.y);
        
        
        if(CGRectIntersectsRect(item.frame, _mainCharacter.frame)){
            
            NSString *strItem = [[NSString alloc] initWithString:[[item texture] description]];
            NSString *strCandy = [[NSString alloc] initWithString:[_idCandy description]];
            
            if ([strItem isEqual:strCandy]) {
                    _speed += 2;
                    [_parallax editSpeeds:_speed andSpeedDecrease:kPBParallaxBackgroundDefaultSpeedDifferential];
            }

            strCandy = [[NSString alloc] initWithString:[_idIceCream description]];
            
            if ([strItem isEqual:strCandy]) {
                
                [self applyForce:0.5 dy:0.5];
            }
            strCandy = [[NSString alloc] initWithString:[_idFrenchFries description]];

            if ([strItem isEqual:strCandy]) {
                frenchFriesPoint++;
                NSLog(@"%d",frenchFriesPoint);
            }
            
            item.name = @"";
            [item removeAllActions];
            [item removeFromParent];
            
        }
    }];
    //verificar colisaor
    //Bullet Collision
    
    [self enumerateChildNodesWithName:@"bullet" usingBlock:^(SKNode *node, BOOL *stop) {
        CGRect bulletFrame = CGRectInset(node.frame, 0, 0);
        
        if(CGRectIntersectsRect(_mainCharacter.frame, bulletFrame)){
            if (!_isImmune) {
                
                [self immunity:YES];
                [self blinkSprite:_mainCharacter blinkTimes:5 blinkDuration:2];
                node.name = @"";
                [node removeFromParent];
                
                if((_speed-4)>0)
                    _speed -= 4;
                else
                    _speed = 0;
                
                [_parallax editSpeeds:_speed andSpeedDecrease:kPBParallaxBackgroundDefaultSpeedDifferential];
            }
        }
    }];
    
    
    //Main Character Collisions
    
    CGPoint mainPosition = _mainCharacter.position;
    
    if ([_mainCharacter actionForKey:@"launch"]  && !_parallaxIsOn) {
        
        _parallax = [[PBParallaxScrolling alloc] initWithBackgrounds:_imageParallax
                                                                size:self.size
                                                           direction:kPBParallaxBackgroundDirectionLeft
                                                        fastestSpeed:_speed
                                                    andSpeedDecrease:kPBParallaxBackgroundDefaultSpeedDifferential];
        
        [self addChild:_parallax];
        _parallaxIsOn = YES;

        
        [_enemy runningAnimation];
    }
    
    //Hit the Ground
    if(mainPosition.y <= 26.25){
        
        _mainCharacter.position = CGPointMake(_mainCharacter.position.x, 26.25);
        SKAction *flyBack = [SKAction repeatActionForever:[_mainCharacter flyAnimation]];
        [_mainCharacter runAction:flyBack];
        
        [self applyForce:0 dy:_speed/3];
        
        if (!_isImmune) {
            [self immunity:YES];
            [self blinkSprite:_mainCharacter blinkTimes:5 blinkDuration:2];
            if((_speed-2)>0)
                _speed -= 2;
            else
                _speed = 0;
            
            _fall = 0;
            [_parallax editSpeeds:_speed andSpeedDecrease:kPBParallaxBackgroundDefaultSpeedDifferential];
        }
    }
    
    //Hit the Sky
    if (mainPosition.y >= self.size.height - _mainCharacter.size.height + 5) {
        _force.dy = 0;
    }
    
    //Pass the fixed Position in X axys
    if (mainPosition.x > self.size.width/5.5 && _parallaxIsOn) {
        _force.dx = -1;
    }else if(mainPosition.x <= self.size.width/5.5 && _parallaxIsOn){
        _force.dx = 0;
        _mainCharacter.position = CGPointMake(self.size.width/5.5, _mainCharacter.position.y);
    }
    
    
}

-(void)moveLeft{
    
    if (_speed && _parallaxIsOn) {
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
    }
}


- (void)update:(CFTimeInterval)currentTime {

    
    if (_lastUpdatedTime) {
        _dt = currentTime - _lastUpdatedTime;
    }else{
        _dt = 0;
    }
    
    _lastUpdatedTime = currentTime;
    
    if (_speed==0) {
        [_mainCharacter removeAllActions];
        _force = CGVectorMake(0, -gravity().y);
        NSLog(@"Game Over");
        GameOverScene *scene = [[GameOverScene alloc]initWithSize:self.frame.size];
        [self.view presentScene:scene];
    }
    
    [self moveLeft];
    //If the game is paused, everything stop
    if (self.paused == NO) {
        [self timeShotInterval: currentTime];
        [self moveShot];
        
        [self timeItemInterval: currentTime];
        
        [self timeMarshmallowInterval:currentTime];
        
        [_parallax update:currentTime];
        
        if (_parallaxIsOn) {
            [self applyForce:0 dy:gravity().y];
        }
        
        _mainCharacter.position = CGPointMake(_mainCharacter.position.x + _force.dx, _mainCharacter.position.y + _force.dy);
    }

}

-(void)addFrenchFriesItem{
    CGFloat range = ScalarRandomRange(30, 90);
    
    _frenchFriesItem = [[FrenchFries alloc] initWithPosition:CGPointMake(self.size.width,
                                                            self.size.height*(range/100))];
    _frenchFriesItem.name = @"items";
    
    [self addChild:_frenchFriesItem];
    
}

-(void)addCottonCandyItem{
    
    CGFloat range = ScalarRandomRange(30, 90);
    
    _cottonCandyItem= [[CottonCandyNode alloc] initWithPosition:CGPointMake(self.size.width,
                                                                         self.size.height*(range/100))];
    _cottonCandyItem.name = @"items";
    
    [self addChild:_cottonCandyItem];
    
}

-(void)addIceCreamItem{
    
    CGFloat range = ScalarRandomRange(30, 90);
    
    _iceCreamItem = [[IceCreamNode alloc] initWithPosition:CGPointMake(self.size.width,
                                                                            self.size.height*(range/100))];
    _iceCreamItem.name = @"items";
    
    [self addChild:_iceCreamItem];
    
}



-(void)addMarshmallow{
    
    _marshmallow = [MarshmallowNode initWithPosition:CGPointMake(self.size.width,
                                                                 26.25)];
    _marshmallow.name = @"marshmallow";
    
    [self addChild:_marshmallow];

}




-(void)timeItemInterval: (CFTimeInterval)currentTime{
    
    
    if(_timeToNextFrenchFries - currentTime <= 0 && _parallaxIsOn){
        for (int cont = ScalarRandomRange(1, 4); cont>0; cont--) {
            [self addFrenchFriesItem];
       }
                
        _timeToNextFrenchFries = ScalarRandomRange(1, 2);
        _timeToNextFrenchFries+= currentTime;
    }
    
    if(_timeToNextCottonCandy - currentTime <= 0 && _parallaxIsOn){
        for ( int cont = ScalarRandomRange(1, 2); cont>0; cont--) {
            [self addCottonCandyItem];
        }
        
        _timeToNextCottonCandy= ScalarRandomRange(1, 10);
        _timeToNextCottonCandy+= currentTime+1;
    }
    
    if(_timeToNextIceCream - currentTime <= 0 && _parallaxIsOn){
        for (int cont = ScalarRandomRange(1, 2); cont>0; cont--) {
            [self addIceCreamItem];
       }
        
        _timeToNextIceCream = ScalarRandomRange(1, 10);
        _timeToNextIceCream+= currentTime+2;
    }


}

-(void)timeMarshmallowInterval: (CFTimeInterval)currentTime{

    if(_timeToNextMarshmallow - currentTime <=0 && _parallaxIsOn){
    
        for (int cont = ScalarRandomRange(1, 4); cont>=0; cont--) {
            [self addMarshmallow];
        }
        
        _timeToNextMarshmallow = ScalarRandomRange(1, 4);
        _timeToNextMarshmallow+=currentTime;
    }

}


-(void)timeShotInterval: (CFTimeInterval)currentTime{
    if (_timeToNextShot - currentTime <= 0 && _parallaxIsOn) {
        [self playShot];
        _timeToNextShot = ScalarRandomRange(5, 9);
        _timeToNextShot +=currentTime;
    }
}

-(void) didEvaluateActions{
    
    [self collisionCheck];
}



//Adding Images
-(void)pauseNode{
    _pause = [SKSpriteNode spriteNodeWithImageNamed:@"Pause_icon_status"];
    _pause.position = CGPointMake(self.size.width/1.1, self.size.height/1.13);
    _pause.name = @"pause";
    [_pause setScale:0.13];
    
   // [self addChild:_pause];
}

-(void)addScenario{
    //add sky
    SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"Sky"];
    bg.anchorPoint = CGPointZero;
    bg.position = CGPointZero;
    bg.zPosition = -1000;
    [self addChild:bg];
}

-(void)addBackgroundPaused{
    _backgroundPaused = [SKSpriteNode spriteNodeWithImageNamed:@"WhiteScreen"];
    _backgroundPaused.position = CGPointMake(self.size.width/2, self.size.height/2);
    
    [_backgroundPaused setScale:1.0];
    [self addChild:_backgroundPaused];
}


-(void)addEnemy{
    _enemy = [EnemyCharacterNode initWithPosition:CGPointZero];
    _enemy = [EnemyCharacterNode initWithPosition:
              CGPointMake(self.size.width-_enemy.size.width, _ground.position.y + _enemy.size.height)];
    [self addChild:_enemy];

}

-(void)addMainCharacter{
    _mainCharacter = [MainCharacterNode initWithPosition:
                      CGPointMake(self.size.width/5.5, self.size.height*0.7)];
    _mainCharacter.name = @"chubby";
    
    [self addChild:_mainCharacter];
    
}

-(void)addGround{
    _ground = [SKSpriteNode spriteNodeWithImageNamed:@"chaoParallax@2x"];
    _ground.anchorPoint = CGPointMake(0, .07);
    _ground.position = CGPointMake(0, _ground.size.height*.07);
    _ground.zPosition = -996;
    [self addChild:_ground];
}

-(void)addBuilding{
    _building = [SKSpriteNode spriteNodeWithImageNamed:@"Building"];
    _building.position = CGPointZero;
    _building.anchorPoint = CGPointZero;
    _building.zPosition = -999;
    //   [_building setScale:0.5];
    
    [self addChild:_building];
}

-(void)addTrampoline{
    _trampoline = [SKSpriteNode spriteNodeWithImageNamed:@"trampolim0000"];
    _trampoline.position = CGPointMake(self.size.width/3.5, self.size.height/4.5);
    [_trampoline setScale:0.6];
    _trampoline.zPosition = -998;
    [self addChild:_trampoline];
}

-(void)addBullet{
    
}

-(void)addTree{
    _tree = [SKSpriteNode spriteNodeWithImageNamed:@"Tree"];
    _tree.anchorPoint = CGPointMake(0.5, 0);
    _tree.position = CGPointMake(self.size.width*0.7, _ground.position.y);
    //[_tree setScale:0.45];
    _tree.zPosition = -997;
    [self addChild:_tree];
}

-(void) addPlayButton{
    _play = [SKSpriteNode spriteNodeWithImageNamed:@"play"];
    [_play setName:@"play"];
    [_play setAnchorPoint:CGPointZero];
    [_play setScale:2.0]; //0.05
    [_play setPosition:CGPointMake(-65 - _play.size.width,-27)];
    [_pauseScreen addChild:_play];
}



-(void)addLogo{
    _logo = [SKSpriteNode spriteNodeWithImageNamed:@"ChubbyLogo"];
    _logo.position = CGPointMake(self.size.width/2, self.size.height/1.2);
    //    [logo setScale:0.8];
    [self addChild:_logo];
}

-(void)addMensage{
    _mensage = [[SKLabelNode alloc]init];
    _mensage.fontSize = 45;
    _mensage.fontColor = [SKColor redColor];
    _mensage.position = CGPointMake(self.size.width/1.4, self.size.height/10.13);
    _mensage.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    [_mensage setText:@"Tap to Play"];
    //    [_mensage runAction:[SKAction sequence:@[[SKAction fadeInWithDuration:0.5], [SKAction fadeOutWithDuration:1]]]]; //Piscando só uma vez
    [self addChild:_mensage];
}

///------------------------------------------------------------------

//Pause Part
//Play and Pause actions
-(void) playAction{
    [self pauseNode];
    [_pauseScreen removeFromParent];
    [_backgroundPaused removeFromParent];
    [_play removeFromParent];
}

-(void) pauseAction{
    self.paused = YES;
    [_pause removeFromParent];//Arrumar um jeito para funcionar
    [self addBackgroundPaused];
    [self actionEverythingUnFocus];//Arrumar --- Set the characters behind the pause screen -- bullet
    _pauseScreen = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    //Seta cor
    _pauseScreen.fillColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.70];
    [self addChild:_pauseScreen];
    _pauseScreen.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addPlayButton];
    [self addRestartButton];
    [self addMusicButton];

    //AddPauseLabel
    SKSpriteNode *_pauseLabel  = [SKSpriteNode spriteNodeWithImageNamed:@"Pause"];
    [_pauseLabel setScale:0.85];
    _pauseLabel.zPosition = 1;
    [_pauseLabel setPosition:CGPointMake(85 - _pauseLabel.size.width,80)];
    [_pauseScreen addChild:_pauseLabel];

}

-(void)addRestartButton{
    _restart = [SKSpriteNode spriteNodeWithImageNamed:@"restart"];//Mudar para o símbolo de restart
    [_restart setName:@"restart"];
    [_restart setScale:1.5];
    [_restart setPosition:CGPointMake(0 - _restart.size.width/77,5)];
    [_pauseScreen addChild:_restart];
}


//Music Methods -----------------------------------
-(void)stopMusic{
    [_audio pause];
    [_musicButton removeFromParent];
    _musicButton = [SKSpriteNode spriteNodeWithImageNamed:@"mute"];
    [_musicButton setScale:1.0];
    _musicButton.position = CGPointMake(self.size.width/1.1, self.size.height/1.13);
    [_musicButton setName:@"music"];
    [self addChild:_musicButton];
}



-(void)playMusic{
    [_audio play];
    [_musicButton removeFromParent];
    _musicButton = [SKSpriteNode spriteNodeWithImageNamed:@"music"];
    [_musicButton setScale:1.0];
    _musicButton.position = CGPointMake(self.size.width/1.1, self.size.height/1.13);
    [_musicButton setName:@"music"];
    [self addChild:_musicButton];
}

-(void)playStopMusic{
    if (_audio.isPlaying) {
        [self stopMusic];
    }else{
        [self playMusic];
    }
}

//-------Pause Part
-(void)stopPauseMusic{
    if (_audio.isPlaying) {
        [self stopMusicActionPause];
    }else{
        [_audio play];
        [_musicButton removeFromParent];
        [self addMusicButton];
    }
}

-(void)stopMusicActionPause{
    [_audio pause];
    [_musicButton removeFromParent];
    _musicButton = [SKSpriteNode spriteNodeWithImageNamed:@"mute"];
    [_musicButton setName:@"music"];
    [_musicButton setAnchorPoint:CGPointZero];
    [_musicButton setScale:2.0];
    [_musicButton setPosition:CGPointMake(60 - _musicButton.size.width/25, -25)];
    _musicButton.zPosition = 0.7;
    [_pauseScreen addChild:_musicButton];
}


-(void)addMusicButton{
    _musicButton = [SKSpriteNode spriteNodeWithImageNamed:@"music"];
    [_musicButton setName:@"music"];
    [_musicButton setAnchorPoint:CGPointZero];
    [_musicButton setScale:2.0];
    [_musicButton setPosition:CGPointMake(60 - _musicButton.size.width/25, -25)];
    _musicButton.zPosition = 0.7;
    [_pauseScreen addChild:_musicButton];
}
-(void)addMusicIcon{
    _musicButton = [SKSpriteNode spriteNodeWithImageNamed:@"music"];
    [_musicButton setName:@"music"];
    _musicButton.position = CGPointMake(self.size.width/1.1, self.size.height/1.13);
    [_musicButton setScale:1.0];
    [self addChild:_musicButton];
}

-(void)addMusic{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"Flaws" ofType:@"mp3"]];
    _audio = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _audio.numberOfLoops = -1;
    [_audio play];

}

//-------------------------------------------------
-(void)addExit{
    _exit = [SKSpriteNode spriteNodeWithImageNamed:@"quit"];
    [_exit setName:@"exit"];
    _exit.position = CGPointMake(self.size.width/1.1, self.size.height/1.43);
    [_exit setScale:1.0];
    [self addChild:_exit];
}


@end
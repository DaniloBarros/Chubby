//
//  GameScene.m
//  Chubby
//
//  Created by Ludimila da Bela Cruz on 13/04/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import <Chartboost/Chartboost.h>
#import "GameScene.h"
#import "GameController.h"
#import "MainCharacterNode.h"
#import "EnemyCharacterNode.h"
#import "PBParallaxScrolling.h"
#import "GameViewController.h"
#import "GameOverScene.h"
#import "Bullet.h"
#import "MarshmallowNode.h"
#import "TutorialScene.h"
#import "CottonCandyNode.h"
#import "FrenchFries.h"
#import "IceCreamNode.h"
#import "ScoreData.h"
#import "MusicBackground.h"

//#define MAX_IMPULSE 100.0
#define ARC4RANDOM_MAX  0x100000000
#define SUPER_FALL 7
#define NATURAL_FALL 0.4


static const float SHOT_MOVE_POINTS_PER_SEC = 300;

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
    GameController *_controller;
    
    MainCharacterNode *_mainCharacter;
    EnemyCharacterNode *_enemy;
    FrenchFries *_frenchFriesItem;
    IceCreamNode *_iceCreamItem;
    CottonCandyNode *_cottonCandyItem;
    
    MarshmallowNode *_marshmallow;
    
    SKLabelNode *_scoreLabel;
    SKLabelNode *_fries;
    
    float _highScore;
    float _score;
    int _frenchFriesPoint;
    
    SKSpriteNode *_trampoline;
    SKSpriteNode *_pipeTank;
    
    Bullet *_bullet;
    
    
    SKSpriteNode *_bulletCollision;
    SKSpriteNode *_bulletCopy;
    SKSpriteNode *_ground;
    SKSpriteNode *_tree;
    SKSpriteNode *_building;
    
    SKSpriteNode *_skinnyEating;
    SKSpriteNode *_branch;
    
    SKTexture *_idCandy;
    SKTexture *_idFrenchFries;
    SKTexture *_idIceCream;
    
    SKAction *_mainAction;
    
    BOOL _first, _parallaxIsOn, _musicSound;
    BOOL _isImmune;
    
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
    
    CGPoint _bgLastPosition;
    
    SKShapeNode *_pauseScreen;
    SKLabelNode *_mensage;

    SKSpriteNode *_backgroundPaused;
    
    SKSpriteNode *_logo;
    
    SKSpriteNode *_restart;
    SKSpriteNode *_tutorial;
    
    MusicBackground *t;
}

-(id)initWithSize:(CGSize)size{
        
        if(self = [super initWithSize:size]){
            t = [MusicBackground sharedInstance];
            
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
            //add skinny
            [self addSkinnyInTree];
            
            
            _scoreLabel = [[SKLabelNode alloc] init];
            _scoreLabel.fontSize = 18;
            _scoreLabel.fontColor = [SKColor blackColor];
            _scoreLabel.position = CGPointMake(10, self.size.height - 20);
            _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
            
            
            
            _fries = [[SKLabelNode alloc] init];
            _fries.fontSize = 18;
            _fries.fontColor = [SKColor blackColor];
            _fries.position = CGPointMake(_scoreLabel.position.x, _scoreLabel.position.y - _scoreLabel.fontSize );
            _fries.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
            
            
            
//-----------------------------------
            
            if ([ScoreData sharedGameData].sound) {
                [t.musicBgd play];
            }else{
                [t.musicBgd stop];
            }
            
            //AddMusic
            [self addMusicIcon];
            
            //AddTutorial
            [self addTutorial];
//-----------------------------------
            _impulsePlus = 0;
            _first = YES;
            _imageParallax = @[@"chaoParallax@2x",
                               @"arvoreParallax@2x",
                               @"NuvemParallax@2x"];
            _parallaxIsOn = NO;
            
            _speed = 17;
            _force = CGVectorMake(0, 0);
            _score = 0;
            
            _isImmune = NO;
            
            
            //Chama dados highscore
            _highScore = [ScoreData sharedGameData].highScore;
            //_audio.isPlaying  = [ScoreData sharedGameData].sound;
            _frenchFriesPoint = [ScoreData sharedGameData].fries;
            
            [_scoreLabel setText:[NSString stringWithFormat:@"Score: %.1f",0.0]];
            [_fries setText:[NSString stringWithFormat:@"Fries: %d",_frenchFriesPoint]];
            
            [[GameController sharedInstance] setDidDisplayAd:NO];
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
    if (_musicButton) {
        [_musicButton removeFromParent];
    }
    
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
    
    CGPoint direction = CGPointNormalize(offset);
    
    CGPoint velocity = CGPointMultiplyScalar(direction, SHOT_MOVE_POINTS_PER_SEC);
    
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
//            [t.musicBgd stop];
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
    }else if ([node.name isEqualToString:@"tutorial"]){
        [self goTutorial];
    }else{
        [self fall:_first];
        [_mensage removeFromParent];
        [_tutorial removeFromParent];
    }
}

-(void)goTutorial{
    TutorialScene *scene = [[TutorialScene alloc]initWithSize:self.frame.size];
    [self.view presentScene:scene];
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
    
    //Move and check collision in ITENS
    
    if(!self.paused){
        
        [self enumerateChildNodesWithName:@"marshmallow" usingBlock:^(SKNode *node, BOOL *stop){
            
            SKSpriteNode *marshmallow = (SKSpriteNode *)node;
            marshmallow.position = CGPointMake(marshmallow.position.x - _speed, marshmallow.position.y);
            
            if (CGRectIntersectsRect(marshmallow.frame, _mainCharacter.frame)) {
                [self applyForce:0.0 dy:.3];
                SKAction *flyBack = [SKAction repeatActionForever:[_mainCharacter flyAnimation]];
                SKAction *immuneYES = [SKAction runBlock:^{
                    _isImmune = YES;
                }];
                
                SKAction *immuneNO = [SKAction runBlock:^{
                    _isImmune = NO;
                }];
                SKAction *sequence = [SKAction sequence:@[immuneYES, [SKAction waitForDuration:0.51], immuneNO, flyBack]];
                [_mainCharacter runAction:sequence];
                
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
                    _frenchFriesPoint++;
                    
                    [_fries setText:[NSString stringWithFormat:@"Fries: %d", _frenchFriesPoint]];
                    
                    //NSLog(@"%d",_frenchFriesPoint);
                }
                
                item.name = @"";
                [item removeAllActions];
                [item removeFromParent];
                
            }
        }];
        
    }
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
                
                if((_speed-7)>0)
                    _speed -= 7;
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

        
        
        //Gambiarra
        _bgLastPosition = CGPointMake(1304, 0);
        
        [self addEnemy];
        
        [self addChild:_scoreLabel];
        [self addChild:_fries];
        
        
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
            if((_speed-7)>0)
                _speed -= 7;
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
        if(_logo){
          _logo.position = CGPointMake(_logo.position.x - _speed, _logo.position.y);
        }
        if (_skinnyEating) {
            _skinnyEating.position = CGPointMake(_skinnyEating.position.x - _speed, _skinnyEating.position.y);
        }
        if (_branch) {
            _branch.position = CGPointMake(_branch.position.x - _speed, _branch.position.y);
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
    
    //-------------GameOver Condition
    
    if (_speed==0 && ![[GameController sharedInstance] didDisplayAd]) {
        
        [_mainCharacter removeAllActions];
        
        _force = CGVectorMake(0, -gravity().y);
        _parallaxIsOn = NO;
        self.paused = YES;
        
        _highScore = MAX(_highScore, _score);
        
        //-----------Advertising
        
        NSNumber *goTimes = [[GameController sharedInstance] gameOverTimes];
        
        [[GameController sharedInstance] setGameOverTimes:@([goTimes intValue]+1)];
        
        NSLog(@"GAMEOVER %d, Display Ad %d , Dismissed %d",[goTimes intValue], [[GameController sharedInstance] didDisplayAd], [[GameController sharedInstance] didDismissedAd]);
        
        
        if ([goTimes intValue] >= 1 && ![[GameController sharedInstance]didDismissedAd]) {
            
            BOOL reward = NO;
            float f = ScalarRandomRange(0, 100);
            
            NSLog(@"CONDICAO REWARD %d %@ %f",[[GameController sharedInstance] didDismissedAd], [[GameController sharedInstance] watchedReward], f );
            
            if (f < 15 && ![[GameController sharedInstance] didDismissedAd] && [[[GameController sharedInstance] watchedReward] intValue] < 2) {
                
                reward = YES;
                
                if ([[[GameController sharedInstance] watchedReward] intValue] == 0) {
                    [Chartboost showRewardedVideo:CBLocationMainMenu];
                    [[GameController sharedInstance] setDidDisplayAd:YES];
                }
                
                if ([[[GameController sharedInstance] watchedReward] intValue] == 1) {
                    
                    NSLog(@"Volta a voar gordo");
                    
                    self.paused = NO;
                    
                    _force = CGVectorMake(0, gravity().y);
                    [self launch];
                    
                    _speed = 17;
                    [_parallax editSpeeds:_speed andSpeedDecrease:kPBParallaxBackgroundDefaultSpeedDifferential];
                    _parallaxIsOn = YES;
                    
                    _isImmune = NO;
                    _mainCharacter.hidden = NO;
                    
                    
                    [[GameController sharedInstance] setWatchedReward:@2];
                    [[GameController sharedInstance] setDidDismissedAd:YES];
                    
                }
            }
            
            if ([goTimes intValue]%3==0 && [[[GameController sharedInstance] watchedReward] intValue] == 0) {
                
                NSLog(@"Else GameOver");
                [Chartboost showInterstitial:@"play"];
                
            }
            
        }
        
        
        
        //-----------ENDAdvertising
        BOOL videoNotPending = ([[[GameController sharedInstance] watchedReward] intValue] == 0 || [[[GameController sharedInstance] watchedReward] intValue] == 2);
        
        NSLog(@"Display Ad %d VideoPending %d %d",[[GameController sharedInstance] didDisplayAd], videoNotPending, [[[GameController sharedInstance] watchedReward] intValue]);
        
        if (!_speed && videoNotPending && ![[GameController sharedInstance] didDisplayAd] ) {
            
            NSLog(@"--------------GameOver Scene");
            
            [[GameController sharedInstance] setDidDismissedAd:NO];
            [[GameController sharedInstance] setWatchedReward:@0];
            
            [[ScoreData sharedGameData] setHighScore:_highScore];
            [[ScoreData sharedGameData] setFries:_frenchFriesPoint];
            [[ScoreData sharedGameData] setSound:t.musicBgd.isPlaying];
            [[ScoreData sharedGameData] save];
            
            GameOverScene *scene = [[GameOverScene alloc]initWithSize:self.frame.size andScore:_score];
            [self.view presentScene:scene];
        }

    }
    
    //If the game is paused, everything stop
    if (self.paused == NO) {
        [self moveLeft];
        [self timeShotInterval: currentTime];
        [self moveShot];
        
        [self timeItemInterval: currentTime];
        
        [self timeMarshmallowInterval:currentTime];
        
        [_parallax update:currentTime];
        
        if (_parallaxIsOn) {
            if (_bgLastPosition.x >= 0) {
                //0.02267 = 1.70 / 75
                // 1.70 altura gordinho
                //75 heigth gordinho
                //NSLog(@"Positivo %f %f %f", _bgLastPosition.x, [_parallax bg1].position.x, (_bgLastPosition.x - [_parallax bg1].position.x));
                
                _score += (_bgLastPosition.x - [_parallax bg1].position.x)*0.02267;
                _bgLastPosition = [_parallax bg1].position;
            }else{
                
                float lastX = _bgLastPosition.x + (_bgLastPosition.x * -1)*2;
                float x = [_parallax bg1].position.x * -1;//[_parallax bg1].position.x + ([_parallax bg1].position.x * -1)*2;
                float sum = (x - lastX )*0.02267;
                
                if (sum < 0) {
                    sum *= -1;
                }
                
                _score += sum;
                
                //NSLog(@"%f %f", _bgLastPosition.x, [_parallax bg1].position.x);
                //NSLog(@"Negativo %f %f %f", x, lastX, x - lastX);
                
                _bgLastPosition = [_parallax bg1].position;
            }
            
            [_scoreLabel setText:[NSString stringWithFormat:@"Score: %.1f",_score]];
            //NSLog(@"%.1f %lf",_score, _bgLastPosition.x);
        }
        
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
    if (_timeToNextShot - currentTime <= 0 && [_enemy.name isEqualToString:@"enemy"]) {
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
    _pause = [SKSpriteNode spriteNodeWithImageNamed:@"pauseSymbol"];
    _pause.position = CGPointMake(self.size.width/1.1, self.size.height/1.13);
    _pause.name = @"pause";
    [_pause setScale:1.0];
    
    [self addChild:_pause];
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
    _backgroundPaused.zPosition += 10;

    [self addChild:_backgroundPaused];
}


-(void)addEnemy{
    _enemy = [EnemyCharacterNode initWithPosition:CGPointZero];
    _enemy = [EnemyCharacterNode initWithPosition:
              CGPointMake(self.size.width + _enemy.size.width, _ground.position.y + _enemy.size.height)];
    
    SKAction *name = [SKAction runBlock:^{
        
        [_enemy setName:@"enemy"];
        
    }];
    
    SKAction *move = [SKAction moveByX: - (_enemy.self.size.width*2) y:0 duration:1.0];
    SKAction *sequence = [SKAction sequence:@[[SKAction waitForDuration:1], move, name]];
    //[_enemy runAction:sequence];
    
    [self addChild:_enemy];
    [_enemy runAction:sequence];
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
    _play.zPosition += 10;
    [_pauseScreen addChild:_play];
}

-(void)addSkinnyInTree{

    _skinnyEating = [SKSpriteNode spriteNodeWithImageNamed:@"magrelo"];
    _branch = [SKSpriteNode spriteNodeWithImageNamed:@"Branch"];

    _skinnyEating.anchorPoint = CGPointMake(0.5, 0);
    _branch.anchorPoint = CGPointMake(0.5, 0);
    
    [_skinnyEating setScale:0.5];
    [_branch setScale:1.5];
    
    _skinnyEating.position = CGPointMake(self.size.width*0.7, _tree.position.y*6.8);
    _branch.position = CGPointMake(self.size.width*0.68, _tree.position.y*6.5);
    
    [self addChild:_skinnyEating];
    [self addChild:_branch];

}

-(void)addLogo{
    _logo = [SKSpriteNode spriteNodeWithImageNamed:@"ChubbyLogo"];
    _logo.position = CGPointMake(self.size.width/2, self.size.height/1.2);
    //    [logo setScale:0.8];
    [self addChild:_logo];
}

-(void)addMensage{
//    _mensage = [[SKLabelNode alloc]initWithFontNamed:@"Rebbiya"];
    _mensage = [[SKLabelNode alloc]init];
    _mensage.fontSize = 25;
    _mensage.fontColor = [SKColor blackColor];
    _mensage.position = CGPointMake(self.size.width/4.4, self.size.height/1.13);
    _mensage.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    _mensage.text = [NSString stringWithFormat:@"Tap To Play"];
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
    
    int z = 10;
    
    self.paused = YES;

    [_pause removeFromParent];
    [self addBackgroundPaused];
    [self actionEverythingUnFocus];//Arrumar --- Set the characters behind the pause screen -- bullet
    _pauseScreen = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    //Seta cor
    _pauseScreen.fillColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.70];
    _pauseScreen.zPosition += z;
    [self addChild:_pauseScreen];
    _pauseScreen.position = CGPointMake(self.size.width/2, self.size.height/2);
    
    [self addPlayButton];
    [self addRestartButton];
    [self addMusicButton];

    //AddPauseLabel
    SKSpriteNode *_pauseLabel  = [SKSpriteNode spriteNodeWithImageNamed:@"Pause"];
    [_pauseLabel setScale:0.85];
    _pauseLabel.zPosition = 1 + z;
    [_pauseLabel setPosition:CGPointMake(85 - _pauseLabel.size.width,80)];
    [_pauseScreen addChild:_pauseLabel];

}

-(void)addRestartButton{
    _restart = [SKSpriteNode spriteNodeWithImageNamed:@"restart"];//Mudar para o símbolo de restart
    [_restart setName:@"restart"];
    [_restart setScale:1.5];
    [_restart setPosition:CGPointMake(0 - _restart.size.width/77,5)];
    _restart.zPosition += 10;
    [_pauseScreen addChild:_restart];
}


//Music Methods -----------------------------------

-(SKSpriteNode*)symbolMusic{
    if(t.musicBgd.playing){
        _musicButton = [SKSpriteNode spriteNodeWithImageNamed:@"music"];
    }else{
        _musicButton = [SKSpriteNode spriteNodeWithImageNamed:@"mute"];
    }
    return _musicButton;
}

-(void)stopMusic{
    [t.musicBgd stop];
    [_musicButton removeFromParent];
    _musicButton = [SKSpriteNode spriteNodeWithImageNamed:@"mute"];
    [_musicButton setScale:1.0];
    _musicButton.position = CGPointMake(self.size.width/1.1, self.size.height/1.13);
    [_musicButton setName:@"music"];
    [self addChild:_musicButton];
}



-(void)playMusic{
    [t.musicBgd play];
    [_musicButton removeFromParent];
    _musicButton = [SKSpriteNode spriteNodeWithImageNamed:@"music"];
    [_musicButton setScale:1.0];
    _musicButton.position = CGPointMake(self.size.width/1.1, self.size.height/1.13);
    [_musicButton setName:@"music"];
    [self addChild:_musicButton];
}

-(void)playStopMusic{
    if (t.musicBgd.playing) {
        [self stopMusic];
    }else{
        [self playMusic];
    }
}

//-------Pause Part
-(void)stopPauseMusic{
//    _musicSound = NO;
    if (t.musicBgd.playing) {
        [self stopMusicActionPause];
    }else{
        [t.musicBgd play];
        [_musicButton removeFromParent];
        [self addMusicButton];
    }
    
    [[ScoreData sharedGameData] setSound:t.musicBgd.isPlaying];
    [[ScoreData sharedGameData] save];
    
}

-(void)stopMusicActionPause{
    [t.musicBgd stop];
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
    _musicButton = [self symbolMusic];
    [_musicButton setName:@"music"];
    [_musicButton setAnchorPoint:CGPointZero];
    [_musicButton setScale:2.0];
    [_musicButton setPosition:CGPointMake(60 - _musicButton.size.width/25, -25)];
    _musicButton.zPosition = 0.7 + 10;
    [_pauseScreen addChild:_musicButton];
}
-(void)addMusicIcon{
    _musicButton = [self symbolMusic];

    [_musicButton setName:@"music"];
    _musicButton.position = CGPointMake(self.size.width/1.1, self.size.height/1.13);
    [_musicButton setScale:1.0];
    [self addChild:_musicButton];
}

//-------------------------------------------------
-(void)addTutorial{
    _tutorial = [SKSpriteNode spriteNodeWithImageNamed:@"TutorialSymbol"];
    [_tutorial setName:@"tutorial"];
    _tutorial.position = CGPointMake(self.size.width/1.1, self.size.height/1.43);
    [_tutorial setScale:0.05];
    [self addChild:_tutorial];
}


@end
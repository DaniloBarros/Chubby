//
//  GamePauseScene.m
//  Chubby
//
//  Created by Luan Lima on 4/22/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "GamePauseScene.h"
#import "GameViewController.h"

@implementation GamePauseScene
{
    SKSpriteNode *_play;
    SKShapeNode *_pauseScreen;
    SKSpriteNode *_musicButton;
    AVAudioPlayer *_audio;
    SKSpriteNode *_backgroundPaused;
}


//-(id)initWithSize:(CGSize)size{
//  //Pause Method
//        self.paused = YES;
//        [_pause removeFromParent];
//        [self addStopDeadBackground];
//        //Set the characters behind the pause screen
//        [self actionEverythingUnFocus];
//        _pauseScreen = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
//        //Seta cor
//        _pauseScreen.fillColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.70];
//        [self addChild:_pauseScreen];
//        _pauseScreen.position = CGPointMake(self.size.width/2, self.size.height/2);
//        [self addPlayButton];
//        [self addMusicButton];
//    
//    
//    self = [super initWithSize:size];
//    if (self) {
//        
//        //Parte Adiciona BackGround na tela
//        
//        // Parte Manipula para mostrar o HighScore
//        
//        //Parte que manipula para mostrar o Score feito pelo personagem naquele momento
//        
//        [self addPlayButton];
//        [self addMusicButton];
//        [self addRestartButton];
//        [self addQuitButton];
//    }
//    return self;
//}
//
//
////Add Buttons methods
//-(void)addPlayButton{
//    _play = [SKSpriteNode spriteNodeWithImageNamed:@"PlaySimbol"];
//    [_play setName:@"play"];
//    [_play setAnchorPoint:CGPointZero];
//    [_play setScale:0.1]; //0.05
//    [_play setPosition:CGPointMake(0 - _play.size.width,0)];
//    [_pauseScreen addChild:_play];
//}
//
//-(void)addMusicButton{
//    
//}
//
//-(void)addRestartButton{
//    
//}
//
//-(void)addQuitButton{
//    
//}
//
//
////Add Buttons actions
//-(void) playAction{
////    [self pauseNode];
//    [_pauseScreen removeFromParent];
//    [_backgroundPaused removeFromParent];
//    [_play removeFromParent];
//    
//}
//
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    for (UITouch *touche in touches) {
//        _inicio = [touche locationInNode:self];
//        SKSpriteNode *node = (SKSpriteNode*)[self nodeAtPoint:_inicio];
//        if ([node.name isEqualToString:@"play"]) {
//            [self playAction];
//            self.paused = NO;
//        }
//    }
//}
//
//
//
////Future Good Methods
//-(void)stopMusic{
//    [_audio pause];
//}
//
//-(void)playMusic{
//    [_audio play];
//}

@end

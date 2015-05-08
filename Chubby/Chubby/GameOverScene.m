//
//  GameOverScene.m
//  Chubby
//
//  Created by Luan Lima on 4/22/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "GameOverScene.h"
#import "GameController.h"
#import "GameScene.h"
#import "ScoreData.h"

@implementation GameOverScene
{
    float _score;
}

-(id)initWithSize:(CGSize)size andScore:(float)score{
    self = [super initWithSize:size];
    if (self) {
        
        _score = score;
    
        [self addBackgroundGameOver];
        // Parte do HighScore
        //Parte feita de pontos até ele morrer
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    SKNode *node = [self nodeAtPoint:[touch locationInNode:self]];
    if ([node.name isEqualToString:@"restart"]) {
        GameScene *scene = [[GameScene alloc]initWithSize:self.frame.size];
        [self.view presentScene:scene];
    }
}


-(void)addBackgroundGameOver{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"WhiteScreen"];
    background.position = CGPointMake(self.size.width/2, self.size.height/2);
    [background setScale:1.45];
    [background addChild:[self addRestartButton]];
    [background addChild:[self addHighScoreLabel]];
    [background addChild:[self addLastScoreLabel]];
    [background addChild:[self addGameOverLabel]];
    [self addChild:background];
    
}


//Adiciona plano de fundo e os botões e as Labels
-(SKSpriteNode*)addHighScoreLabel{
    SKSpriteNode *_scoreLabel = [SKSpriteNode spriteNodeWithImageNamed:@"score"];
    SKLabelNode *_label = [[SKLabelNode alloc]init];
    
    float highscore = [[ScoreData sharedGameData] highScore];
    
    [_label setText:[NSString stringWithFormat:@"%.1f", highscore]];//Chamar para calcular Score
    
    _label.fontColor = [SKColor blackColor];
    
    [_label setPosition:CGPointMake(375, 115)];
    [self addChild:_label];
    _scoreLabel.zPosition = 1;
    _scoreLabel.position = CGPointMake(85 - _scoreLabel.size.width,-65);
    [_scoreLabel setScale:0.6];
    return _scoreLabel;
}

-(SKSpriteNode*)addLastScoreLabel{
    SKSpriteNode *_highScore = [SKSpriteNode spriteNodeWithImageNamed:@"HighScore"];
    SKLabelNode *_label = [[SKLabelNode alloc]init];
    _label.fontColor = [SKColor blackColor];
    [_label setPosition:CGPointMake(375, 85)];
    
    [_label setText:[NSString stringWithFormat:@"%.1f",_score]];//Chamar para calcular Score
    [self addChild:_label];
    _highScore.position = CGPointMake(self.size.width/35.5, self.size.height/25.5);
    [_highScore setScale:0.6];
    _highScore.zPosition = 1;
    [_highScore setPosition:CGPointMake(55 - _highScore.size.width,-45)];
    return _highScore;
}


-(SKSpriteNode*)addGameOverLabel{
    SKSpriteNode *_gameOver = [SKSpriteNode spriteNodeWithImageNamed:@"GameOver"];
    _gameOver.position = CGPointMake(self.size.width/35.5, self.size.height/25.5);
    [_gameOver setScale:0.85];
    _gameOver.zPosition = 1;
    [_gameOver setPosition:CGPointMake(160 - _gameOver.size.width,80)];
    return _gameOver;
}


//-------Buttons na tela

-(SKNode*)addRestartButton{
    SKSpriteNode *_restart = [SKSpriteNode spriteNodeWithImageNamed:@"restart"];
    [_restart setName:@"restart"];
    [_restart setScale:1.0];
    _restart.zPosition = 1;
    [_restart setPosition:CGPointMake(35 - _restart.size.width,9)];
    return _restart;
}

@end
//
//  GameOverScene.m
//  Chubby
//
//  Created by Luan Lima on 4/22/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "GameOverScene.h"
#import "GameScene.h"

@implementation GameOverScene

-(id)initWithSize:(CGSize)size{
    self = [super initWithSize:size];
    if (self) {
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
    }else if ([node.name isEqualToString:@"quit"]){
        exit(0);
    }
}


-(void)addBackgroundGameOver{
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"WhiteScreen"];
    background.position = CGPointMake(self.size.width/2, self.size.height/2);
    [background setScale:1.45];
    [background addChild:[self addRestartButton]];
    [background addChild:[self addHighScoreLabel]];
    [background addChild:[self addLastScoreLabel]];
    [background addChild:[self addQuitButton]];
    [background addChild:[self addGameOverLabel]];
    [self addChild:background];
}


//Adiciona plano de fundo e os botões e as Labels
-(SKSpriteNode*)addHighScoreLabel{
    SKSpriteNode *_scoreLabel = [SKSpriteNode spriteNodeWithImageNamed:@"HighScore"];//Vai ser trocado por Score
    SKLabelNode *_label = [[SKLabelNode alloc]init];
    [_label setText:@"---m"];//Chamar para calcular Score
    [_label setPosition:CGPointMake(390, 115)];
    [self addChild:_label];
    _scoreLabel.zPosition = 1;
    _scoreLabel.position = CGPointMake(130 - _scoreLabel.size.width,-65);
    [_scoreLabel setScale:0.6];
    return _scoreLabel;
}

-(SKSpriteNode*)addLastScoreLabel{
    SKSpriteNode *_highScore = [SKSpriteNode spriteNodeWithImageNamed:@"HighScore"];
    SKLabelNode *_label = [[SKLabelNode alloc]init];
    [_label setText:@"---n"];//Chamar para calcular Score
    [_label setPosition:CGPointMake(390, 85)];
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
-(SKNode*)addQuitButton{
    SKSpriteNode *_quit = [SKSpriteNode spriteNodeWithImageNamed:@"Quit"];//Mudar para o símbolo de restart
    [_quit setName:@"quit"];
    [_quit setScale:1.0];
    _quit.zPosition = 1;
    [_quit setPosition:CGPointMake(-50 - _quit.size.width,9)];
    return _quit;
}

-(SKNode*)addRestartButton{
    SKSpriteNode *_restart = [SKSpriteNode spriteNodeWithImageNamed:@"restart"];
    [_restart setName:@"restart"];
    [_restart setScale:1.0];
    _restart.zPosition = 1;
    [_restart setPosition:CGPointMake(100 - _restart.size.width,9)];
    return _restart;
}

@end
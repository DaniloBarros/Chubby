//
//  TutorialScene.m
//  Chubby
//
//  Created by Luan Lima on 4/24/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "TutorialScene.h"
#import "GameScene.h"

@implementation TutorialScene
- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"inicioTutorial"];
        bg.anchorPoint = CGPointZero;
        bg.position = CGPointMake(0, 20);
        bg.zPosition = -1000;
        [self addChild:bg];
    }
    return self;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:1.0];
    SKScene * nextScene = [[NextTutorial alloc] initWithSize:self.size];
    [self.view presentScene:nextScene transition: reveal];
}

@end


@implementation NextTutorial
- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"FallTutorial"];
        bg.anchorPoint = CGPointZero;
        bg.position = CGPointMake(0, 20);
        bg.zPosition = -1000;
        [self addChild:bg];
        
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:1.0];
    SKScene * nextScene = [[NextTutorial1 alloc] initWithSize:self.size];
    [self.view presentScene:nextScene transition: reveal];
}

@end


@implementation NextTutorial1
- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"MarshTutorial"];
        bg.anchorPoint = CGPointZero;
        bg.position = CGPointMake(0, 20);
        bg.zPosition = -1000;
        [self addChild:bg];
        
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:1.0];
    SKScene * nextScene = [[NextTutorial2 alloc] initWithSize:self.size];
    [self.view presentScene:nextScene transition: reveal];
}

@end


@implementation NextTutorial2
- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"BatataTutorial"];
        bg.anchorPoint = CGPointZero;
        bg.position = CGPointMake(0, 20);
        bg.zPosition = -1000;
        [self addChild:bg];
        
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:1.0];
    SKScene * nextScene = [[NextTutorial3 alloc] initWithSize:self.size];
    [self.view presentScene:nextScene transition: reveal];
}

@end

@implementation NextTutorial3
- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"ItemTutorial"];
        bg.anchorPoint = CGPointZero;
        bg.position = CGPointMake(0, 20);
        bg.zPosition = -1000;
        [self addChild:bg];
        
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:1.0];
    SKScene * nextScene = [[NextTutorial4 alloc] initWithSize:self.size];
    [self.view presentScene:nextScene transition: reveal];
}

@end

@implementation NextTutorial4
- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"SliceTutorial"];
        bg.anchorPoint = CGPointZero;
        bg.position = CGPointMake(0, 20);
        bg.zPosition = -1000;
        [self addChild:bg];
        
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:1.0];
    SKScene * nextScene = [[NextTutorial5 alloc] initWithSize:self.size];
    [self.view presentScene:nextScene transition: reveal];
}

@end

@implementation NextTutorial5
- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"LastImage"];
        bg.anchorPoint = CGPointZero;
        bg.position = CGPointMake(0, 20);
        bg.zPosition = -1000;
        [self addChild:bg];
        
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    SKTransition *reveal = [SKTransition flipHorizontalWithDuration:1.0];
    SKScene * nextScene = [[GameScene alloc] initWithSize:self.size];
    [self.view presentScene:nextScene transition: reveal];
}

@end
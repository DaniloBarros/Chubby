//
//  MainCharacterNode.h
//  Chubby
//
//  Created by Danilo Barros Mendes on 4/15/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MainCharacterNode : SKSpriteNode

+(id)initWithPosition:(CGPoint)position;
-(SKAction *)preJumpAnimation;
-(SKAction *)fallAnimation;
-(SKAction *)flyAnimation;
@end


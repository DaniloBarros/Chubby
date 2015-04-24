//
//  Bullet.h
//  Chubby
//
//  Created by Danilo Barros Mendes on 4/22/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Bullet : SKSpriteNode

@property (nonatomic) CGPoint target;

-(id)initWithPosition:(CGPoint)position andVelocity:(CGPoint)velocity;



@end

//
//  Bullet.m
//  Chubby
//
//  Created by Danilo Barros Mendes on 4/22/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "Bullet.h"

@implementation Bullet

-(id)initWithPosition:(CGPoint)position andVelocity:(CGPoint)velocity{
    
    self = [[Bullet alloc] initWithImageNamed:@"Bullet"];
    self.anchorPoint = CGPointMake(0.5, 0.5);
    self.position = position;
    [self setScale:0.4];
    self.name = @"bullet";
    
    NSNumber *x = [[NSNumber alloc] initWithDouble:velocity.x];
    NSNumber *y = [[NSNumber alloc] initWithDouble:velocity.y];
    NSMutableDictionary *targetD = [[NSMutableDictionary alloc]
                                    initWithObjects:@[x, y]
                                    forKeys:@[@"X", @"Y"]];
    
    [self setUserData:targetD];
    
    [self setTarget:velocity];
    
    return self;
    
}

-(void)setTarget:(CGPoint)velocity{
    NSNumber *x = [[NSNumber alloc] initWithDouble:velocity.x];
    NSNumber *y = [[NSNumber alloc] initWithDouble:velocity.y];
    NSMutableDictionary *targetD = [[NSMutableDictionary alloc]
                                    initWithObjects:@[x, y]
                                    forKeys:@[@"X", @"Y"]];
    
    [self setUserData:targetD];
    
}

@end

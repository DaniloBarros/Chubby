//
//  ScoreData.h
//  Chubby
//
//  Created by Danilo Barros Mendes on 4/24/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreData : NSObject <NSCoding>

//O score atual
@property (assign, nonatomic) int fries;

//O maior Score obtido
@property (assign, nonatomic) float highScore;

@property (assign, nonatomic) BOOL sound;

//Dará acesso a instancia de classe
+(instancetype)sharedGameData;
-(void) save;
-(void)reset;

@end

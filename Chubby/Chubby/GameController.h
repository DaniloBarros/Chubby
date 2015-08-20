//
//  GameController.h
//  Chubby
//
//  Created by Danilo Barros Mendes on 5/7/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScoreData.h"

@interface GameController : NSObject

@property (nonatomic) ScoreData *scoreData;

@property (nonatomic, retain) NSNumber *gameOverTimes;

@property (nonatomic, retain) NSNumber *watchedReward;

@property (nonatomic) BOOL didDisplayAd;

@property (nonatomic) BOOL didDismissedAd;

+(id)sharedInstance;

@end

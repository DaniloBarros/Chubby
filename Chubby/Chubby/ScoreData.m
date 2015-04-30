//
//  ScoreData.m
//  Chubby
//
//  Created by Danilo Barros Mendes on 4/24/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "ScoreData.h"

@implementation ScoreData

static NSString* const SSGameDataHighScoreKey = @"highScore";
static NSString* const SSGameDataSoundKey = @"sound";
static NSString* const SSGameDataFriesKey = @"fries";

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [self init];
    
    if (self) {
        _highScore = [aDecoder decodeDoubleForKey:SSGameDataHighScoreKey];
        _sound = [aDecoder decodeBoolForKey:SSGameDataSoundKey];
        _fries = [aDecoder decodeIntForKey:SSGameDataFriesKey];
    }
    return self;
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeDouble:self.highScore forKey:SSGameDataHighScoreKey];
    [aCoder encodeBool:self.sound forKey:SSGameDataSoundKey];
    [aCoder encodeInt:self.fries forKey:SSGameDataFriesKey];
}

+(instancetype)sharedGameData{
    
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [self loadInstance];
    });
    
    return sharedInstance;
}

+(NSString*)filePath{
    static NSString* filePath = nil;
    
    if (!filePath) {
        filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
                    stringByAppendingPathComponent:@"gamedata"];
    
    }
    
    return filePath;
    
}

+(instancetype)loadInstance{
    NSData *decodedData = [NSData dataWithContentsOfFile:[ScoreData filePath]];
    
    if(decodedData){
        ScoreData *gameData = [NSKeyedUnarchiver unarchiveObjectWithData:decodedData];
        
        return gameData;
    }
    
    return [[ScoreData alloc] init];
    
}

-(void)save{
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    [encodedData writeToFile:[ScoreData filePath] atomically:YES];
}

-(void)reset{
    self.fries = 0;
}

@end

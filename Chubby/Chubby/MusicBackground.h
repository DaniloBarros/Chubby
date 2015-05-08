//
//  MusicBackground.h
//  Chubby
//
//  Created by Luan Lima on 5/7/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface MusicBackground : AVAudioPlayer

@property(nonatomic,strong)AVAudioPlayer *musicBgd;

+ (id)sharedInstance;

@end

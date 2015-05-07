//
//  GameViewController.m
//  Chubby
//
//  Created by Ludimila da Bela Cruz on 13/04/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "GameOverScene.h"
#import "MusicBackground.h"

@interface GameViewController()
{
    AVAudioPlayer *_audio;
}
@end

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    MusicBackground *b = [MusicBackground sharedInstance];
    
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"Flaws" ofType:@"mp3"]];
    b.musicBgd = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    b.musicBgd.numberOfLoops = -1;
    [b.musicBgd play];
    
    SKView *skView = (SKView *)self.view;
    
    if(!skView.scene){
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        skView.ignoresSiblingOrder = YES;
        
        GameScene *scene = [GameScene sceneWithSize:CGSizeMake(667,375)];
        
        [skView presentScene:scene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end

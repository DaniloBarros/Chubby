//
//  AppDelegate.m
//  Chubby
//
//  Created by Ludimila da Bela Cruz on 13/04/15.
//  Copyright (c) 2015 MiniChallenge1. All rights reserved.
//

#import "AppDelegate.h"
#import "GameController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // initialize the Chartboost library
    
    //[Chartboost startWithAppId:@"4f21c409cd1cb2fb7000001b" appSignature:@"92e2de2fd7070327bdeb54c15a5295309c6fcd2d" delegate:self];
    
    //Chubby
    [Chartboost startWithAppId:@"554ba3a8c909a664e5642419" appSignature:@"50d47125b8c058d36a5edcf9e5fa96e8f56f8e06" delegate:self];
    
    // Show an interstitial ad
    //[Chartboost showInterstitial:CBLocationHomeScreen];
    
    // Show rewarded video pre-roll message and video ad at location MainMenu. See Chartboost.h for available location options.
    
    //[Chartboost showRewardedVideo:CBLocationMainMenu];
    
    return YES;
}

- (void)didFailToLoadRewardedVideo:(NSString *)location withError:(CBLoadError)error {
    switch(error){
        case CBLoadErrorInternetUnavailable: {
            NSLog(@"Failed to load Rewarded Video, no Internet connection !");
        } break;
        case CBLoadErrorInternal: {
            NSLog(@"Failed to load Rewarded Video, internal error !");
        } break;
        case CBLoadErrorNetworkFailure: {
            NSLog(@"Failed to load Rewarded Video, network error !");
        } break;
        case CBLoadErrorWrongOrientation: {
            NSLog(@"Failed to load Rewarded Video, wrong orientation !");
        } break;
        case CBLoadErrorTooManyConnections: {
            NSLog(@"Failed to load Rewarded Video, too many connections !");
        } break;
        case CBLoadErrorFirstSessionInterstitialsDisabled: {
            NSLog(@"Failed to load Rewarded Video, first session !");
        } break;
        case CBLoadErrorNoAdFound : {
            NSLog(@"Failed to load Rewarded Video, no ad found !");
        } break;
        case CBLoadErrorSessionNotStarted : {
            NSLog(@"Failed to load Rewarded Video, session not started !");
        } break;
        case CBLoadErrorNoLocationFound : {
            NSLog(@"Failed to load Rewarded Video, missing location parameter !");
        } break;
        default: {
            NSLog(@"Failed to load Rewarded Video, unknown error !");
        }
    }
    [[GameController sharedInstance] setDidDisplayAd:NO];
    [[GameController sharedInstance] setDidDismissedAd:YES];
    NSLog(@"Delegate displayAd %d", [[GameController sharedInstance] didDisplayAd]);
}

- (void)didDisplayRewardedVideo:(CBLocation)location{
    NSLog(@"Did display reward video");
    
    // We might want to pause our in-game audio, lets double check that an ad is visible
    if ([Chartboost isAnyViewVisible]) {
        // Use this function anywhere in your logic where you need to know if an ad is visible or not.
        NSLog(@"Pause audio");
    }
    
    [[GameController sharedInstance] setDidDisplayAd:YES];
}

- (void)didCompleteRewardedVideo:(CBLocation)location withReward:(int)reward {
    NSLog(@"Completed reward Video");
    [[GameController sharedInstance] setWatchedReward:@1];
}

-(void)didDismissRewardedVideo:(CBLocation)location{
    NSLog(@"Dismissed Reward Video");

    if ([[GameController sharedInstance] watchedReward] == 0) {
        NSLog(@"Set Dismissed reward");
            [[GameController sharedInstance] setDidDismissedAd:YES];
    }

    [[GameController sharedInstance] setDidDisplayAd:NO];
    //[[GameController sharedInstance] setWatchedReward:@0];
    
}

- (void)didFailToLoadInterstitial:(NSString *)location withError:(CBLoadError)error {
    switch(error){
        case CBLoadErrorInternetUnavailable: {
            NSLog(@"Failed to load Interstitial, no Internet connection !");
        } break;
        case CBLoadErrorInternal: {
            NSLog(@"Failed to load Interstitial, internal error !");
        } break;
        case CBLoadErrorNetworkFailure: {
            NSLog(@"Failed to load Interstitial, network error !");
        } break;
        case CBLoadErrorWrongOrientation: {
            NSLog(@"Failed to load Interstitial, wrong orientation !");
        } break;
        case CBLoadErrorTooManyConnections: {
            NSLog(@"Failed to load Interstitial, too many connections !");
        } break;
        case CBLoadErrorFirstSessionInterstitialsDisabled: {
            NSLog(@"Failed to load Interstitial, first session !");
        } break;
        case CBLoadErrorNoAdFound : {
            NSLog(@"Failed to load Interstitial, no ad found !");
        } break;
        case CBLoadErrorSessionNotStarted : {
            NSLog(@"Failed to load Interstitial, session not started !");
        } break;
        case CBLoadErrorNoLocationFound : {
            NSLog(@"Failed to load Interstitial, missing location parameter !");
        } break;
        default: {
            NSLog(@"Failed to load Interstitial, unknown error !");
        }
    }
    
    
    [[GameController sharedInstance] setDidDisplayAd:NO];
    NSLog(@"Delegate Interstitial displayAd %d", [[GameController sharedInstance] didDisplayAd]);
    
}



-(void)didDisplayInterstitial:(CBLocation)location{
    NSLog(@"Did display Interstitial video");
    [[GameController sharedInstance] setDidDisplayAd:YES];
}

-(void)didDismissInterstitial:(CBLocation)location{
    NSLog(@"Dismissed Interstitial");
    
    [[GameController sharedInstance] setDidDismissedAd:YES];
    [[GameController sharedInstance] setDidDisplayAd:NO];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

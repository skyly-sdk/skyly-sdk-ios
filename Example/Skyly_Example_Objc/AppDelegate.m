//
//  AppDelegate.m
//  Skyly_Example_Objc
//
//  Created by Philippe Auriach on 31/01/2022.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

#import "AppDelegate.h"

@import Skyly;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    Skyly.shared.apiKey = @"API_KEY";
    Skyly.shared.publisherId = @"PUB_ID";
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    OfferWallRequest *request = [[OfferWallRequest alloc] initWithUserId:@"YOUR_USER_ID"];
    
    request.zipCode = @"75017"; // optional
    request.userAge = @31; // optional
    request.userGender = GenderMale; // optional
    request.userSignupDate = [NSDate dateWithTimeIntervalSince1970:1643645866]; // optional
    request.callbackParameters = @[@"param0", @"param1"]; // optional
    
    [[Skyly shared] getOfferWallWithRequest:request completion:^(NSString * _Nullable error, NSArray<FeedElement *> * _Nullable offers) {       
        if (error) {
            NSLog(@"Error fetching OfferWall %@", error);
            return;
        }
        NSLog(@"OfferWall fetched %@", offers);
    }];
    
}

@end

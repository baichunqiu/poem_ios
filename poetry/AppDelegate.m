//
//  AppDelegate.m
//  poetry
//
//  Created by 白春秋 on 2019/9/24.
//  Copyright © 2019 qunlivideo. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //init windeow
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIApplication sharedApplication].statusBarHidden = YES;
    //通homevc
    UIViewController *homeVC = [[HomeViewController alloc] init];
    self.window.rootViewController = homeVC;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
  
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
  
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}


- (void)applicationWillTerminate:(UIApplication *)application {
   
}


@end

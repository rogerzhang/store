//
//  AppDelegate.m
//  TDDMZ
//
//  Created by Roger (Wei) Zhang on 8/1/16.
//  Copyright © 2016 Roger (Wei) Zhang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIImage *image = [UIImage imageNamed:@"flexible"];
    image = [image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [[UINavigationBar appearance] setBackgroundImage: image forBarMetrics: UIBarMetricsDefault];
    [[UINavigationBar appearance] setTintColor: [UIColor whiteColor]];
    
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];
    
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        NSString *errorMessage = nil;
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                errorMessage = @"网络不通";
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                break;
            }
            default:
                break;
        }
        
        if (errorMessage) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: nil message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
     
    return YES;
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

- (void) showProgressBar;
{
    if (self.progressHUD)
    {
        [self.progressHUD hide: NO];
    }
    
    UIView *view = self.window;
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo: view animated: YES];
    progressHUD.labelText = NSLocalizedString (@"加载信息中...", nil);
    self.progressHUD = progressHUD;
    [self.progressHUD show: YES];
}

- (void) hideProgressBar;
{
    [self.progressHUD hide: YES];
}

@end

//
//  AppDelegate.m
//  Vegas

#import "AppDelegate.h"
#import "KJDLoginViewController.h"
#import "InterfaceController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self setupApp:application];
    
    self.notifcationCenterArray = [[NSMutableArray alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"sendArrayToAppDel"
                                               object:nil];
    return YES;
}

- (void)setupApp:(UIApplication *)application
{
    KJDLoginViewController *initialVC = [[KJDLoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:initialVC];
    [self.window setRootViewController:navController];
}

//This is to communicate with Apple Watch
- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply{
    
    if ([[userInfo objectForKey:@"request"] isEqualToString:@"Hello"]) {
        
        NSLog(@"containing app received message from watch");
        //NSArray *testArray = @[@"Yo dude what up?", @"Nothing, You rock!!!"];
        NSDictionary *response = @{@"response" : self.notifcationCenterArray};
//                                   @"userName": self.userName};
        reply(response);
        NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
        
        [nc postNotificationName:@"dataToWatch" object:self userInfo:userInfo];

    }
    
}

-(void) receiveTestNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"sendArrayToAppDel"])
    {
        NSDictionary* userInfo = notification.userInfo;
        NSArray * response = (NSArray*)userInfo[@"total"];
//        self.userName = (NSString*) userInfo[@"userName"];
        NSLog (@"Successfully received test notification! %@", response);
        if (![response count]==0) {
            NSDictionary *messageDictionary=response[0];
            [self.notifcationCenterArray addObject:messageDictionary];
            
        }
    }
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

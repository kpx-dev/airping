/*
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:   The application delegate class used for setting up the example ZDA application
 *
 *  ZOS Communications, LLC (ÒZOSÓ) grants you a nonexclusive copyright license
 *  to use all programming code examples from which you can generate similar 
 *  function tailored to your own specific needs.
 * 
 *  All sample code is provided by ZOS for illustrative purposes only. These 
 *  examples have not been thoroughly tested under all conditions. ZOS, 
 *  therefore, cannot guarantee or imply reliability, serviceability, or 
 *  function of these *programs.
 * 
 *  All programs contained herein are provided to you "AS IS" without any 
 *  warranties of any kind. The implied warranties of non-infringement, 
 *  merchantability and fitness for a particular purpose are expressly 
 *  disclaimed. 
 *
 *  Copyright Zos Communications LLC, (c) 2011
 *
 */
#import "zdaMapViewAppDelegate.h"
#import "AboutViewController.h"
#import "MapViewController.h"
#import "LocatorViewController.h"
#import "ZDAEventManager.h"
#import "FunctionsViewController.h"
#import "Constants.h"

@implementation zdaMapViewAppDelegate
@synthesize window;
@synthesize tabController;
@synthesize aboutNavController;
@synthesize mapNavController;
@synthesize locatorController;
@synthesize functionsController;
@synthesize timerController = _timerController;

/*!
 * You should use this method to initialize your application and prepare it for running. It is called 
 * after your application has been launched and its main nib file has been loaded. At the time this 
 * method is called, your application is in the inactive state. At some point after this method returns,
 * a subsequent delegate method is called to move your application to the active (foreground) state or 
 * the background state.
 *
 * \param   application     The example application that has been launched
 * \param   launchOptions   Dictionary of any launch options, if any exist then it is because of a location event has been received
 *
 * \return  BOOL  Return NO if the application cannot handle the URL resource, otherwise return YES.
 */
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"Example App launching.....");
    
    window = [[UIWindow alloc]  init];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    [window setFrame: bounds];
    [window setBackgroundColor: [UIColor blackColor]];
    
    self.tabController = [[UITabBarController alloc] init];
    
    self.timerController = [[SXTimerViewController alloc] initWithNibName:@"SXTimerViewController" bundle:nil];
    
    //Now create all the view controllers for each tab
    AboutViewController *pAboutController = [[[AboutViewController alloc] init] autorelease];
    aboutNavController = [[UINavigationController alloc] initWithRootViewController: pAboutController]; 
    self.aboutNavController.navigationBar.barStyle = UIBarStyleBlack;
    self.aboutNavController.navigationBar.translucent = NO;
    self.aboutNavController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    LocatorViewController *pLocatorController = [[[LocatorViewController alloc] init] autorelease];
    locatorController = [[UINavigationController alloc] initWithRootViewController:pLocatorController];
    self.locatorController.navigationBar.barStyle = UIBarStyleBlack;
    self.locatorController.navigationBar.translucent = NO;
    self.locatorController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    MapViewController *pMapController = [[[MapViewController alloc] init] autorelease];
    mapNavController = [[UINavigationController alloc] initWithRootViewController: pMapController]; 
    self.mapNavController.navigationBar.barStyle = UIBarStyleBlack;
    self.mapNavController.navigationBar.translucent = NO;
    self.mapNavController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    FunctionsViewController *pFunctionsController = [[[FunctionsViewController alloc] init] autorelease];
    functionsController = [[UINavigationController alloc] initWithRootViewController: pFunctionsController];
    self.functionsController.navigationBar.barStyle = UIBarStyleBlack;
    self.functionsController.navigationBar.translucent = NO;
    self.functionsController.toolbar.barStyle = UIBarStyleBlackTranslucent;
    
    NSArray* controllers = [NSArray arrayWithObjects: mapNavController, locatorController, functionsController, aboutNavController, nil];
    
    //add the controllers to the mainController
    tabController.viewControllers = controllers;
    //set it to display the first tab by default
    tabController.selectedIndex = 0;
    
    //add the nav controller to the window for displaying
    self.window.rootViewController = self.timerController;
    //make and show the window
    [window makeKeyAndVisible];
    
    //authenticate with the ZDA sdk
    [[ZDAEventManager getInstance] authenticateUser:API_KEY WithPassword:API_PASSWORD UsingViewController:mapNavController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [window release];
    [tabController release];
    [super dealloc];
}

@end

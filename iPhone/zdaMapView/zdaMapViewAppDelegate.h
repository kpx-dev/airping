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
#import <UIKit/UIKit.h>
#import "SXTimerViewController.h"
/*!
 * <Insert a description to help the user...>
 *
 * \author  Paul MacBeath
 * \date    08/05/11
 * \version 1.0
 * \brief   Application delegate for the ZDA map view example
 */
@interface zdaMapViewAppDelegate : NSObject <UIApplicationDelegate> 
{
    UIWindow *window;
    UITabBarController *tabController;
    UINavigationController *aboutNavController;
    UINavigationController *mapNavController;
    UINavigationController *locatorController;
    UINavigationController *functionsController;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabController;
@property (nonatomic, retain) UINavigationController *aboutNavController;
@property (nonatomic, retain) UINavigationController *mapNavController;
@property (nonatomic, retain) UINavigationController *locatorController;
@property (nonatomic, retain) UINavigationController *functionsController;
@property (nonatomic, retain) SXTimerViewController *timerController;
@end

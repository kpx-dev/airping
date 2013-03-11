/*
 
 AboutViewController.h
 Abstract: The view controller to display an about page which describes this example app
 
 \todo   Insert an EULA for example source code here.....
 
 Copyright (C) 2012 Zos Communictaions. All Rights Reserved.
 */

#import <Foundation/Foundation.h>
#import "AboutTableViewController.h"

/*!
 * View controller to display information about this example app to the user.
 *
 * \author  Paul MacBeath
 * \date    08/05/11
 * \version 1.0
 * \brief   View controller to display information about this example app
 */
@interface AboutViewController : UIViewController 
{
    AboutTableViewController *tableViewController;
}

@property (nonatomic, retain) AboutTableViewController *tableViewController;

@end

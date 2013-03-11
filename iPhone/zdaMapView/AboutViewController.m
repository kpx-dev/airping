/*
 AboutViewController.m
 Abstract: The application delegate class used for setting up the example ZDA application
 
 \todo   Insert an EULA for example source code here.....
 
 Copyright (C) 2012 Zos Communictaions. All Rights Reserved.
 */

#import "AboutViewController.h"


@implementation AboutViewController
@synthesize tableViewController;

/*!
 * Override the NSObject init method to initialise the about view controller
 *
 * \return  id  returns the 'this' pointer of the created AboutViewController object
 */
-(id) init
{
    self = [super init];
    
    if (self != nil)
    {
        self.title = @"About";
        self.view.backgroundColor = [UIColor lightGrayColor];
        
        //create the tab bar item for this view
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"About" image:[UIImage imageNamed:@"59-info.png"] tag:0];
        self.tabBarItem = item;
        [item release];
        
        //initialise the table view controller for the about screen
        self.tableViewController = [[AboutTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.tableViewController.view setFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:tableViewController.view];
    }
    
    return self;
}

@end

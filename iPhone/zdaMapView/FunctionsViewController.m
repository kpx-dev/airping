/*
 *
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:   Example view controller which utilises the ZDA API to:
 *                  Request a location shot
 *                  Send XML to the ZOS server
 *
 *  ZOS Communications, LLC (“ZOS”) grants you a nonexclusive copyright license
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
 *  Copyright Zos Communications LLC, (c) 2012
 *
 */

#import "FunctionsViewController.h"


@implementation FunctionsViewController
@synthesize tableViewController;
@synthesize locationShotViewController;
@synthesize messageCountViewController;
@synthesize sendXmlViewController;

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
        self.title = @"Functions";
        self.view.backgroundColor = [UIColor lightGrayColor];
        
        //create the tab bar item for this view
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"Functions" image:[UIImage imageNamed:@"59-info.png"] tag:0];
        self.tabBarItem = item;
        [item release];
        
        //initialise the table view controller for the functions screen
        tableViewController = [[FunctionsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.tableViewController.view setFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.tableViewController.delegate = self;
        [self.view addSubview:tableViewController.view];
        
        //initialise the request location shot view controller
        locationShotViewController = [[RequestLocationShotViewController alloc] init];
        
        //initialise the message count view controller
        messageCountViewController = [[MessageCountViewController alloc] init];
        
        //initialise the send xml view controller
        sendXmlViewController = [[SendXmlViewController alloc] init];
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
    
    [tableViewController release];
    [locationShotViewController release];
    [messageCountViewController release];
    [sendXmlViewController release];
}

#pragma mark -
#pragma mark Functions actions delegate

/////////////////////////////////////FUNCTIONSACTIONDELEGATE IMPLEMENTATION/////////////////////////////////////

/*!
 * The user has selected to request a location shot, so
 * show the view controller to gather the information 
 * and make the request.
 */
-(void) requestLocationCellSelected
{
    [self.navigationController pushViewController:locationShotViewController animated:YES];  
}

/*!
 *
 */
-(void) sendXmlCellSelected
{
    [self.navigationController pushViewController:sendXmlViewController animated:YES];
}

/*!
 *
 */
-(void) messageCountCellSelected
{
    [self.navigationController pushViewController:messageCountViewController animated:YES];
}

@end

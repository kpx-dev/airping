/*
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:   The view controller to display/add/remove all the devices we are locating.
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

#import "LocatorViewController.h"


@implementation LocatorViewController
@synthesize tableViewController;
@synthesize addDeviceController;
@synthesize selectToUpdateLabel;

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
        self.title = @"Locator";
        self.view.backgroundColor = [UIColor lightGrayColor];
        
        //create the tab bar item for this view
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"Locator" image:[UIImage imageNamed:@"74-location.png"] tag:0];
        self.tabBarItem = item;
        [item release];
        
        //initialise the label which tells the user to select a device to update its position
        selectToUpdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
        selectToUpdateLabel.text = @"Select a device below to update its map position";
        selectToUpdateLabel.textAlignment = UITextAlignmentCenter;
        selectToUpdateLabel.font = [UIFont systemFontOfSize:9];
        selectToUpdateLabel.backgroundColor = [UIColor blackColor];
        selectToUpdateLabel.textColor = [UIColor lightTextColor];
        [self.view addSubview:selectToUpdateLabel];
        
        //initialise the table view controller for the about screen
        tableViewController = [[LocatorTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.tableViewController.view setFrame: CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:tableViewController.view];
        
        //init the add device view controller
        addDeviceController = [[AddDeviceViewController alloc] init];
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.tableViewController.isInEditMode == YES)
    {
        [self removeDevice];
    }
    else
    {
        //start the app off in view mode
        [self viewMode];
    }
}

-(void) dealloc
{
    [selectToUpdateLabel release];
    [tableViewController release];
    [addDeviceController release];
    
    [super dealloc];
}

/*!
 * Add device button was selected.  Display the page which
 * gets the device information which we want to locate.
 */
-(void) addDevice
{
    if (addDeviceController == nil) addDeviceController = [[AddDeviceViewController alloc] init];
    
    [self.navigationController pushViewController:addDeviceController animated:YES];
}

/*!
 * Put the table into edit mode
 */
-(void) removeDevice
{
    if (self.tableViewController.isInEditMode == NO)
    {
        self.tableViewController.isInEditMode = YES;
        [self.tableViewController setEditing:YES animated:YES];
        
        //create a done device button now we are in remove mode
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] 
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                       target:self 
                                       action:@selector(removeDevice)];
        self.navigationItem.leftBarButtonItem = doneItem;
        [doneItem release];
    }
    else
    {
        self.tableViewController.isInEditMode = NO;
        [self.tableViewController setEditing:NO animated:YES];
        //reset the view back to the init look
        [self viewMode];
    }
}

/*!
 * Displays only an edit button and hides the leftbarbuttonitem
 */
-(void) viewMode
{
    //create an add device button
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]   
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd  
                                target:self   
                                action:@selector(addDevice)]; 
    
    //create a remove device button
    UIBarButtonItem *removeItem = [[UIBarButtonItem alloc] 
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                   target:self 
                                   action:@selector(removeDevice)];
    
    self.navigationItem.leftBarButtonItem = removeItem;  
    self.navigationItem.rightBarButtonItem = addItem;  
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    self.tableViewController.isInEditMode = NO;
    [self.tableViewController setEditing:NO animated:YES];
    
    [addItem release];  
    [removeItem release];
}

@end

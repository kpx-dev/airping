/*
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:   The table view controller to display/add/remove all the devices we are locating.
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

#import "LocatorTableViewController.h"
#import "Constants.h"
#import <CoreLocation/CoreLocation.h>
#import "ZDAEventManager.h"
#import "DeviceData.h"

@implementation LocatorTableViewController
@synthesize isInEditMode;
@synthesize activityView;

/*!
 * Override the UITableViewController initWithStyle method
 *
 * \param   style   The style of the table we want to display
 *
 * \return  id      The instance id that has been created.
 */
-(id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.allowsSelection = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    isInEditMode = NO;
    
    return self;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    //add ourselves as a listener of location events received from the zda framework
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmlResponseReceived:) name:XML_RESPONSE_EVENT object:nil];
}

-(void)viewDidAppear: (BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void) viewDidUnload 
{
    [super viewDidUnload];
    
    //unregister from the notification center for location update events
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XML_RESPONSE_EVENT object:nil];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)dealloc 
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

/*!
 * The table view controller has received an xml responsefor the currently
 * selected device.  Stop the activity indictor and release it.
 */
-(void) xmlResponseReceived:(NSNotification *)notification
{
    [activityView removeFromSuperview];
    [activityView release];
    activityView = nil;
}

#pragma mark -
#pragma mark Table view delegate

///////////////////////////////////////TABLE VIEW METHODS/////////////////////////////////

/*!
 * \return  NSInteger   Returns the number of sections in the table which is set to 1
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

/*!
 * \return  NSInteger   Returns the number of rows in the tround table
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    ZDAEventManager *mgr = [ZDAEventManager getInstance];
    return [mgr getDeviceCount];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        //delete the device from the model (array) first
        [[ZDAEventManager getInstance] removeDevice:indexPath.row];
        
        //now delete the inputted row
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert)
	{
        //insertions in this app
    } 
}

/*!
 * Only allow editing when in edit mode (i.e. disable swipe for delete and row select)
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((isInEditMode == YES) ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone);
}

/*!
 * Customize the appearance of table view cells which will use our own alarm cell type throughout
 *
 * \todo  This method needs to be completed
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{   
    NSString *cellId = @"aboutCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.minimumFontSize = 10;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    ZDAEventManager *mgr = [ZDAEventManager getInstance];
    DeviceData *data = [mgr getDeviceData:indexPath.row];
    
    if (data == nil)
    {
        cell.textLabel.text = @"Unknown Device";
        cell.detailTextLabel.text = @"";
    }
    else
    {
        cell.textLabel.text = @"Some Id";
        cell.detailTextLabel.text = data.deviceId;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (isInEditMode == NO && activityView == nil)
    {
        //request an xml update of the selected device from the zda framework
        [[ZDAEventManager getInstance] requestDeviceUpdate:indexPath.row];
        
        //start the activity updater going (and make the screen modal until the xml response is made.
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        activityView.hidesWhenStopped = NO;
        [[self.view superview] addSubview:activityView];
        [activityView startAnimating];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Set the background colour to white if it is being displayed on the map
    //otherwise set it to clear
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    /*
    if (self.isInEditMode == NO && [selectedOrders count] > 0)
    {
        NSNumber *number = [selectedOrders objectForKey:[NSNumber numberWithInt:indexPath.row]];
        if (number == nil || [number intValue] == 0)
        {
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
        else
        {
            [cell setBackgroundColor:[UIColor clearColor]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else
    {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
     */
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isInEditMode == NO)
    {
        RoundDisplayCell *cell = (RoundDisplayCell*) [self tableViewInNormalMode:self.tableView cellForRowAtIndexPath:indexPath];
        
        NSString *cellText = cell.titleLabel.text;
        UIFont *cellFont = cell.titleLabel.font;
        CGSize constraintSize = CGSizeMake(250.0, MAXFLOAT);
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        return labelSize.height + 20;
    }
    else
    {
        RoundEditCell *cell = (RoundEditCell*) [self tableViewInNormalMode:self.tableView cellForRowAtIndexPath:indexPath];
        
        NSString *cellText = cell.titleLabel.text;
        UIFont *cellFont = cell.titleLabel.font;
        CGSize constraintSize = CGSizeMake(250.0, MAXFLOAT);
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        return labelSize.height + 20; //(([cell.additionalConfigs.text compare:@""] == NSOrderedSame) ? 10 : 20);
    }
 }
*/

-(void) setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    [self.tableView reloadData];
}

@end

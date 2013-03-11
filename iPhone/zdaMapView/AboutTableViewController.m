/*
 
 AboutTableViewController.m
 Abstract: The table view controller to display an about page which describes this example app
 
 \todo   Insert an EULA for example source code here.....
 
 Copyright (C) 2012 Zos Communictaions. All Rights Reserved.
 */

#import "AboutTableViewController.h"
#import "ZDAEventManager.h"

@implementation AboutTableViewController

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
    
    if (self != nil)
    {
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.allowsSelection = NO;
        self.tableView.allowsSelectionDuringEditing = NO;
    }
    
    return self;
}

-(void)viewDidAppear: (BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


- (void)viewDidUnload 
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc 
{
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
    //only support portrait
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return 3;
}

/*!
 * \return  NSString    Return the title string of the inputted section number
 */
-(NSString*)tableView: (UITableView*) tableView titleForHeaderInSection:(NSInteger)section 
{
    switch (section)
    {
        case 0: return @"ZDA SDK Sample Application";
        default: break;
    }
    
    return @"";
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        //editing not suppored in this app
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert)
	{
        //insertions not supported in this app
    } 
}

/*!
 *  Added for completeness but we are not editing any cells in this table
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

/*!
 * Customize the appearance of table view cells which will display the about content
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
    cell.textLabel.minimumFontSize = 8;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    switch (indexPath.row)
    {
        case 0: //Example version number
        {
            cell.textLabel.text = @"MapView Example App Version";
            //this should not be hard coded but added at release time
            cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        } break;
            
        case 1: //description
        {
            cell.textLabel.text = @"ZDA Version";
            //this can be obtained from the ZDA event manager
            ZDAEventManager *zem = [ZDAEventManager getInstance];
            cell.detailTextLabel.text = zem.zdaVersion;
        } break;
            
        case 2: //copyright
        {
            cell.textLabel.text = @"Copyright (C) 2012 Zos Communications LLC. All Rights Reserved.";
            cell.textLabel.font = [UIFont systemFontOfSize:9];
        } break;
    }
    
    return cell;
}

/*!
 * This table does not support row selection
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    //do not support row selection so do nothing
}

/*!
 * callback when the cell is about to be drawn and displayed
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //use this callback to modify any cell properties on the fly
}

/*!
 * Override to enlarge the cell heights from the default settings.
 */
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}


@end

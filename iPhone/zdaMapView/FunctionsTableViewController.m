/*
 *
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:   Example table view controller which utilises the ZDA API to:
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

#import "FunctionsTableViewController.h"

@implementation FunctionsTableViewController
@synthesize delegate;

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
        self.tableView.allowsSelection = YES;
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
 * \return  NSInteger   Returns the number of rows in the functions table
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
        case 0: return @"Example Functions";
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
        //editing not suppored in this table
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert)
	{
        //insertions not supported in this table
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
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor whiteColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row)
    {
        case 0: //Request a location shot
        {
            cell.textLabel.text = @"Request Location Shot";
        } break;
            
        case 1: //Send XML
        {
            cell.textLabel.text = @"Send XML";
        } break;
            
        case 2: //message count
        {
            cell.textLabel.text = @"Message Count";
        } break;
            
        default: //unknown cell row
        {
            cell.textLabel.text = @"";
        } break;
    }
    
    return cell;
}

/*!
 * A row has been selected.  Display the screen which manages the function depending on the
 * selected row.
 * <ul>
 *      <li>Row 1: Perform a location shot request</li>
 *      <li>Row 2: Perform a send XML action</li>
 * </ul>
 *
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    switch (indexPath.row)
    {
        case 0: //location shot request was selected
        {
            [delegate requestLocationCellSelected];
        } break;

        case 1:
        {
            [delegate sendXmlCellSelected];
        } break;
            
        case 2:
        {
            [delegate messageCountCellSelected];
        } break;
            
        default:
        {
            //unknown row was selected
        }
    }
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

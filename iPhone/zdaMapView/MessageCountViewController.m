/*
 *
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:  View controller for displaying the current geo-message count.
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
 */

#import "MessageCountViewController.h"
#import "Constants.h"
#import "ZDAEventManager.h"

@implementation MessageCountViewController
@synthesize messageCountLabel;

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
        self.title = @"Current Message Count";
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        //initialise the message count label
        messageCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width - 20, 35)];
        messageCountLabel.textAlignment = UITextAlignmentCenter;
        messageCountLabel.backgroundColor = [UIColor clearColor];
        messageCountLabel.text = @"Message Count:";
        [self.view addSubview:messageCountLabel];
    }
    
    return self;
}

/*!
 * Implement viewDidLoad to do additional setup after loading the view.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

/*!
 * Display the correct buttons in the header to cancel or add the device
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //iniatialise the navigation controller
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                                                 target:self   
                                                                 action:@selector(backBtnSelected)];
    
    self.navigationItem.leftBarButtonItem = backBtn; 
    
    [backBtn release];
    
    //display the message count
    messageCountLabel.text = [NSString stringWithFormat:@"Message Count: %d", [ZDAEventManager getInstance].messageCount];
}

-(void) dealloc
{
    [super dealloc];
    
    [messageCountLabel release];
}

/*!
 * Back button was selected.  return to the functions view controller
 */
-(void) backBtnSelected
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

/*
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:   The view controller to add a new device we want to start locating.
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

#import "AddDeviceViewController.h"
#import "ZDAEventManager.h"

@implementation AddDeviceViewController
@synthesize deviceNumber;
@synthesize deviceNumberLabel;
@synthesize deviceTypes;
@synthesize keyboardInputBackground;

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
        self.title = @"Add Device";
        self.view.backgroundColor = [UIColor lightGrayColor];
        
        //initialise the device types
        NSArray *typesArray = [[NSArray alloc] initWithObjects:@"Number", @"Email", nil];
        deviceTypes = [[UISegmentedControl alloc] initWithItems:typesArray];
        [deviceTypes addTarget:self action:@selector(deviceTypeChanged) forControlEvents:UIControlEventValueChanged];
        [deviceTypes setFrame:CGRectMake(0, 50, self.view.frame.size.width, 35)];
        [deviceTypes setSelectedSegmentIndex: 0];
        
        //initialise the label
        deviceNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 35)];
        deviceNumberLabel.textAlignment = UITextAlignmentCenter;
        deviceNumberLabel.backgroundColor = [UIColor clearColor];
        deviceNumberLabel.text = @"Device Number";
        
        //initialise the text edit box
        deviceNumber = [[UITextField alloc] initWithFrame:CGRectMake(5, 150, self.view.frame.size.width - 10, 35)];
        deviceNumber.autocorrectionType = UITextAutocorrectionTypeNo;
        deviceNumber.enabled = YES;
        deviceNumber.keyboardType = UIKeyboardTypePhonePad;
        deviceNumber.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        deviceNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        deviceNumber.textAlignment = UITextAlignmentLeft;
        deviceNumber.delegate = self;
        deviceNumber.backgroundColor = [UIColor whiteColor];
        deviceNumber.borderStyle = UITextBorderStyleBezel;
        deviceNumber.userInteractionEnabled = YES;
        
        keyboardInputBackground = [[UIButton alloc] init];
        keyboardInputBackground.backgroundColor = [UIColor clearColor];
        [keyboardInputBackground addTarget:self action:@selector(keyboardBackgroundSelected) forControlEvents:UIControlEventTouchDown];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        
        [self.view addSubview:deviceTypes];
        [self.view addSubview:deviceNumberLabel];
        [self.view addSubview:deviceNumber];
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
    
    //initialise the input text to a blank string
    deviceNumber.text = @"";
    
    //iniatialise the navigation controller
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered
                                                                 target:self   
                                                                 action:@selector(cancelBtnSelected)];
    
    //this should enter the addmode which pushes a new display onto the stack (TO DO)
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc]  initWithTitle:@"Add" style:UIBarButtonItemStylePlain  
                                                                target:self   
                                                                action:@selector(addBtnSelected)]; 
    [addBtn setEnabled:NO];
    
    self.navigationItem.leftBarButtonItem = cancelBtn;  
    self.navigationItem.rightBarButtonItem = addBtn;
    
    [cancelBtn release];
    [addBtn release];
}

-(void)dealloc
{
    [super dealloc];

    [deviceNumber release];
    [deviceNumberLabel release];
    [deviceTypes release];
    [keyboardInputBackground release];
}

/*!
 * The user has selected the cancel button so let's just return
 * to the devices table view without doing anything.
 */
-(void) cancelBtnSelected
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*!
 * The user has selected the add button so take the device number and 
 * inform the ZDA Event manager to add this device to the devices 
 * request.
 *
 * \note    We do very little (no) error checking on the inputted device string.
 */
-(void) addBtnSelected
{
    //inform the zda event manager to add the device
    
    if ([deviceNumber.text compare:@""] != NSOrderedSame)
    {
        [[ZDAEventManager getInstance] addDevice:deviceNumber.text];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) deviceTypeChanged
{
    switch (deviceTypes.selectedSegmentIndex)
    {
        case 0: //device number
        {
            deviceNumberLabel.text = @"Device Number";
            deviceNumber.keyboardType = UIKeyboardTypePhonePad;
            deviceNumber.text = @"";
            self.navigationItem.rightBarButtonItem.enabled = NO;
        } break;
            
        case 1: //device email address
        {
            deviceNumberLabel.text = @"Device Email Address";
            deviceNumber.keyboardType = UIKeyboardTypeEmailAddress;
            deviceNumber.text = @"";
            self.navigationItem.rightBarButtonItem.enabled = NO;
        } break;
    }
}

-(void) keyboardBackgroundSelected
{
    [deviceNumber resignFirstResponder];
    [keyboardInputBackground removeFromSuperview];
    
    if ([deviceNumber.text compare:@""] != NSOrderedSame)
    {
        //enable the add button
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (BOOL) textFieldShouldReturn: (UITextField*) textField
{
    [self keyboardBackgroundSelected];
    
    return YES;
}

- (BOOL) textFieldShouldBeginEditing: (UITextField *) textField
{
    return YES;
}

//////////////////////////////////KEYBOARD EVENTS////////////////////////////////////////

/*!
 * Called when the UIKeyboardDidShowNotification is sent.
 */
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    keyboardInputBackground.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kbRect.size.height);
 
    //show the big button covering everything but the keyboard so we can
    //dismiss the keyboard just by clicking of of it
    [self.view addSubview:keyboardInputBackground];
}

/*!
 * Called when the UIKeyboardWillHideNotification is sent
 */
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self keyboardBackgroundSelected];
}

@end

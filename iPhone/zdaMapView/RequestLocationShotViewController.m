/*
 *
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:   Example view controller which gathers all the required data from the
 *              user and requests a location shot.  Displayign the response as a result.
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
 *  Copyright Zos Communications LLC, (c) 2011
 *
 */

#import "RequestLocationShotViewController.h"
#import "ZDAEventManager.h"
#import "Constants.h"

@implementation RequestLocationShotViewController
@synthesize timeout;
@synthesize timeoutLabel;
@synthesize accuracy;
@synthesize accuracyLabel;
@synthesize keyboardInputBackground;
@synthesize locationShotOutputResult;
@synthesize activityView;

/*!
 * Override the NSObject init method to initialise the request location shot view controller
 *
 * \return  id  returns the 'this' pointer of the created RequestLocationShotViewController object
 */
-(id) init
{
    self = [super init];
    
    if (self != nil)
    {
        self.title = @"Request Location Shot";
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        selectedTextField = nil;
        
        //initialise the accuracy label
        accuracyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width / 2.0, 35)];
        accuracyLabel.textAlignment = UITextAlignmentCenter;
        accuracyLabel.backgroundColor = [UIColor clearColor];
        accuracyLabel.text = @"Accuracy (in meters)";
        [self.view addSubview:accuracyLabel];
        
        //initialise the accuracy text edit box
        accuracy = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2.0) + 5, 50, (self.view.frame.size.width / 2.0) - 10, 35)];
        accuracy.autocorrectionType = UITextAutocorrectionTypeNo;
        accuracy.enabled = YES;
        accuracy.keyboardType = UIKeyboardTypeNumberPad;
        accuracy.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        accuracy.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        accuracy.textAlignment = UITextAlignmentRight;
        accuracy.delegate = self;
        accuracy.backgroundColor = [UIColor whiteColor];
        accuracy.borderStyle = UITextBorderStyleBezel;
        accuracy.userInteractionEnabled = YES;
        [self.view addSubview:accuracy];
        
        //initialise the timeout label
        timeoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width / 2.0, 35)];
        timeoutLabel.textAlignment = UITextAlignmentCenter;
        timeoutLabel.backgroundColor = [UIColor clearColor];
        timeoutLabel.text = @"Timeout (in seconds)";
        [self.view addSubview:timeoutLabel];
        
        //initialise the timeout text edit box
        timeout = [[UITextField alloc] initWithFrame:CGRectMake((self.view.frame.size.width / 2.0) + 5, 100, (self.view.frame.size.width / 2.0) - 10, 35)];
        timeout.autocorrectionType = UITextAutocorrectionTypeNo;
        timeout.enabled = YES;
        timeout.keyboardType = UIKeyboardTypeNumberPad;
        timeout.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        timeout.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        timeout.textAlignment = UITextAlignmentRight;
        timeout.delegate = self;
        timeout.backgroundColor = [UIColor whiteColor];
        timeout.borderStyle = UITextBorderStyleBezel;
        timeout.userInteractionEnabled = YES;
        [self.view addSubview:timeout];
        
        //initialise the output textview object
        locationShotOutputResult = [[UITextView alloc] initWithFrame:CGRectMake(10, 150, self.view.frame.size.width - 20, self.view.frame.size.height - 160)];
        locationShotOutputResult.hidden = YES;
        locationShotOutputResult.text = @"";
        locationShotOutputResult.backgroundColor = [UIColor whiteColor];
        locationShotOutputResult.textColor = [UIColor blackColor];
        locationShotOutputResult.editable = NO;
        locationShotOutputResult.font = [UIFont fontWithName:@"Courier New" size:14];
        [self.view addSubview:locationShotOutputResult];
        
        //initialise the countdown label
        timeoutCountdownLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, self.view.frame.size.width - 10, 100)];
        timeoutCountdownLabel.textAlignment = UITextAlignmentCenter;
        timeoutCountdownLabel.backgroundColor = [UIColor clearColor];
        timeoutCountdownLabel.hidden = YES;
        timeoutCountdownLabel.font = [UIFont systemFontOfSize:72];
        timeoutCountdownLabel.minimumFontSize = 42;
        timeoutCountdownLabel.adjustsFontSizeToFitWidth = YES;
        timeoutCountdownLabel.text = @"";
        [self.view addSubview:timeoutCountdownLabel];
        
        //initialise the activity updater
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        activityView.hidesWhenStopped = YES;
        [self.view addSubview:activityView];
        
        keyboardInputBackground = [[UIButton alloc] init];
        keyboardInputBackground.backgroundColor = [UIColor clearColor];
        [keyboardInputBackground addTarget:self action:@selector(keyboardBackgroundSelected) forControlEvents:UIControlEventTouchDown];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
        
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
    
    //initialise the input text boxes to a blank strings
    timeout.text = @"";
    accuracy.text = @"";
    
    //iniatialise the navigation controller
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                                                 target:self   
                                                                 action:@selector(backBtnSelected)];
    
    //this should enter the request mode which makes the location shot request in a separate thread
    UIBarButtonItem *requestBtn = [[UIBarButtonItem alloc]  initWithTitle:@"Request" style:UIBarButtonItemStylePlain  
                                                                   target:self   
                                                                   action:@selector(requestBtnSelected)]; 
    [requestBtn setEnabled:NO];
    
    self.navigationItem.leftBarButtonItem = cancelBtn;  
    self.navigationItem.rightBarButtonItem = requestBtn;
    
    [cancelBtn release];
    [requestBtn release];
    
    timeoutCountdownLabel.hidden = YES;
    timeoutCountdownLabel.text = @"";
    
    locationShotOutputResult.hidden = YES;
    locationShotOutputResult.text = @"";
    
    shotResponseReceived = NO;
}

-(void) dealloc
{
    [super dealloc];
    
    [accuracy release];
    [accuracyLabel release];
    [timeout release];
    [timeoutLabel release];
    [selectedTextField release];
    [timeoutCountdownLabel release];
    [locationShotOutputResult release];
    [activityView release];
}

-(void) countdown:(NSTimer*) timer
{
    int nCurrentCountdown = [timeoutCountdownLabel.text intValue];
    nCurrentCountdown--;
    timeoutCountdownLabel.text = [NSString stringWithFormat:@"%d", nCurrentCountdown];
    
    //stop the repeating timer
    if (nCurrentCountdown == 0 || shotResponseReceived == YES) 
    {
        [timer invalidate];
        [activityView stopAnimating];
    }
}

/*!
 * A location response has been sent from the zda via the ZDAEventManager
 */
-(void) locationShotReponse:(NSNotification*)notification
{
    CLLocation *location = (CLLocation*) [notification object];
    NSString *response = [location description];
    
    locationShotOutputResult.text = [NSString stringWithFormat:@"%@\nSHOT RESPONSE RECEIVED\n----------------------\n%@", locationShotOutputResult.text, response];
    
    shotResponseReceived = YES;
}

/*!
 * An error response has been received.  Append it onto the 
 * end of the output result text view.
 */
-(void) ErrorResponse:(NSNotification*)notification
{
    NSString *error = (NSString*) [notification object];
    locationShotOutputResult.text = [NSString stringWithFormat:@"%@\n\nERROR RECEIVED\n--------------\n%@", locationShotOutputResult.text, error];
}

/*!
 * Request button was selected.  Make the request to the ZDA.
 */
-(void) requestBtnSelected
{
    [selectedTextField resignFirstResponder];
    [activityView startAnimating];
    
    //add ourselves as a listener of location shot events received from the zda framework and errors
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationShotReponse:) name:LOCATION_SHOT_RESPONSE_EVENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ErrorResponse:) name:ERROR_RECEIVED_EVENT object:nil];
    
    int nAccuracy = [accuracy.text intValue];
    int nTimeout = [timeout.text intValue];
    
    ZDAEventManager *mgr = [ZDAEventManager getInstance];
    [mgr requestLocationShotWithAccuracy:nAccuracy AndTimeout:nTimeout];
    
    NSString *title = @"LOCATION SHOT REQUEST MADE\n--------------------------\n";
    locationShotOutputResult.text = [NSString stringWithFormat:@"%@Accuracy: %d (in meters)\nTimeout: %d (in seconds)", title, nAccuracy, nTimeout];
    
    timeoutCountdownLabel.text = [NSString stringWithFormat:@"%d", nTimeout];
    timeoutCountdownLabel.hidden = NO;
    locationShotOutputResult.hidden = NO;
    shotResponseReceived = NO;
    
    //start a timer which will countdown the timeout to zero.
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(countdown:)
                                   userInfo:nil
                                    repeats:YES];
}

/*!
 * Back button was selected.  return to the functions view controller
 */
-(void) backBtnSelected
{
    [activityView stopAnimating];
    
    //unregister from the notification center for location update and error events
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOCATION_SHOT_RESPONSE_EVENT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ERROR_RECEIVED_EVENT object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) keyboardBackgroundSelected
{
    [selectedTextField resignFirstResponder];
    [keyboardInputBackground removeFromSuperview];
    
    //enable the request button - this example des not validate the entered value! 
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark -
#pragma mark UITextField delegate

/////////////////////////UITEXTFIELDDELEGATE IMPLEMENTATION/////////////////////////////

/*!
 *
 */
- (BOOL) textFieldShouldReturn: (UITextField*) textField
{
    [self keyboardBackgroundSelected];
    
    return YES;
}

/*!
 *
 */
- (BOOL) textFieldShouldBeginEditing: (UITextField *) textField
{
    [selectedTextField release];
    
    selectedTextField = textField;
    [selectedTextField retain];
    
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

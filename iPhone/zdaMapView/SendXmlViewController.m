/*
 *
 *  $HeadURL$
 *  $Rev$
 *  $Author$
 *  $Date$
 *
 *  Abstract:  View controller for allowing the user to send xml through the ZDA.
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

#import "SendXmlViewController.h"
#import "Constants.h"
#import "QuartzCore/QuartzCore.h"
#import "ZDAEventManager.h"

@implementation SendXmlViewController
@synthesize xmlInputTextView;
@synthesize responseTextView;
@synthesize activityView;
@synthesize clearButton;
@synthesize geocodeXmlButton;
@synthesize reverseGeocodeXmlButton;
@synthesize locateXmlButton;
@synthesize attributeXmlButton;
@synthesize showHideResponseButton;


/*!
 * Override the NSObject init method to initialise the send xml view controller
 *
 * \return  id  returns the 'this' pointer of the created SendXmlViewController object
 */
-(id) init
{
    self = [super init];
    
    if (self != nil)
    {
        self.title = @"Send XML";
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        //initialise the xml buttons 
        float btnWidth = self.view.frame.size.width/5.0;
        clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clearButton.frame = CGRectMake(0, 0, btnWidth, 35);
        [clearButton setTitle:@"Clear XML" forState:UIControlStateNormal];
        [clearButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [clearButton setTitleColor:[UIColor darkGrayColor] forState:UIControlEventTouchDown];
        clearButton.titleLabel.minimumFontSize = 8;
        clearButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        clearButton.titleLabel.font = [UIFont systemFontOfSize:12];
        clearButton.backgroundColor = [UIColor blackColor];
        CALayer * clearButtonLayer = [clearButton layer];
        [clearButtonLayer setMasksToBounds:YES];
        [clearButtonLayer setBorderWidth:1.0];
        [clearButtonLayer setBorderColor:[[UIColor grayColor] CGColor]];
        [clearButton addTarget:self action:@selector(clearXmlInput) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:clearButton];
        
        geocodeXmlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        geocodeXmlButton.frame = CGRectMake(btnWidth, 0, btnWidth, 35);
        [geocodeXmlButton setTitle:@"Geocode" forState:UIControlStateNormal];
        [geocodeXmlButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [geocodeXmlButton setTitleColor:[UIColor darkGrayColor] forState:UIControlEventTouchDown];
        geocodeXmlButton.titleLabel.minimumFontSize = 8;
        geocodeXmlButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        geocodeXmlButton.titleLabel.font = [UIFont systemFontOfSize:12];
        geocodeXmlButton.backgroundColor = [UIColor blackColor];
        CALayer * geocodeButtonLayer = [geocodeXmlButton layer];
        [geocodeButtonLayer setMasksToBounds:YES];
        [geocodeButtonLayer setBorderWidth:1.0];
        [geocodeButtonLayer setBorderColor:[[UIColor grayColor] CGColor]];
        [geocodeXmlButton addTarget:self action:@selector(addGeocodeXmlTemplate) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:geocodeXmlButton];
        
        reverseGeocodeXmlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        reverseGeocodeXmlButton.frame = CGRectMake(btnWidth*2.0, 0, btnWidth, 35);
        [reverseGeocodeXmlButton setTitle:@"Reverse Geo" forState:UIControlStateNormal];
        [reverseGeocodeXmlButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [reverseGeocodeXmlButton setTitleColor:[UIColor darkGrayColor] forState:UIControlEventTouchDown];
        reverseGeocodeXmlButton.titleLabel.minimumFontSize = 8;
        reverseGeocodeXmlButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        reverseGeocodeXmlButton.titleLabel.font = [UIFont systemFontOfSize:12];
        reverseGeocodeXmlButton.backgroundColor = [UIColor blackColor];
        CALayer * reverseGeocodeButtonLayer = [reverseGeocodeXmlButton layer];
        [reverseGeocodeButtonLayer setMasksToBounds:YES];
        [reverseGeocodeButtonLayer setBorderWidth:1.0];
        [reverseGeocodeButtonLayer setBorderColor:[[UIColor grayColor] CGColor]];
        [reverseGeocodeXmlButton addTarget:self action:@selector(addReverseGeocodeXmlTemplate) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:reverseGeocodeXmlButton];
        
        locateXmlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        locateXmlButton.frame = CGRectMake(btnWidth*3.0, 0, btnWidth, 35);
        [locateXmlButton setTitle:@"locate" forState:UIControlStateNormal];
        [locateXmlButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [locateXmlButton setTitleColor:[UIColor darkGrayColor] forState:UIControlEventTouchDown];
        locateXmlButton.titleLabel.minimumFontSize = 8;
        locateXmlButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        locateXmlButton.titleLabel.font = [UIFont systemFontOfSize:12];
        locateXmlButton.backgroundColor = [UIColor blackColor];
        CALayer * locateButtonLayer = [locateXmlButton layer];
        [locateButtonLayer setMasksToBounds:YES];
        [locateButtonLayer setBorderWidth:1.0];
        [locateButtonLayer setBorderColor:[[UIColor grayColor] CGColor]];
        [locateXmlButton addTarget:self action:@selector(addLocateXmlTemplate) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:locateXmlButton];
        
        attributeXmlButton = [UIButton buttonWithType:UIButtonTypeCustom];
        attributeXmlButton.frame = CGRectMake(btnWidth*4.0, 0, btnWidth, 35);
        [attributeXmlButton setTitle:@"Attributes" forState:UIControlStateNormal];
        [attributeXmlButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [attributeXmlButton setTitleColor:[UIColor darkGrayColor] forState:UIControlEventTouchDown];
        attributeXmlButton.titleLabel.minimumFontSize = 8;
        attributeXmlButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        attributeXmlButton.titleLabel.font = [UIFont systemFontOfSize:12];
        attributeXmlButton.backgroundColor = [UIColor blackColor];
        CALayer * attributeButtonLayer = [attributeXmlButton layer];
        [attributeButtonLayer setMasksToBounds:YES];
        [attributeButtonLayer setBorderWidth:1.0];
        [attributeButtonLayer setBorderColor:[[UIColor grayColor] CGColor]];
        [attributeXmlButton addTarget:self action:@selector(addAttributeXmlTemplate) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:attributeXmlButton];
        
        xmlInputTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 40, self.view.frame.size.width - 10, self.view.frame.size.height - 175)];
        xmlInputTextView.text = @"";
        xmlInputTextView.backgroundColor = [UIColor whiteColor];
        xmlInputTextView.textColor = [UIColor blackColor];
        xmlInputTextView.editable = YES;
        xmlInputTextView.font = [UIFont fontWithName:@"Courier New" size:14];
        xmlInputTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        xmlInputTextView.keyboardType = UIKeyboardTypeDefault;
        [self.view addSubview:xmlInputTextView];
    
        responseTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 40, self.view.frame.size.width - 10, self.view.frame.size.height - 175)];
        responseTextView.text = @"";
        responseTextView.backgroundColor = [UIColor lightGrayColor];
        responseTextView.textColor = [UIColor blackColor];
        responseTextView.editable = NO;
        responseTextView.font = [UIFont fontWithName:@"Courier New" size:14];
        responseTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        responseTextView.hidden = YES;
        [self.view addSubview:responseTextView];
        
        showHideResponseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        showHideResponseButton.frame = CGRectMake(0, self.view.frame.size.height - 130, self.view.frame.size.width, 30);
        [showHideResponseButton setTitle:@"show xml response" forState:UIControlStateNormal];
        [showHideResponseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [showHideResponseButton setTitleColor:[UIColor darkGrayColor] forState:UIControlEventTouchDown];
        showHideResponseButton.titleLabel.font = [UIFont systemFontOfSize:10];
        showHideResponseButton.backgroundColor = [UIColor blackColor];
        [showHideResponseButton addTarget:self action:@selector(showHideResponseButtonSelected) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:showHideResponseButton];
        
        //initialise the activity updater
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
        [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        activityView.hidesWhenStopped = YES;
        [self.view addSubview:activityView];
        
        showingResponseTextView = NO;
    }
    
    return self;
}

/*!
 * Display the correct buttons in the header to cancel or add the device
 */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //iniatialise the navigation controller
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                                                 target:self   
                                                                 action:@selector(backBtnSelected)];
    
    //this should enter the request mode which makes the location shot request in a separate thread
    UIBarButtonItem *sendXmlBtn = [[UIBarButtonItem alloc]  initWithTitle:@"Send XML" style:UIBarButtonItemStylePlain  
                                                                   target:self   
                                                                   action:@selector(sendXmlBtnSelected)]; 
    if ([xmlInputTextView.text compare:@""] == NSOrderedSame)
    {
        [sendXmlBtn setEnabled:NO];
    }
    else
    {
        [sendXmlBtn setEnabled:YES];
    }
    
    self.navigationItem.leftBarButtonItem = cancelBtn;  
    self.navigationItem.rightBarButtonItem = sendXmlBtn;
    
    [cancelBtn release];
    [sendXmlBtn release];
}

-(void) dealloc
{
    [super dealloc];
    
    [clearButton release];
    [geocodeXmlButton release];
    [reverseGeocodeXmlButton release];
    [locateXmlButton release];
    [attributeXmlButton release];
    [xmlInputTextView release];
    [responseTextView release];
    [activityView release];
    [showHideResponseButton release];
}

/*!
 * Display the response view over the top of the xml being sent view
 */
-(void) showResponseView
{
    [showHideResponseButton setTitle:@"hide xml response" forState:UIControlStateNormal];
    responseTextView.hidden = NO;
    xmlInputTextView.hidden = YES;
    showingResponseTextView = YES;
}

-(void) hideResponseView
{
    [showHideResponseButton setTitle:@"show xml response" forState:UIControlStateNormal];
    responseTextView.hidden = YES;
    xmlInputTextView.hidden = NO;
    showingResponseTextView = NO;
}

/*!
 * Request button was selected.  Make the request to the ZDA.
 */
-(void) sendXmlBtnSelected
{
    [xmlInputTextView resignFirstResponder];
    [activityView startAnimating];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [self showResponseView];
    
    ZDAEventManager *mgr = [ZDAEventManager getInstance];
    requestId theId = [mgr sendXML:xmlInputTextView.text];
    responseTextView.text = [NSString stringWithFormat:@"Request sent with ID: %d\nXML sent:\n%@\n\n", theId, xmlInputTextView.text];
    
    //add ourselves as a listener of xml response events received from the zda framework
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(xmlResponseReceived:) name:XML_RESPONSE_EVENT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ErrorResponse:) name:ERROR_RECEIVED_EVENT object:nil];
}

/*!
 * Back button was selected.  return to the functions view controller
 */
-(void) backBtnSelected
{
    [activityView stopAnimating];
    [xmlInputTextView resignFirstResponder];
    
    //unregister from the notification center for xml response and error events
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XML_RESPONSE_EVENT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ERROR_RECEIVED_EVENT object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*!
 *
 */
-(void) clearXmlInput
{
    //clear the text
    xmlInputTextView.text = @"";
    //disable the send xml button
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

/*!
 * Add the geocode xml template to the text view 
 */
-(void) addGeocodeXmlTemplate
{
    //now add the geocode template with some helpful insert text instead of values
    xmlInputTextView.text = [NSString stringWithFormat:GEOCODE_REQUEST_XML, @"INSERT_ADDRESS"];
    [xmlInputTextView resignFirstResponder];
    
    //we have text in the text view so enable the sendxml button
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

/*!
 * Add the reverse geocode xml temlate to the text view
 */
-(void) addReverseGeocodeXmlTemplate
{
    //now add the reverse geocode template with some default values
    xmlInputTextView.text = [NSString stringWithFormat:REVERSE_GEOCODE_REQUEST_XML, @"INSERT_ADDRESS", 0.000, 0.000];
    [xmlInputTextView resignFirstResponder];
    
    //we have text in the text view so enable the sendxml button
    self.navigationItem.rightBarButtonItem.enabled = YES; 
}

/*!
 * Add the locate xml template to the text view
 */
-(void) addLocateXmlTemplate
{
    NSString *strDevice = [NSString stringWithFormat:DEVICE_XML, @"INSERT_DEVICE_NO"];
    [xmlInputTextView resignFirstResponder];
    
    //now add the locate template with some helpful insert text instead of values
    xmlInputTextView.text = [NSString stringWithFormat:LOCATION_REQUEST_XML, strDevice];
        
    //we have text in the text view so enable the sendxml button
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

/*!
 * Add the attribute xml emplate to the text view
 */
-(void) addAttributeXmlTemplate
{
    NSString *strAttribute = [NSString stringWithFormat:ATTRIBUTE_XML, @"DESCRIPTION", @"VALUE"];
    [xmlInputTextView resignFirstResponder];
    
    //now add the locate template with some helpful insert text instead of values
    xmlInputTextView.text = [NSString stringWithFormat:ATTRIBUTES_REQUEST_XML, strAttribute];
    
    //we have text in the text view so enable the sendxml button
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

-(void) showHideResponseButtonSelected
{
    if (showingResponseTextView == YES)
    {
        [self hideResponseView];
    }
    else
    {
        [self showResponseView];
    }
}

/*!
 * XML response received from the ZDA library.  Append it onto the
 * end of the output text view.
 */
-(void) xmlResponseReceived:(NSNotification*)notification
{
    [activityView stopAnimating];
    
    NSString *xml = (NSString*) [notification object];
    
    responseTextView.text = [NSString stringWithFormat:@"%@\nXML RESPONSE RECEIVED\n----------------------\n%@", responseTextView.text, xml];
    
    //unregister from the notification center for xml response and error events
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XML_RESPONSE_EVENT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ERROR_RECEIVED_EVENT object:nil];
}

/*!
 * An error response has been received.  Append it onto the 
 * end of the output result text view.
 */
-(void) ErrorResponse:(NSNotification*)notification
{
    [activityView stopAnimating];
    
    NSString *error = (NSString*) [notification object];
    responseTextView.text = [NSString stringWithFormat:@"%@\n\nERROR RECEIVED\n--------------\n%@", responseTextView.text, error];
    
    //unregister from the notification center for xml response and error events
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XML_RESPONSE_EVENT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ERROR_RECEIVED_EVENT object:nil];
}

@end

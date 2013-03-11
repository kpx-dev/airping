//
//  SXTimerViewController.m
//  zdaMapView
//
//  Created by Winfred Raguini on 3/9/13.
//  Copyright (c) 2013 Unknown. All rights reserved.
//

#import "SXTimerViewController.h"
#import "ATGateViewController.h"
#import "ATMapViewController.h"
#import "SXPHPClient.h"
#import "BoardingInfoManager.h"
#import "UIDetailViewController.h"


@interface SXTimerViewController ()
- (void)startTimer;
- (void)updateETATimer;
- (void)updateAlert;
@end

@implementation SXTimerViewController
@synthesize secondsA = _secondsA;
@synthesize pagingController = _pagingController;
@synthesize etaAlertView = _etaAlertView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    //2013-03-10T17:00:00-05:00
    // Do any additional setup after loading the view from its nib.
    
    startA = TRUE;
    startETACounter = TRUE;
    etaCounter = 60*60 + 23;
    
    [self startTimer];
    
    self.pagingController = [[ATPagingViewController alloc] initWithNibName:@"ATPagingViewController" bundle:nil];
    
    ATGateViewController *gateController = [[ATGateViewController alloc] initWithNibName:@"ATGateViewController" bundle:nil];
    
    ATMapViewController *mapController = [[ATMapViewController alloc] initWithNibName:@"ATMapViewController" bundle:nil];
    
    [self.pagingController addChildViewController:gateController];
    [self.pagingController addChildViewController:mapController];
    
    [self addChildViewController:self.pagingController];
    CGRect pagingFrame = self.pagingController.view.frame;
    pagingFrame.origin.y = self.view.frame.size.height - 205.0f;
    [self.pagingController.view setFrame:pagingFrame];
    [self.view addSubview:self.pagingController.view];
    
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(getData) userInfo:nil repeats:YES];
    

    
    
}


- (void)getData
{
    [[SXPHPClient sharedClient] getPath:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSDictionary *dict = (NSDictionary*)JSON;
        NSLog(@"%@", [dict objectForKey:@"aa_advantage"]);
        
        NSLog(@"whole dict %@", dict);
        NSLog(@"boarding time: %@", [dict objectForKey:@"boarding"]);
        NSString *boardingTime = [dict objectForKey:@"boarding"];
        
        NSDate *date = [self.dateFormatter dateFromString:boardingTime];
        NSDate *testDate = [NSDate date];
        NSLog(@"date %@", date);
        
        departureCounter = [date timeIntervalSinceDate:[NSDate date]];
        NSLog(@"counter %d", departureCounter);
        [self updateTimer];
        //        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        //        for (NSDictionary *attributes in postsFromResponse) {
        //            BoardingInfo *boardingInfo = [[BoardingInfo alloc] initWithAttributes:attributes];
        //            [mutablePosts addObject:boardingInfo];
        //        }
        
        //        if (block) {
        //            block([NSArray arrayWithArray:mutablePosts], nil);
        //        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        if (block) {
        //            block([NSArray array], error);
        //        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateTimer{ //Happens every time updateTimer is called. Should occur every second.
    [self updateETATimer];
//    departureCounter -= 1;
    
    CGFloat hours = floor(departureCounter/3600.0f);
    CGFloat totalminutes = floor(departureCounter/60.0f);
    CGFloat minutes = (int)floor(departureCounter/60.0f) % 60;
    CGFloat mseconds = round(departureCounter - (totalminutes * 60));
    
    
    if (hours > 0) {
        self.secondsA.text = [NSString stringWithFormat:@"%01d:%02d:%02d", (int)hours, (int)minutes, (int)mseconds];
    } else {
        self.secondsA.text = [NSString stringWithFormat:@"%02d:%02d", (int)minutes, (int)mseconds];
    }
    
    
    if (departureCounter < 0) // Once timer goes below 0, reset all variables.
    {
        self.secondsA.text = @"00:00";
//        [departureTimer invalidate];
        startA = TRUE;
//        departureCounter = 10;
        
    }
    
    [self updateAlert];
    
}

- (void)updateETATimer{ //Happens every time updateTimer is called. Should occur every second.
//    etaCounter -= 1;
    etaCounter = 60 * 34 + 24;
    CGFloat hours = floor(etaCounter/3600.0f);
    CGFloat totalminutes = floor(etaCounter/60.0f);
    CGFloat minutes = (int)floor(etaCounter/60.0f) % 60;
    CGFloat mseconds = round(etaCounter - (totalminutes * 60));
    
    
    if (hours > 0) {
        self.etaTimer.text = [NSString stringWithFormat:@"%01d:%02d:%02d", (int)hours, (int)minutes, (int)mseconds];
    } else {
        self.etaTimer.text = [NSString stringWithFormat:@"%02d:%02d", (int)minutes, (int)mseconds];
    }
    
    
    if (etaCounter < 0) // Once timer goes below 0, reset all variables.
    {
        self.etaTimer.text = @"00:00";
        //        [departureTimer invalidate];
//        startA = TRUE;
        //        departureCounter = 10;
        
    }
    
}


-(void)startTimer {
    NSLog(@"timer");
    if(startA == TRUE) //Check that another instance is not already running.
    {
//        self.secondsA.text = @"10";
        startA = FALSE;
        departureTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
//        etaTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateETATimer) userInfo:nil repeats:YES];
    }
}

- (void)updateAlert
{
    NSLog(@"departureCounter %d", departureCounter);
    if ((departureCounter <= (15 * 60)) || (etaCounter >= departureCounter)) {
        [self.etaAlertView setBackgroundColor:[UIColor colorWithRed:218.0f/255.0f green:61.0f/255.0f blue:38.0f/255.0f alpha:1.0f]];
    } else {
        [self.etaAlertView setBackgroundColor:[UIColor colorWithRed:114.0f/255.0f green:193.0f/255.0f blue:176.0f/255.0f alpha:1.0f]];
    }
    
}

- (IBAction)settingsButtonSelected:(id)sender
{
    NSLog(@"settingsBUttonSelected");
    
    UIDetailViewController *detailController = [[UIDetailViewController alloc] initWithNibName:@"UIDetailViewController" bundle:nil];
    detailController.view.frame = CGRectMake(0, 20, 320, 460);
    [UIView transitionFromView:self.view toView:detailController.view duration:1.0f options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        
    }];
}

@end

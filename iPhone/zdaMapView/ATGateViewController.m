//
//  ATGateViewController.m
//  zdaMapView
//
//  Created by Winfred Raguini on 3/10/13.
//  Copyright (c) 2013 Unknown. All rights reserved.
//

#import "ATGateViewController.h"

@interface ATGateViewController ()

@end

@implementation ATGateViewController
@synthesize gateLabel = _gateLabel;
@synthesize terminalLabel = _terminalLabel;
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

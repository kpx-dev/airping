//
//  UIDetailViewController.m
//  AirPing
//
//  Created by Winfred Raguini on 3/10/13.
//  Copyright (c) 2013 AirPing.co. All rights reserved.
//

#import "UIDetailViewController.h"
#import "SXTimerViewController.h"
@interface UIDetailViewController ()

@end

@implementation UIDetailViewController

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

- (IBAction)settingsButtonSelected:(id)sender
{
    SXTimerViewController *timerController = [[SXTimerViewController alloc] initWithNibName:@"SXTimerViewController" bundle:nil];
    NSLog(@"settingsBUttonSelected");
    
    timerController.view.frame = CGRectMake(0, 20, 320, 460);
    [UIView transitionFromView:self.view toView:timerController.view duration:1.0f options:UIViewAnimationOptionTransitionFlipFromRight completion:^(BOOL finished) {
        
    }];
}

@end

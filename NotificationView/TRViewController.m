//
//  TRViewController.m
//  NotificationView
//
//  Created by Danil Komarov on 12.09.12.
//  Copyright (c) 2012 Two Rules. All rights reserved.
//

#import "TRViewController.h"
#import "DKNotificationView.h"

@interface TRViewController ()

@end

@implementation TRViewController

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
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    DKNotificationView *notificationView = [[DKNotificationView alloc] initWithFrame:CGRectMake(0, 40, 320, 420) inView:self.view];
    
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, 240, 20)];
    testLabel.backgroundColor = [UIColor clearColor];
    testLabel.font = [UIFont boldSystemFontOfSize:18];
    testLabel.textColor = [UIColor whiteColor];
    testLabel.shadowColor = [UIColor blackColor];
    testLabel.shadowOffset = CGSizeMake(0, 1);
    testLabel.textAlignment = UITextAlignmentCenter;
    testLabel.text = @"DKNotificationView";
    
    [notificationView.contentView addSubview:testLabel];
    
    UILabel *testLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 240, 30)];
    testLabel2.backgroundColor = [UIColor clearColor];
    testLabel2.font = [UIFont boldSystemFontOfSize:30];
    testLabel2.textColor = [UIColor whiteColor];
    testLabel2.shadowColor = [UIColor blackColor];
    testLabel2.shadowOffset = CGSizeMake(0, 1);
    testLabel2.textAlignment = UITextAlignmentCenter;
    testLabel2.text = @"Example";
    
    [self.view addSubview:testLabel2];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

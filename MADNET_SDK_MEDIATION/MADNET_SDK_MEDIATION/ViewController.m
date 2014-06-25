//
//  ViewController.m
//  MADNET_SDK_MEDIATION
//
//  Created by AndreyIvanov on 25.07.13.
//  Copyright (c) 2013 AndreyIvanov. All rights reserved.
//

#import "ViewController.h"
#import "IMADRotationViewDelegate.h"

#import "GADBannerView.h"
#import "GADCustomEventBannerDelegate.h"

@interface ViewController ()<IMADRotationViewDelegate, GADBannerViewDelegate>
{
@private
    GADBannerView *_banner;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _banner = [[GADBannerView alloc] initWithAdSize: kGADAdSizeBanner
                                             origin: CGPointMake((self.view.bounds.size.width - kGADAdSizeBanner.size.width)/2.0f, 50.0f)];
    #warning // !Replace @"AdMob_ID" with your AdMob ad-placemenet id!
    _banner.adUnitID = @"ca-app-pub-8222858898201564/9113166534";
    _banner.rootViewController = self;
    _banner.delegate = self;
    _banner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;

    [self.view addSubview: _banner];
    
    GADRequest * request = [GADRequest request];
    /*request.gender = kGADGenderMale;
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID, nil];
    */
    [_banner loadRequest: request];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *) MADViewController
{
    return (self);
}

- (void) dealloc
{
    [_banner release]; _banner = nil;
    [super dealloc];
}

@end

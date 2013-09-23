//
//  MADCustomEventWithGADBanner.m
//  Part of MADNET iOS SDK -> http://madnet.ru
//
//  Created by Andrey Ivanov.
//  Copyright 2013 TinkoffDigital. All rights reserved.
//  Copyright 2013 MADNET. All rights reserved.
//


#import "MADCustomEventWithGADBanner.h"
#import "GADBannerView.h"
#import "MADSize.h"
#import "MADRotationView.h"
#import "GADCustomEventBanner.h"
#import "IMADRotationViewDelegate.h"

#if __has_feature(objc_arc)

#define HAS_ARC 1
#define RETAIN(_o) (_o)
#define RELEASE(_o)
#define AUTORELEASE(_o) (_o)

#else

#define HAS_ARC 0
#define RETAIN(_o) [(_o) retain]
#define RELEASE(_o) [(_o) release]
#define AUTORELEASE(_o) [(_o) autorelease]

#endif

MADSize MADNETSizeFromGADAdSize (GADAdSize adSize)
{
    MADSize result = {{adSize.size.width, adSize.size.height}, 1};
    return (result);
}

@interface MADCustomEventWithGADBanner() <GADCustomEventBanner, IMADRotationViewDelegate>
{
  @private
    MADRotationView *m_madnetview;
}
@end

@implementation MADCustomEventWithGADBanner 
@synthesize delegate;

- (id) init
{
    self = [super init];
    if (self)
    {
        m_madnetview = nil;
    }
    return (self);
}

- (void) setGender: (MADExternalValuesForTargeting *) aParams from: (GADCustomEventRequest *) aRequest
{
    switch (aRequest.userGender)
    {
        case kGADGenderMale:
            [aParams setValue: [CmAdTargetParameters params].gender.male];
            break;
        case kGADGenderFemale:
            [aParams setValue: [CmAdTargetParameters params].gender.female];
        default:
            break;
    }
}

- (MADExternalValuesForTargeting *) madnetExternalValuesFromRequest: (GADCustomEventRequest *)request
{
    MADExternalValuesForTargeting *extraparam = AUTORELEASE([[MADExternalValuesForTargeting alloc] init]);
    [self setGender:extraparam from:request];
    extraparam.dob = request.userBirthday;
    
    if (request.userHasLocation)
    {
        extraparam.gps = [NSString stringWithFormat:@"%f, %f", request.userLatitude, request.userLongitude];
    }
    
    NSArray * const userKeywords = request.userKeywords;
    if (userKeywords != nil)
    {
        extraparam.keywords = [NSMutableSet setWithArray: userKeywords];
    }
    
    return (extraparam);
}

- (MADBaseRequestParametrs *) madnetBaseValuesFromRequest: (GADCustomEventRequest *)request
{
    MADBaseRequestParametrs * baseparam = AUTORELEASE([[MADBaseRequestParametrs alloc] init]);
    baseparam.testmode = request.isTesting;
    return (baseparam);
}

- (void)requestBannerAd: (GADAdSize)adSize
              parameter: (NSString *)serverParameter
                  label: (NSString *)serverLabel
                request: (GADCustomEventRequest *)request
{
    // В этом месте следует настроить идентификатор рекламного места
    m_madnetview = [[MADRotationView alloc] initWithAdSize: mAdSizeFromCGSize(adSize.size)
                                                   spaceId: @"SPACE_ID" // replace
                                                 partnerId: nil];
    m_madnetview.delegate = self;
    [m_madnetview loadWithBase: [self madnetBaseValuesFromRequest: request]
                      external: [self madnetExternalValuesFromRequest: request]];
}

#pragma mark -
#pragma mark MyBanner Callbacks

- (void) rotationViewDidReceiveAd: (MADRotationView *) aRotationView
{
    [self.delegate customEventBanner:self didReceiveAd:aRotationView];
    [m_madnetview pause];
}

- (void) rotationView:(MADRotationView *)aRotationView didFailToReceiveAdWithError:(NSError *)aError
{
    [self.delegate customEventBanner:self didFailAd:aError];
    [m_madnetview pause];
}

- (void)rotationViewWillPresentModal:(MADRotationView *)aRotationView
{
    [self.delegate customEventBannerWillPresentModal: self];
}

- (void) rotationViewWillDismissModal:(MADRotationView *)aRotationView
{
    [self.delegate customEventBannerWillDismissModal: self];
}

- (void) rotationViewDidDismissModal:(MADRotationView *)aRotationView
{
    [self.delegate customEventBannerDidDismissModal: self];
}

- (void) rotationViewWillLeaveApplication:(MADRotationView *)aRotationView
{
    [self.delegate customEventBannerWillLeaveApplication: self];
}

- (void) rotationViewClick:(MADRotationView *)aRotationView
{
    [self.delegate customEventBanner: self clickDidOccurInAd: aRotationView];
}

- (UIViewController *) MADViewController
{
    return (self.delegate.viewControllerForPresentingModalView);
}

- (void) dealloc
{
    [m_madnetview invalidate];
    RELEASE(m_madnetview); m_madnetview = nil;
#if ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

@end

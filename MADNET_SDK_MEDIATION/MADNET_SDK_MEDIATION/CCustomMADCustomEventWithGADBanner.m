//
//  CCustomMADCustomEventWithGADBanner.m
//  admee
//
//  Created by AndreyIvanov on 17.06.14.
//  Copyright (c) 2014 a.ivanov. All rights reserved.
//

#import "CCustomMADCustomEventWithGADBanner.h"
#import "MADRotationView.h"

@implementation CCustomMADCustomEventWithGADBanner

- (NSString *) madnetidentifier
{
#warning // !Replace @"SPACE_ID" with your madnet ad-placemenet id!
    return (@"150");
}

- (BOOL) rotationViewTestingMode: (MADRotationView *)aRotationView
{
    return (NO);
}

@end

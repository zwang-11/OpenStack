//
//  OSLoadingView.m
//  Openstack
//
//  Created by Zeng Wang on 9/17/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "OSLoadingView.h"

@interface OSLoadingView ()

- (void) initTitleLabel;
- (void) initActivitiyIndicatorView;

- (void) layoutTitleLabel;
- (void) layoutActivityIndicatorView;

@end

@implementation OSLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor    = [UIColor whiteColor];
        self.opaque             = YES;
        self.autoresizingMask   = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self initActivitiyIndicatorView];
        [self initTitleLabel];
    }
    return self;
}

/**
 layout subviews
 */
- (void) layoutSubviews;
{
    [super layoutSubviews];
    
    [self layoutActivityIndicatorView];
    [self layoutTitleLabel];
}

#pragma mark - init
/**
 init activity indicator
 */
- (void) initActivitiyIndicatorView
{
    self.activitiyIndicatorView     = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    [self addSubview:self.activitiyIndicatorView];
}

/**
 init title label;
 */
- (void) initTitleLabel
{
    self.titleLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font            = [UIFont systemFontOfSize:kLV_titleLableFont];
    self.titleLabel.textAlignment   = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.titleLabel];
}

/**
 layout activityIndicatorView
 */
- (void) layoutActivityIndicatorView
{
    CGRect frame                        = CGRectZero;
    frame.size                          = kLV_loadingIndicatorSize;
    frame.origin.x                      = (self.frame.size.width - frame.size.width) * .5;
    frame.origin.y                      = (self.frame.size.height - frame.size.height) * .5;
    
    self.activitiyIndicatorView.frame   = frame;
}

/**
 layout title Label;
 */
- (void) layoutTitleLabel
{
    // if no titleLabel set default
    if ([NSString isNilOrEmptyString:self.titleLabel.text]) {
        self.titleLabel.text        = @"Loading...";
    }
    
    CGRect frame                    = CGRectZero;
    frame.size                      = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    frame.origin.x                  = (self.frame.size.width - frame.size.width) * .5;
    frame.origin.y                  = self.activitiyIndicatorView.frame.origin.y + self.activitiyIndicatorView.frame.size.height + kLV_titleLabelTopPadding;
    
    self.titleLabel.frame           = frame;
}


@end

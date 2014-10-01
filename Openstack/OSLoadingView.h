//
//  OSLoadingView.h
//  Openstack
//
//  Created by Zeng Wang on 9/17/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLV_loadingIndicatorSize        CGSizeMake(20,20)
#define kLV_titleLableFont              12
#define kLV_titleLabelTopPadding        5



@interface OSLoadingView : UIView

@property (nonatomic, strong) UIActivityIndicatorView*      activitiyIndicatorView;
@property (nonatomic, strong) UILabel*                      titleLabel;

@end

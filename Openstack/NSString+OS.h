//
//  NSString+OS.h
//  Openstack
//
//  Created by Zeng Wang on 9/17/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (OS)


+ (BOOL) isNilOrEmptyString:(NSString*)string;
- (CGSize) sizeWithFont:(UIFont* )font;
- (CGSize) sizeWithFont:(UIFont* )font constrainedToSize:(CGSize) size;

@end

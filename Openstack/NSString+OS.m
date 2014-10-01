//
//  NSString+OS.m
//  Openstack
//
//  Created by Zeng Wang on 9/17/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import "NSString+OS.h"

@implementation NSString (OS)

/**
 returns yes if self is empty
 */
+ (BOOL) isNilOrEmptyString:(NSString*)string;
{
    if (nil == string || ![string isKindOfClass:[NSString class]] || [string isEqualToString:@""]) {
        return YES;
    }
    
    return NO;
}

/**
 return the size based on the font
 */
- (CGSize) sizeWithFont:(UIFont* )font;
{
    if (nil == font || [NSString isNilOrEmptyString:self]) {
        return CGSizeZero;
    }
    
    NSDictionary* attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    return [self sizeWithAttributes:attributes];
}

/**
 return the size based on the font with the constrained size
 */
- (CGSize) sizeWithFont:(UIFont* )font constrainedToSize:(CGSize) size;
{
    if (nil == font) {
        return CGSizeZero;
    }
    
    NSDictionary* attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:self attributes:attributes];
    
    CGRect frame = [attributedString boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) context:nil];
    return frame.size;
}

@end

//
//  OSImage.h
//  Openstack
//
//  Created by Zeng Wang on 9/9/14.
//  Copyright (c) 2014 Zeng Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OSImage : NSObject

@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSString *imageID;

- (id)initWithDictionary:(NSDictionary *)imageDict;

@end

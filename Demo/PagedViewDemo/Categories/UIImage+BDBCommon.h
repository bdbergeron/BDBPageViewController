//
//  UIImage+BDBCommon.h
//  PagedViewDemo
//
//  Created by Bradley Bergeron on 10/12/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -
@interface UIImage (BDBCommon)

#pragma mark Scaling
+ (instancetype)imageByScalingImageAtURL:(NSURL *)imageURL toSize:(CGSize)scaledSize;

#pragma mark Properties
+ (NSDictionary *)propertiesForImageAtURL:(NSURL *)imageURL;
+ (CGSize)sizeForImageAtURL:(NSURL *)imageURL;

@end

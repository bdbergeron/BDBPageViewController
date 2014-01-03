//
//  UIImage+BDBCommon.m
//  PagedViewDemo
//
//  Created by Bradley Bergeron on 10/12/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import <ImageIO/ImageIO.h>

#import "NSString+BDBCommon.h"
#import "UIImage+BDBCommon.h"


#pragma mark -
@implementation UIImage (BDBCommon)

#pragma mark Scaling
+ (instancetype)imageByScalingImageAtURL:(NSURL *)imageURL toSize:(CGSize)scaledSize
{
    NSParameterAssert(imageURL);
    NSParameterAssert(!CGSizeEqualToSize(scaledSize, CGSizeZero));

    static NSCache *_scaledImageCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _scaledImageCache = [NSCache new];
    });

    CGFloat width  = scaledSize.width * [[UIScreen mainScreen] scale];
    CGFloat height = scaledSize.height * [[UIScreen mainScreen] scale];

    NSString *identifier = [NSString stringWithFormat:@"%@_%0.fx%0.f@%0.0fx", [imageURL.path MD5Hash], scaledSize.width, scaledSize.height, [[UIScreen mainScreen] scale]];

    UIImage *scaledImage = [_scaledImageCache objectForKey:identifier];
    if (!scaledImage)
    {
        CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)(imageURL), NULL);
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], kCGImageSourceCreateThumbnailWithTransform,
                                 [NSNumber numberWithBool:YES], kCGImageSourceCreateThumbnailFromImageAlways,
                                 [NSNumber numberWithBool:YES], kCGImageSourceShouldAllowFloat,
                                 [NSNumber numberWithFloat:MAX(roundf(width), roundf(height))], kCGImageSourceThumbnailMaxPixelSize,
                                 nil];
        scaledImage = [UIImage imageWithCGImage:CGImageSourceCreateThumbnailAtIndex(imageSource, 0, (__bridge CFDictionaryRef)(options))];

        [_scaledImageCache setObject:scaledImage forKey:identifier];
    }

    return scaledImage;
}

#pragma mark Properties
+ (NSDictionary *)propertiesForImageAtURL:(NSURL *)imageURL
{
    NSDictionary *properties = nil;
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)imageURL, NULL);
    if (imageSource)
    {
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:NO], (NSString *)kCGImageSourceShouldCache,
                                 nil];
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (__bridge CFDictionaryRef)(options));
        if (imageProperties)
        {
            properties = [NSDictionary dictionaryWithDictionary:(__bridge NSDictionary *)(imageProperties)];
            CFRelease(imageProperties);
        }
        CFRelease(imageSource);
    }
    return properties;
}

+ (CGSize)sizeForImageAtURL:(NSURL *)imageURL
{
    CGSize imageSize = CGSizeZero;
    NSDictionary *imageProperties = [[self class] propertiesForImageAtURL:imageURL];
    if (imageProperties)
    {
        NSNumber *width  = imageProperties[(NSString *)kCGImagePropertyPixelWidth];
        NSNumber *height = imageProperties[(NSString *)kCGImagePropertyPixelHeight];
        if (width && height)
            imageSize = CGSizeMake(width.floatValue, height.floatValue);
    }
    return imageSize;
}

@end

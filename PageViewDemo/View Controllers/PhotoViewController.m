//
//  PhotoViewController.m
//  PagedViewDemo
//
//  Created by Bradley Bergeron on 10/12/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import "PhotoViewController.h"

#import "UIImage+BDBCommon.h"


#pragma mark -
@interface PhotoViewController ()

@property (nonatomic) NSArray *photos;
@property (nonatomic, readwrite) NSUInteger selectedIndex;

@end


#pragma mark -
@implementation PhotoViewController

- (id)initWithPhotos:(NSArray *)photos selectedIndex:(NSUInteger)index
{
    self = [super initWithPageAtIndex:index];
    if (self)
    {
        _photos = photos;
        _selectedIndex = index;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.pageView registerClass:[BDBPageViewImagePage class] forPageWithReuseIdentifier:@"Photo"];
}

#pragma mark BDBPageViewDelegate
- (NSUInteger)numberOfPagesInPageView:(BDBPageView *)pageView
{
    return self.photos.count;
}

- (BDBPageViewImagePage *)pageView:(BDBPageView *)pageView pageForItemAtIndex:(NSUInteger)index
{
    static NSString *identifier = @"Photo";
    BDBPageViewImagePage *page = (BDBPageViewImagePage *)[pageView dequeueReusablePageWithIdentifier:identifier forIndex:index];
    page.delegate = self;

    Photo *photo = self.photos[index];
    page.image = [UIImage imageByScalingImageAtURL:photo.imageURL toSize:CGSizeMake(1024, 1024)];

    return page;
}

#pragma mark BDBPageViewImagePageDelegate
- (NSString *)pageView:(BDBPageView *)pageView titleForImageCaptionAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (UIView *)pageView:(BDBPageView *)pageView viewForImageCaptionAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end

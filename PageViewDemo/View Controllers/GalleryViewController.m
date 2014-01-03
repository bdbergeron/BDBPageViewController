//
//  GalleryViewController.m
//  PagedViewDemo
//
//  Created by Bradley Bergeron on 10/12/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import <ImageIO/ImageIO.h>

#import "GalleryViewController.h"
#import "Photo.h"
#import "PhotoViewController.h"

#import "UIImage+BDBCommon.h"


#pragma mark -
@interface GalleryViewController ()

@property (nonatomic) NSURL   *photosDirectory;
@property (nonatomic) NSArray *photos;

@end


#pragma mark -
@implementation GalleryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Photos";

    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = YES;

    [self.collectionView registerClass:[GalleryCell class] forCellWithReuseIdentifier:@"GalleryCell"];

    NSURL *plistURL = [[NSBundle mainBundle] URLForResource:@"Pictures" withExtension:@"plist" subdirectory:@"Pictures"];
    NSAssert(plistURL, @"Pictures.plist cannot be found. Please be sure it exists and is being copied into the bundle.");

    self.photosDirectory = [plistURL URLByDeletingLastPathComponent];
    NSArray *photoPlist = [NSMutableArray arrayWithContentsOfURL:plistURL];
    NSMutableArray *mutablePhotos = [NSMutableArray array];
    for (NSDictionary *photoInfo in photoPlist)
    {
        NSMutableDictionary *mutableInfo = photoInfo.mutableCopy;
        mutableInfo[@"URL"] = [self.photosDirectory URLByAppendingPathComponent:mutableInfo[@"Filename"]];
        Photo *photo = [[Photo alloc] initWithDictionary:mutableInfo];
        [mutablePhotos addObject:photo];
    }

    self.photos = [NSArray arrayWithArray:mutablePhotos];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GalleryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GalleryCell" forIndexPath:indexPath];

    Photo *photo = self.photos[indexPath.row];
    cell.imageView.image = [UIImage imageByScalingImageAtURL:photo.imageURL toSize:cell.frame.size];

    return cell;
}

#pragma mark UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoViewController *photoVC = [[PhotoViewController alloc] initWithPhotos:self.photos selectedIndex:indexPath.row];
    [self.navigationController pushViewController:photoVC animated:YES];
}

#pragma mark UICollectionView Layout Delegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:section];
}

#pragma mark NHBalancedFlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(NHBalancedFlowLayout *)collectionViewLayout
preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Photo *photo = self.photos[indexPath.row];
    return [UIImage sizeForImageAtURL:photo.imageURL];
}

@end

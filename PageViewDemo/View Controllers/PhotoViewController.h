//
//  PhotoViewController.h
//  PagedViewDemo
//
//  Created by Bradley Bergeron on 10/12/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BDBPageViewController.h"
#import "BDBPageViewImagePage.h"
#import "Photo.h"


#pragma mark -
@interface PhotoViewController : BDBPageViewController
<BDBPageViewImagePageDelegate>

@property (nonatomic, readonly) NSUInteger selectedIndex;

- (id)initWithPhotos:(NSArray *)photos selectedIndex:(NSUInteger)selected;

@end

//
//  BDBPageViewImagePage.h
//
//  Copyright (c) 2013 Bradley David Bergeron
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <UIKit/UIKit.h>

#import "BDBPageView.h"


@protocol BDBPageViewImagePageDelegate;

#pragma mark -
/**
 *  A BDBPageViewPage subclass that is useful for displaying images with built-in support for
 *  zooming and panning.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
@interface BDBPageViewImagePage : BDBPageViewPage
<UIScrollViewDelegate>

/**
 *  The object that acts as the delegate of the page.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
@property (nonatomic, weak) id <BDBPageViewImagePageDelegate> delegate;

/**
 *  The image to be displayed.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
@property (nonatomic) UIImage *image;

@end


#pragma mark -
/**
 *  A class conforming
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
@protocol BDBPageViewImagePageDelegate <NSObject>

@optional
/**
 *  Returns the title for the caption to be displayed with the image at the given index path.
 *
 *  @param pageView  The BDBPageView object requesting this information.
 *  @param indexPath Index path of the image being displayed.
 *
 *  @return The title for the caption to be displayed with the image at the specified index path.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
- (NSString *)pageView:(BDBPageView *)pageView titleForImageCaptionAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  Returns the view for the caption to be displayed with the image at the given index path.
 *
 *  @param pageView  The BDBPageView object requesting this information.
 *  @param indexPath Index path of the image being displayed.
 *
 *  @return The view for the caption to be displayed with the image at the specified index path.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
- (UIView *)pageView:(BDBPageView *)pageView viewForImageCaptionAtIndexPath:(NSIndexPath *)indexPath;

@end

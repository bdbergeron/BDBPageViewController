//
//  BDBPageViewController.h
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


#pragma mark -
/**
 *  The BDBPageViewController class creates a controller object that manages a paged view.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
@interface BDBPageViewController : UIViewController
<BDBPageViewDataSource, BDBPageViewDelegate>

/**
 *  ---------------------------------------------------------------------------------------
 *  @name Creating a Page View
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Create a new page view controller with the specified page displayed.
 *
 *  @param index Index of the page to be displayed.
 *
 *  @return A BDBPageViewController object with the specified page displayed.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
- (id)initWithPageAtIndex:(NSUInteger)index;

/**
 *  ---------------------------------------------------------------------------------------
 *  @name Getting the Page View
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  Returns the paged view managed by the controller object.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
@property (nonatomic) BDBPageView *pageView;

@end

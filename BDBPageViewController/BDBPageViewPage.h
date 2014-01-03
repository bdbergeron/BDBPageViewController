//
//  BDBPageViewPage.h
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

#import <Foundation/Foundation.h>


#pragma mark -
/**
 *  A BDBPageViewPage object presents the content for a single data item when that item is within
 *  the paged view's visible vounds. You can use this class as-is or subclass it to add additional
 *  properties and methods. The layout and presentation of pages is managed by the page view and its
 *  corresponding layout object.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
@interface BDBPageViewPage : UIView

/**
 *  ---------------------------------------------------------------------------------------
 *  @name Accessing the Page's Views
 *  ---------------------------------------------------------------------------------------
 */

/**
 *  The view that is displayed behind the page's other content.
 *
 *  Use this property to assign a custom background view to the page. The background view is placed
 *  behind the content view and its frame is automatically adjusted so that it fills the bounds of
 *  the page.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
@property (nonatomic) UIView *backgroundView;

/**
 *  The main view to which you add your page's custom content. (read-only)
 *
 *  When configuring a page, you add any custom views representing your page's content to this view.
 *  The page object places the content in this view in front of any background views.
 *
 *  @since Available in BDBPageViewController 1.0.0 and higher.
 */
@property (nonatomic, readonly) UIView *contentView;

@end

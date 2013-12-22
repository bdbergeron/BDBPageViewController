//
//  BDBPagedViewController.h
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

#import "BDBPagedView.h"
#import "BDBPagedImageView.h"


#pragma mark -
@protocol BDBPagedViewDelegate
<NSObject>

@optional
- (void)willDisplayPagedView:(BDBPagedView *)pagedView;
- (void)didDisplayPagedView:(BDBPagedView *)pagedView;

@end


#pragma mark -
@protocol BDBPagedViewDataSource
<NSObject>

@required
- (NSUInteger)numberOfPagedViews;
- (BDBPagedView *)pagedViewForIndex:(NSUInteger)index;

@end


#pragma mark -
@interface BDBPagedViewController : UIViewController
<UIScrollViewDelegate, BDBPagedViewDataSource, BDBPagedViewDelegate, BDBPagedImageViewDelegate>

@property (nonatomic, weak) id <BDBPagedViewDelegate> delegate;
@property (nonatomic, weak) id <BDBPagedViewDataSource> dataSource;

@property (nonatomic, readonly) NSUInteger currentIndex;

- (BDBPagedView *)dequeueReusablePagedViewWithIdentifier:(NSString *)identifier;

- (void)reloadPages;

- (void)setCurrentIndex:(NSUInteger)currentIndex;

- (void)showNextPageAnimated:(BOOL)animated;
- (void)showPreviousPageAnimated:(BOOL)animated;

@end

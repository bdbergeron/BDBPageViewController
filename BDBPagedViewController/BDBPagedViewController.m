//
//  BDBPagedViewController.m
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

#import "BDBPagedViewController.h"

#import "BDBPagedView+Private.h"


#pragma mark -
@interface BDBPagedViewController ()

@property (nonatomic) UIScrollView *scrollView;

@property (nonatomic) NSMutableDictionary *reusablePages;
@property (nonatomic) NSMutableSet *visiblePages;

- (void)layoutPages;

- (void)enqueueReusablePagedView:(BDBPagedView *)pagedView withIdentifier:(NSString *)identifier;

- (CGSize)contentSizeForPagingScrollView;

@end


#pragma mark -
@implementation BDBPagedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _delegate = self;
    _dataSource = self;

    _reusablePages = [NSMutableDictionary dictionary];
    _visiblePages  = [NSMutableSet set];

    _currentIndex = 0;

    self.wantsFullScreenLayout = YES;
    self.hidesBottomBarWhenPushed = YES;

    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
        self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)dealloc
{
    _delegate = nil;
    _dataSource = nil;
    _scrollView.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [_reusablePages removeAllObjects];
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.view.clipsToBounds = YES;

    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.contentSize = [self contentSizeForViewInPopover];
    [self.view addSubview:self.scrollView];

    [self reloadPages];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    [self.visiblePages enumerateObjectsUsingBlock:^(BDBPagedView *pagedView, BOOL *stop) {
        if ([self.delegate respondsToSelector:@selector(didDisplayPagedView:)])
            [self.delegate didDisplayPagedView:pagedView];
    }];
}

#pragma mark Layout
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    NSInteger preservedIndex = self.currentIndex;

    self.scrollView.contentSize = [self contentSizeForPagingScrollView];
    self.scrollView.contentOffset = [self contentOffsetForPageAtIndex:preservedIndex];
}

- (void)layoutPages
{
    CGRect visibleBounds = self.scrollView.bounds;
    NSInteger pagedViewCount = [self.dataSource numberOfPagedViews];

    NSInteger firstIndex = floorf(CGRectGetMinX(visibleBounds) / visibleBounds.size.width);
    if (firstIndex < 0)
        firstIndex = 0;
    else if (firstIndex > pagedViewCount - 1)
        firstIndex = pagedViewCount - 1;

    NSInteger lastIndex  = floorf(CGRectGetMaxX(visibleBounds) / visibleBounds.size.width);
    if (lastIndex < 0)
        lastIndex = 0;
    else if (lastIndex > pagedViewCount - 1)
        lastIndex = pagedViewCount - 1;

    NSArray *visiblePages = [self.visiblePages copy];
    [visiblePages enumerateObjectsUsingBlock:^(BDBPagedView *pagedView, NSUInteger idx, BOOL *stop) {
        if (pagedView.index < firstIndex || pagedView.index > lastIndex)
        {
            [self enqueueReusablePagedView:pagedView withIdentifier:pagedView.reuseIdentifier];
            [self.visiblePages removeObject:pagedView];
        }
    }];

    for (NSInteger idx = firstIndex; idx <= lastIndex; idx++)
    {
        BDBPagedView *pagedView = [self.dataSource pagedViewForIndex:idx];
        if (![self.visiblePages containsObject:pagedView])
        {
            if (pagedView.index == NSNotFound)
                pagedView.index = idx;
            [self.visiblePages addObject:pagedView];

            CGRect pageFrame = visibleBounds;
            pageFrame.origin.x = visibleBounds.size.width * idx;

            pagedView.frame = CGRectIntegral(pageFrame);
            [self.scrollView addSubview:pagedView];
        }

        if ([self.delegate respondsToSelector:@selector(willDisplayPagedView:)])
            [self.delegate willDisplayPagedView:pagedView];
    }

    self.scrollView.contentOffset = [self contentOffsetForPageAtIndex:self.currentIndex];
}

- (void)reloadPages
{
    self.currentIndex = 0;
    [self layoutPages];

    [self.view setNeedsLayout];
}

#pragma mark Framing
- (CGSize)contentSizeForPagingScrollView
{
    CGRect bounds = self.scrollView.bounds;
    return CGSizeMake(bounds.size.width * [self numberOfPagedViews], bounds.size.height);
}

- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)idx
{
    return CGPointMake(self.scrollView.bounds.size.width * idx, 0);
}

#pragma mark BDBPagedView Management
- (BDBPagedView *)dequeueReusablePagedViewWithIdentifier:(NSString *)identifier
{
    NSMutableSet *reusablePages = self.reusablePages[identifier];
    if (reusablePages && reusablePages.count > 0)
    {
        BDBPagedView *pagedView = reusablePages.anyObject;
        [reusablePages removeObject:pagedView];
        return pagedView;
    }
    else
        return nil;
}

- (void)enqueueReusablePagedView:(BDBPagedView *)pagedView withIdentifier:(NSString *)identifier
{
    NSMutableSet *reusablePages = self.reusablePages[identifier];
    if (!reusablePages)
    {
        reusablePages = [NSMutableSet set];
        self.reusablePages[identifier] = reusablePages;
    }
    [reusablePages addObject:pagedView];
    [pagedView removeFromSuperview];
    [pagedView prepareForReuse];
}

#pragma mark BDBPagedView Data Source
- (NSUInteger)numberOfPagedViews
{
    return 1;
}

- (BDBPagedView *)pagedViewForIndex:(NSUInteger)index
{
    static NSString *_reuseIdentifier = @"BDBPageView";
    BDBPagedView *pagedView = [self dequeueReusablePagedViewWithIdentifier:_reuseIdentifier];
    if (!pagedView)
        pagedView = [[BDBPagedView alloc] initWithReuseIdentifier:_reuseIdentifier];

    return pagedView;
}

#pragma mark Paging
- (void)setCurrentIndex:(NSUInteger)idx
{
    _currentIndex = idx;
}

- (void)showNextPageAnimated:(BOOL)animated
{

}

- (void)showPreviousPageAnimated:(BOOL)animated
{

}

@end

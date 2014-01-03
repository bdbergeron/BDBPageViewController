//
//  BDBPageView.m
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

#import "BDBPageView.h"
#import "BDBPageView+Private.h"
#import "BDBPageViewPage+Private.h"


#pragma mark -
@interface BDBPageView ()

@property (nonatomic) UIScrollView *scrollView;

@property (nonatomic) NSMutableDictionary *reusablePages;
@property (nonatomic) NSSet *visiblePages;

@property (nonatomic) NSMutableDictionary *registeredPageNibsOrClasses;

@property (nonatomic) BOOL performingLayout;

- (void)layoutPages;
- (void)layoutVisiblePages;

- (void)enqueueReusablePage:(BDBPageViewPage *)page withIdentifier:(NSString *)identifier;

@end


#pragma mark -
@implementation BDBPageView

#pragma mark Initialization
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _reusablePages = [NSMutableDictionary dictionary];
        _visiblePages  = [NSMutableSet set];

        _registeredPageNibsOrClasses = [NSMutableDictionary dictionary];

        self.scrollView = [[UIScrollView alloc] initWithFrame:[self frameForScrollView]];
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

#pragma mark Configuring a Page View
- (NSUInteger)numberOfPages
{
    return [self.dataSource numberOfPagesInPageView:self];
}

#pragma mark Creating Pages
- (void)registerClass:(Class)pageClass forPageWithReuseIdentifier:(NSString *)identifier
{
    NSParameterAssert(identifier);

    if (pageClass)
        self.registeredPageNibsOrClasses[identifier] = NSStringFromClass(pageClass);
    else
        [self.registeredPageNibsOrClasses removeObjectForKey:identifier];
}

- (void)registerNib:(UINib *)pageNib forPageWithReuseIdentifier:(NSString *)identifier
{
    NSParameterAssert(identifier);

    if (pageNib)
        self.registeredPageNibsOrClasses[identifier] = pageNib;
    else
        [self.registeredPageNibsOrClasses removeObjectForKey:identifier];
}

- (void)enqueueReusablePage:(BDBPageViewPage *)page withIdentifier:(NSString *)identifier
{
    NSMutableSet *pagesForIdentifier = self.reusablePages[identifier];
    if (!pagesForIdentifier)
    {
        pagesForIdentifier = [NSMutableSet set];
        self.reusablePages[identifier] = pagesForIdentifier;
    }
    [pagesForIdentifier addObject:page];
    [page removeFromSuperview];
}

- (BDBPageViewPage *)dequeueReusablePageWithIdentifier:(NSString *)identifier forIndex:(NSUInteger)index
{
    __block BDBPageViewPage *reusablePage = nil;

    NSMutableSet *pagesForIdentifier = self.reusablePages[identifier];
    if (pagesForIdentifier && pagesForIdentifier.count > 0)
    {
        reusablePage = pagesForIdentifier.anyObject;
        [pagesForIdentifier removeObject:reusablePage];
        [reusablePage prepareForReuse];
        return reusablePage;
    }
    else
    {
        NSAssert(self.registeredPageNibsOrClasses[identifier],
                 @"The identifier '%@' is not associated with any registered BDBPageViewPage class or nib conforming to BDBPageViewPage.",
                 identifier);

        if ([self.registeredPageNibsOrClasses[identifier] isKindOfClass:[NSString class]])
        {
            reusablePage = [NSClassFromString(self.registeredPageNibsOrClasses[identifier]) new];
            reusablePage.reuseIdentifier = identifier;
        }
        else
        {
            UINib *pageNib = self.registeredPageNibsOrClasses[identifier];
            reusablePage = [pageNib instantiateWithOwner:nil options:nil][0];
            reusablePage.reuseIdentifier = identifier;
        }

        [reusablePage prepareForReuse];
        return reusablePage;
    }
}

#pragma mark Reloading the Page View
- (void)reloadData
{
    self.visiblePages = [NSSet set];
    [self.reusablePages removeAllObjects];

    if ([self.delegate respondsToSelector:@selector(pageView:willDisplayPage:forItemAtIndex:)])
        [self.delegate pageView:self willDisplayPage:[self pageForItemAtIndex:self.currentPageIndex] forItemAtIndex:self.currentPageIndex];

    [self layoutPages];

    if ([self.delegate respondsToSelector:@selector(pageView:didDisplayPage:forItemAtIndex:)])
        [self.delegate pageView:self didDisplayPage:[self pageForItemAtIndex:self.currentPageIndex] forItemAtIndex:self.currentPageIndex];

    self.scrollView.contentSize = [self contentSizeForScrollView];
    self.scrollView.contentOffset = [self contentOffsetForPageAtIndex:self.currentPageIndex];

    [self setNeedsLayout];
}

#pragma mark Laying Out the Page View
- (void)layoutPages
{
    self.performingLayout = YES;

    CGRect visibleBounds = self.scrollView.bounds;
    NSUInteger numberOfPages = [self numberOfPages];

    NSInteger iFirst = floorf(CGRectGetMinX(visibleBounds) / visibleBounds.size.width) - 1;
    if (iFirst < 0)
        iFirst = 0;
    if (iFirst > numberOfPages - 1)
        iFirst = numberOfPages - 1;

    NSInteger iLast = floorf(CGRectGetMaxX(visibleBounds) / visibleBounds.size.width);
    if (iLast < 0)
        iLast = 0;
    if (iLast > numberOfPages - 1)
        iLast = numberOfPages - 1;

    NSMutableSet *mutableVisiblePages = self.visiblePages.mutableCopy;

    // Remove and enqueue any pages that are no longer visible.
    [self.visiblePages enumerateObjectsUsingBlock:^(BDBPageViewPage *page, BOOL *stop) {
        if (page.index < (NSUInteger)iFirst || page.index > (NSUInteger)iLast)
        {
            [self enqueueReusablePage:page withIdentifier:page.reuseIdentifier];
            [mutableVisiblePages removeObject:page];
        }
    }];

    // Layout visible pages.
    for (NSUInteger index = (NSUInteger)iFirst; index <= (NSUInteger)iLast; index++)
    {
//        __block BDBPageViewPage *pageForIndex = nil;
//        [mutableVisiblePages enumerateObjectsUsingBlock:^(BDBPageViewPage *page, BOOL *stop) {
//            if (page.index == index)
//            {
//                pageForIndex = page;
//                *stop = YES;
//            }
//        }];

        BDBPageViewPage *pageForIndex = [self.dataSource pageView:self pageForItemAtIndex:index];
        if (![mutableVisiblePages containsObject:pageForIndex])
        {
            pageForIndex = [self.dataSource pageView:self pageForItemAtIndex:index];
            pageForIndex.index = index;

            [mutableVisiblePages addObject:pageForIndex];

            [self.scrollView addSubview:pageForIndex];
            [mutableVisiblePages addObject:pageForIndex];
        }

        pageForIndex.frame = [self frameForPageAtIndex:index];
        pageForIndex.contentView.frame = CGRectInset(pageForIndex.bounds, [self pagePadding], 0);
    }

    self.visiblePages = mutableVisiblePages;

    self.performingLayout = NO;
}

- (void)layoutVisiblePages
{
    self.performingLayout = YES;

    NSUInteger indexPriorToLayout = self.currentPageIndex;

    self.scrollView.frame = [self frameForScrollView];
    self.scrollView.contentSize = [self contentSizeForScrollView];

    [self.visiblePages enumerateObjectsUsingBlock:^(BDBPageViewPage *page, BOOL *stop) {
        page.frame = [self frameForPageAtIndex:page.index];
    }];

    self.scrollView.contentOffset = [self contentOffsetForPageAtIndex:indexPriorToLayout];

    _currentPageIndex = indexPriorToLayout;

    self.performingLayout = NO;
}

- (CGRect)frameForScrollView
{
    CGRect bounds = self.bounds;
    bounds.origin.x -= [self pagePadding];
    bounds.size.width += 2 * [self pagePadding];
    return CGRectIntegral(bounds);
}

- (CGSize)contentSizeForScrollView
{
    CGRect bounds = self.scrollView.bounds;
    return CGSizeMake(bounds.size.width * [self numberOfPages], bounds.size.height);
}

- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)index
{
    CGFloat pageWidth = self.scrollView.bounds.size.width;
    return CGPointMake(pageWidth * index, 0);
}

- (CGFloat)pagePadding
{
    CGFloat padding = 20.0;
    if ([self.delegate respondsToSelector:@selector(paddingForPageView:)])
        padding = [self.delegate paddingForPageView:self];
    return padding;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index
{
    CGRect bounds = self.scrollView.bounds;

    CGRect pageFrame = bounds;
    pageFrame.origin.x = (bounds.size.width * index) + [self pagePadding];
    pageFrame.size.width -= 2 * [self pagePadding];
    return CGRectIntegral(pageFrame);
}

#pragma mark Accessing Pages
- (void)setCurrentPageIndex:(NSUInteger)index
{
    if (index > [self numberOfPages] - 1)
        index = [self numberOfPages] - 1;

    if (_currentPageIndex != index)
    {
        _currentPageIndex = index;

        if ([self.delegate respondsToSelector:@selector(pageView:willDisplayPage:forItemAtIndex:)])
            [self.delegate pageView:self willDisplayPage:[self pageForItemAtIndex:index] forItemAtIndex:index];

        self.scrollView.contentOffset = [self contentOffsetForPageAtIndex:index];

        [self layoutPages];

        if ([self.delegate respondsToSelector:@selector(pageView:didDisplayPage:forItemAtIndex:)])
            [self.delegate pageView:self didDisplayPage:[self pageForItemAtIndex:index] forItemAtIndex:index];
    }
}

- (BDBPageViewPage *)pageForItemAtIndex:(NSUInteger)index
{
    __block BDBPageViewPage *pageAtIndex = nil;
    [self.visiblePages enumerateObjectsUsingBlock:^(BDBPageViewPage *page, BOOL *stop) {
        if (page.index == index)
        {
            pageAtIndex = page;
            *stop = YES;
        }
    }];
    return pageAtIndex;
}

- (NSUInteger)indexForPage:(BDBPageViewPage *)requestedPage
{
    __block NSUInteger indexForPage = NSUIntegerMax;
    [self.visiblePages enumerateObjectsUsingBlock:^(BDBPageViewPage *page, BOOL *stop) {
        if ([page isEqual:requestedPage])
        {
            indexForPage = page.index;
            *stop = YES;
        }
    }];
    return indexForPage;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (fmodf(scrollView.contentOffset.x, scrollView.bounds.size.width) != 0.0)
        return;

    CGRect visibleBounds = scrollView.bounds;
    NSInteger index = floorf(CGRectGetMinX(visibleBounds) / visibleBounds.size.width);
    if (index < 0)
        index = 0;
    if (index > [self numberOfPages] - 1)
        index = [self numberOfPages] - 1;

    NSUInteger oldCurrentPageIndex = self.currentPageIndex;
    _currentPageIndex = index;

    if (index != oldCurrentPageIndex)
    {
        if ([self.delegate respondsToSelector:@selector(pageView:willDisplayPage:forItemAtIndex:)])
            [self.delegate pageView:self willDisplayPage:[self pageForItemAtIndex:index] forItemAtIndex:index];

        [self layoutPages];

        if ([self.delegate respondsToSelector:@selector(pageView:didDisplayPage:forItemAtIndex:)])
            [self.delegate pageView:self didDisplayPage:[self pageForItemAtIndex:index] forItemAtIndex:index];
    }
}

#pragma mark Navigating Through Pages
- (void)showNextPageAnimated:(BOOL)animated
{

}

- (void)showPreviousPageAnimated:(BOOL)animated
{

}

@end

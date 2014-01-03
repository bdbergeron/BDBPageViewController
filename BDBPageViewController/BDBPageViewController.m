//
//  BDBPageViewController.m
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

#import "BDBPageViewController.h"
#import "BDBPageView+Private.h"


#pragma mark -
@interface BDBPageViewController ()

@property (nonatomic) BOOL hasReloaded;

@property (nonatomic) NSUInteger initialPageIndex;
@property (nonatomic) NSUInteger pageIndexBeforeRotation;

@end


#pragma mark -
@implementation BDBPageViewController

- (id)init
{
    return [self initWithPageAtIndex:0];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithPageAtIndex:0];
}

- (id)initWithPageAtIndex:(NSUInteger)index
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _initialPageIndex = index;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.pageView = [[BDBPageView alloc] initWithFrame:self.view.frame];
    self.pageView.delegate = self;
    self.pageView.dataSource = self;

    self.view.backgroundColor = [UIColor whiteColor];
    self.view.clipsToBounds = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.hidesBottomBarWhenPushed = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!self.hasReloaded)
    {
        self.pageView.currentPageIndex = self.initialPageIndex;
        [self.pageView reloadData];
        self.hasReloaded = YES;
    }
}

#pragma mark Properties
- (BDBPageView *)pageView
{
    return (BDBPageView *)self.view;
}

- (void)setPageView:(BDBPageView *)pageView
{
    self.view = pageView;
}

#pragma mark Rotation
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    self.pageIndexBeforeRotation = self.pageView.currentPageIndex;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    self.pageView.currentPageIndex = _pageIndexBeforeRotation;
    [self.pageView layoutVisiblePages];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

}

#pragma mark BDBPageViewDelegate
- (NSUInteger)numberOfPagesInPageView:(BDBPageView *)pageView
{
    return 0;
}

- (BDBPageViewPage *)pageView:(BDBPageView *)pageView pageForItemAtIndex:(NSUInteger)index
{
    return nil;
}

#pragma mark Description
- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@: %p; pageView = %@>", NSStringFromClass([self class]), self, self.pageView];
}

@end

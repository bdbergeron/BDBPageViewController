//
//  BDBPageViewPage.m
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

#import "BDBPageViewPage.h"

#import "BDBPageViewPage+Private.h"


static void * const kBDBPageViewPageKVOContext = (void *)&kBDBPageViewPageKVOContext;


#pragma mark -
@interface BDBPageViewPage ()

@property (nonatomic, readwrite) UIView *contentView;

@property (nonatomic, readwrite) NSUInteger index;
@property (nonatomic, readwrite) NSString *reuseIdentifier;

- (void)prepareForReuse;

@end


#pragma mark -
@implementation BDBPageViewPage

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _contentView = [[UIView alloc] initWithFrame:frame];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];

        UIView *backgroundView = [[UIView alloc] initWithFrame:frame];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView = backgroundView;
    }
    return self;
}

- (id)init
{
    return [self initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    const CGRect bounds = self.bounds;
    CGRect contentFrame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);

    _backgroundView.frame = contentFrame;
    _contentView.frame = contentFrame;

    [self sendSubviewToBack:_backgroundView];
    [self bringSubviewToFront:_contentView];
}

- (void)setBackgroundView:(UIView *)backgroundView
{
    if (![backgroundView isEqual:_backgroundView])
    {
        [_backgroundView removeFromSuperview];
        _backgroundView = backgroundView;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_backgroundView];
    }
}

- (void)prepareForReuse
{
    NSArray *subviews = self.contentView.subviews;
    [subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        [subview removeFromSuperview];
    }];
}

@end

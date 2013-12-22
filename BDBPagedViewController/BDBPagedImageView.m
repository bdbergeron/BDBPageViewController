//
//  BDBPagedImageView.m
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

#import "BDBPagedImageView.h"


#pragma mark -
@interface BDBPagedImageView ()

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIImageView *imageView;

@end


#pragma mark -
@implementation BDBPagedImageView

- (id)initWithReuseIdentifier:(NSString *)identifier
{
    self = [super initWithReuseIdentifier:identifier];
    if (self)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        [self addSubview:_scrollView];
        _scrollView.delegate = self;

        _imageView = [[UIImageView alloc] initWithFrame:_scrollView.frame];
        [_scrollView addSubview:_imageView];
        _imageView.backgroundColor = [UIColor blackColor];

        _scrollView.contentSize = _imageView.frame.size;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.scrollView.contentInset = UIEdgeInsetsZero;

    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;

    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;

    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;

    self.imageView.frame = frameToCenter;
}

#pragma mark Image
- (void)setImage:(UIImage *)image
{
    _image = image;
    if (image)
    {
        self.imageView.image = image;
        [self.imageView sizeToFit];

        self.scrollView.contentSize = image.size;

        CGFloat scaleX = self.bounds.size.width / image.size.width;
        CGFloat scaleY = self.bounds.size.height / image.size.height;
        CGFloat scaleFactor = MIN(scaleX, scaleY);

        if (scaleFactor > 2.0)
            scaleFactor = 2.0;

        self.scrollView.maximumZoomScale = 2.0;
        self.scrollView.minimumZoomScale = scaleFactor;
        self.scrollView.zoomScale = scaleFactor;
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateEnded)
        NSLog(@"Image received double-tap.");
}

#pragma mark Management
- (void)prepareForReuse
{
    [super prepareForReuse];

    self.image = nil;
    self.imageView.image = [UIImage imageNamed:@"ImagePlaceholder"];

    self.scrollView.contentSize = self.bounds.size;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 1.0;
    self.scrollView.zoomScale = 1.0;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{

}

@end

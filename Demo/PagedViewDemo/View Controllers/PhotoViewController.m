//
//  PhotoViewController.m
//  PagedViewDemo
//
//  Created by Bradley Bergeron on 10/12/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import "PhotoViewController.h"


#pragma mark -
@interface PhotoViewController ()

@property (nonatomic) UIImageView *imageView;

@property (nonatomic) Photo *photo;

@end


#pragma mark -
@implementation PhotoViewController

- (id)initWithPhoto:(Photo *)photo
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        _photo = photo;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];

    self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];

    self.imageView.image = [UIImage imageWithContentsOfFile:self.photo.imageURL.path];
}

@end

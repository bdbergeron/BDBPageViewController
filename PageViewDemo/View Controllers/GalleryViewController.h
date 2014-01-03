//
//  GalleryViewController.h
//  PagedViewDemo
//
//  Created by Bradley Bergeron on 10/12/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GalleryCell.h"
#import "NHBalancedFlowLayout.h"


#pragma mark -
@interface GalleryViewController : UICollectionViewController
<NHBalancedFlowLayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@end

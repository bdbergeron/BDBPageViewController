//
//  AppDelegate.m
//  PagedViewDemo
//
//  Created by Bradley Bergeron on 10/12/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import "AppDelegate.h"
#import "GalleryViewController.h"
#import "NHBalancedFlowLayout.h"


#pragma mark -
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    GalleryViewController *galleryVC = [[GalleryViewController alloc] initWithCollectionViewLayout:[NHBalancedFlowLayout new]];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:galleryVC];

    [self.window makeKeyAndVisible];
    return YES;
}

@end

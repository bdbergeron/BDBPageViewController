//
//  Photo.h
//  PagedViewDemo
//
//  Created by Bradley Bergeron on 22/12/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
@interface Photo : NSObject

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *caption;
@property (nonatomic, readonly) NSString *filename;
@property (nonatomic, readonly) NSURL *imageURL;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end

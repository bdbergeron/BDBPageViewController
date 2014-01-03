//
//  Photo.m
//  PagedViewDemo
//
//  Created by Bradley Bergeron on 22/12/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import "Photo.h"


#pragma mark -
@implementation Photo

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _title    = dictionary[@"Title"];
        _caption  = dictionary[@"Caption"];
        _filename = dictionary[@"Filename"];
        _imageURL = dictionary[@"URL"];
    }
    return self;
}

@end

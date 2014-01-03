//
//  NSString+BDBCommon.h
//  PagedViewDemo
//
//  Created by Bradley Bergeron on 10/12/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -
@interface NSString (BDBCommon)

#pragma mark Hashing
+ (instancetype)MD5HashForString:(NSString *)string;
- (NSString *)MD5Hash;
+ (instancetype)SHA1HashForString:(NSString *)string;
- (NSString*)SHA1Hash;

@end

//
//  NSString+BDBCommon.m
//  PagedViewDemo
//
//  Created by Bradley Bergeron on 10/12/13.
//  Copyright (c) 2013 Bradley Bergeron. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "NSString+BDBCommon.h"


#pragma mark -
@implementation NSString (BDBCommon)

#pragma mark Hashing
+ (instancetype)MD5HashForString:(NSString *)string
{
    return [[[[self class] alloc] initWithString:string] MD5Hash];
}

- (NSString *)MD5Hash
{
    const char *cStr = self.UTF8String;
    unsigned char digest[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];

    return output;
}

+ (instancetype)SHA1HashForString:(NSString *)string
{
    return [[[[self class] alloc] initWithString:string] SHA1Hash];
}

- (NSString*)SHA1Hash
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, (unsigned int)data.length, digest);

    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end

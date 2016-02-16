//
//  RuntimeUtility.m
//  Runtime
//
//  Created by Thomson on 16/1/27.
//  Copyright © 2016年 Thomson. All rights reserved.
//

#import "RuntimeUtility.h"
#import <UIKit/UIKit.h>

NSString *kBundleRootPath           = @"Bundles";

NSString *kBundleEmbedded           = @"Embedded";

@implementation RuntimeUtility

+ (NSString *)bundleRootPath
{
    return [self pathForName:kBundleRootPath];
}

+ (NSString *)pathForName:(NSString *)name
{
    if (!name) return nil;

    NSString *folder = [[NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()] stringByAppendingPathComponent:name];

    if (![[NSFileManager defaultManager] fileExistsAtPath:folder])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:folder
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
    }

    return folder;
}

+ (NSArray *)embeddedBundles
{
    NSString *plist = [[self bundleRootPath] stringByAppendingPathComponent:kBundleEmbedded];

    if (![[NSFileManager defaultManager] fileExistsAtPath:plist])
    {
        NSString *src = [[NSBundle mainBundle] pathForResource:kBundleEmbedded
                                                        ofType:@"plist"];

        [[NSFileManager defaultManager] copyItemAtPath:src toPath:plist error:nil];
    }

    return [NSArray arrayWithContentsOfFile:plist];
}

+ (void)updateEmbeddedBundles:(NSArray *)array
{
    if (!array) return;

    NSString *plist = [[self bundleRootPath] stringByAppendingPathComponent:kBundleEmbedded];

    [array writeToFile:plist atomically:YES];
}

@end

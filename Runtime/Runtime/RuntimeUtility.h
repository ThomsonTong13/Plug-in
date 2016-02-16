//
//  RuntimeUtility.h
//  Runtime
//
//  Created by Thomson on 16/1/27.
//  Copyright © 2016年 Thomson. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kBundleRootPath;
extern NSString *kBundleEmbedded;

@interface RuntimeUtility : NSObject

/**
 *  bundles install folder, will auto create the folder when the folder does not exist
 *
 *  @return NSString *
 */
+ (NSString *)bundleRootPath;

/**
 *  read embedded bundle plist
 *
 *  @return NSArray *
 */
+ (NSArray *)embeddedBundles;

/**
 *  save embedded plist
 *
 *  @param array
 */
+ (void)updateEmbeddedBundles:(NSArray *)array;

@end

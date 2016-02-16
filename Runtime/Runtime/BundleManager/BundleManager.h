//
//  BundleManager.h
//  Runtime
//
//  Created by Thomson on 16/1/27.
//  Copyright © 2016年 Thomson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Core/Core.h>

extern NSString const * kBIdentifier;
extern NSString const * kBVersion;
extern NSString const * kBFilePath;
extern NSString const * kBResources;
extern NSString const * kBName;

@class Bundle;

@interface BundleManager : NSObject <BundleProvider>

+ (instancetype)defaultBundleManager;

/**
 *  install embedded base bundles
 *
 *  @param completion block
 */
- (void)installEmbeddedBundles:(dispatch_block_t)completion;

/**
 *  install download bundle
 *
 *  @param aDownloadItem     BundleDownloadItem *
 *  @param completion block
 */
- (void)installBundle:(Bundle *)item withCompletion:(dispatch_block_t)completion;

- (NSArray *)bundles;

@end

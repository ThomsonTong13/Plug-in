//
//  Bundle.h
//  Runtime
//
//  Created by Thomson on 16/1/27.
//  Copyright © 2016年 Thomson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Core/Core.h>

typedef NS_ENUM(NSInteger, BundleStatus) {
    BundleNone = 0,
    BundleDownloading = 1,
    BundleDownloaded,
    BundleDownloadFailed,
    BundleInstalling,
    BundleInstalled,
    BundlePrepareLoad,
    BundleLoading,
    BundleLoaded,
    BundleLoadFailed
};

@interface Bundle : NSObject

+ (instancetype)bundleWithKeyInformation:(NSDictionary *)information;

/**
 *  an activator, to manage bundle life cycle
 */
@property (nonatomic, strong) id<BundleDelegate> principalObject;

/**
 *  the NSBundle *,  always load bundle as NSBundle
 */
@property (nonatomic, strong) NSBundle *bundle;

/**
 *  provide resource names
 */
@property (nonatomic, strong) NSArray *resources;

/**
 *  id.
 */
@property (nonatomic, copy) NSString *identifier;

/**
 *  current version
 */
@property (nonatomic, copy) NSString *version;

/**
 *  local saved file path
 */
@property (nonatomic, copy) NSString *filePath;

/**
 *  file name for .framework
 */
@property (nonatomic, copy) NSString *name;

/**
 *  optional, who instatlled?
 */
@property (nonatomic, copy) NSString *owner;

/**
 *  status for bundle
 */
@property (nonatomic) BundleStatus status;

- (BOOL)load;

- (BOOL)isLoaded;

/**
 *  the bundle install folder full path
 *
 *  @return NSString *
 */
- (NSString *)installFolder;

/**
 *  the .framework file full path
 *
 *  @return NSString *
 */
- (NSString *)fullFilePath;

/**
 *  key information for store
 *
 *  @return NSString *
 */
- (NSDictionary *)keyInformation;

@end

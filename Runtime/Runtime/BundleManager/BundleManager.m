//
//  BundleManager.m
//  Runtime
//
//  Created by Thomson on 16/1/27.
//  Copyright © 2016年 Thomson. All rights reserved.
//

#import "BundleManager.h"
#import "RuntimeUtility.h"
#import "Bundle.h"

@interface BundleManager ()
{
    NSMutableDictionary *_loadedBundles;

    NSMutableDictionary *_installedBundles;

    NSMutableDictionary *_routes;

    NSOperationQueue    *_bundleManagementQueue;
}

@end

@implementation BundleManager

+ (instancetype)defaultBundleManager
{
    static BundleManager *_sBundleManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sBundleManager = [[BundleManager alloc] init];
    });

    return _sBundleManager;
}

- (id)init
{
    self = [super init];

    if(self)
    {
        _loadedBundles      = [NSMutableDictionary dictionaryWithCapacity:0];
        _installedBundles   = [NSMutableDictionary dictionaryWithCapacity:0];

        _routes = [NSMutableDictionary dictionaryWithCapacity:0];

        _bundleManagementQueue = [[NSOperationQueue alloc] init];
        _bundleManagementQueue.maxConcurrentOperationCount = 1;

        [self loadInstalledList];
    }

    return self;
}

- (NSArray *)bundles
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];

    [array addObjectsFromArray:[_installedBundles allValues]];

    return array;
}

- (void)loadInstalledList
{
    NSArray *installed = [RuntimeUtility embeddedBundles];

    for (NSDictionary *item in installed)
    {
        Bundle *bundle = [Bundle bundleWithKeyInformation:item];

        if (bundle)
        {
            bundle.status = BundleInstalled;

            @synchronized(_installedBundles)
            {
                _installedBundles[bundle.identifier] = bundle;
            }

            @synchronized(_routes)
            {
                for (NSString *name in bundle.resources)
                {
                    _routes[name] = bundle;
                }
            }
        }
    }
}

#pragma mark - install & uninstall

- (void)installEmbeddedBundles:(dispatch_block_t)completion
{
    NSArray *innerBundles = [RuntimeUtility embeddedBundles];

    for (NSDictionary *item in innerBundles)
    {
        if (!_installedBundles[item[@"identifier"]])
        {
            [self installBundleItem:[Bundle bundleWithKeyInformation:item]];
        }
    }

    [self addMainQueueBlock:completion];
}

- (void)installBundle:(Bundle *)item withCompletion:(dispatch_block_t)completion
{
    if (BundleDownloaded != item.status) return;

    BundleManager *manager = self;

    dispatch_block_t installBlock  = ^{

        [manager updateDataBase:item];
    };

    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:installBlock];

    [_bundleManagementQueue addOperation:operation];

    [self addMainQueueBlock:completion];
}

- (void)addMainQueueBlock:(dispatch_block_t)block
{
    if (block)
    {
        dispatch_block_t installend  = ^{

            dispatch_async(dispatch_get_main_queue(), ^{
                block();
            });
        };

        NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:installend];

        [_bundleManagementQueue addOperation:operation];
    }
}

- (void)installBundleItem:(Bundle *)item
{
    [self installBundle:item withCompletion:nil];
}

- (BOOL)updateDataBase:(Bundle *)item
{
    if (!item || BundleInstalled != item.status) return NO;

    @synchronized(_installedBundles)
    {
        _installedBundles[item.identifier] = item;
    }

    @synchronized(_routes)
    {
        for (NSString *name in item.resources)
        {
            _routes[name] = item;
        }
    }

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (Bundle *item in _installedBundles.allValues)
    {
        [array addObject:[item keyInformation]];
    }

    [RuntimeUtility updateEmbeddedBundles:array];

    return YES;
}

#pragma mark - BundleProvider

- (id)bundleDelegateWithURI:(URI *)uri
{
    if (!uri) return nil;

    Bundle *bundle = _routes[uri.resourcePath];

    if (![bundle isLoaded])
    {
        [bundle load];
    }

    return [bundle isLoaded] ? bundle.principalObject : nil;
}

@end

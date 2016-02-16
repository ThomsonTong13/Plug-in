//
//  BundleDelegate.h
//  
//
//  Created by Thomson on 16/1/27.
//
//

#import <Foundation/Foundation.h>

@class URI;

/**
 *  All bussniess bundles should implement BundleDelegate, and set Principal class value as the auctal class name in Info.plist
 */
@protocol BundleDelegate <NSObject>

- (void)bundleDidLoad;

- (BOOL)bundleWillUnload;

- (void)didReceiveRemoteNotification:(NSDictionary *)info;

- (id)resourceWithURI:(URI *)uri;

@end

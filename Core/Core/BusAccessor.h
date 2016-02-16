//
//  BusAccessor.h
//  
//
//  Created by Thomson on 16/1/27.
//
//

#import <Foundation/Foundation.h>

@class URI;

@protocol BundleProvider <NSObject>

- (id)bundleDelegateWithURI:(URI *)uri;

@end

@interface BusAccessor : NSObject

@property (nonatomic, weak) id<BundleProvider> bundleProvider;

+ (instancetype)defaultBusAccessor;

- (id)resourceWithURI:(NSString *)uri;

- (id)resourceWithObject:(URI *)uri;

@end
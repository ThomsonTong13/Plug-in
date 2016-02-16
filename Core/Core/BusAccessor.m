//
//  BusAccessor.m
//  
//
//  Created by Thomson on 16/1/27.
//
//

#import "BusAccessor.h"
#import "BundleDelegate.h"
#import "URI.h"

@interface BusAccessor ()
{
}

@end

@implementation BusAccessor

@synthesize bundleProvider = _bundleProvider;

+ (instancetype)defaultBusAccessor
{
    static BusAccessor *_sBusAccessor = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sBusAccessor = [[BusAccessor alloc] init];
    });

    return _sBusAccessor;
}

- (instancetype)init
{
    self = [super init];

    return self;
}

- (id)resourceWithURI:(NSString *)uriString
{
    if (!uriString || !_bundleProvider) return nil;

    return [self resourceWithObject:[URI URIWithString:uriString]];
}

- (id)resourceWithObject:(URI *)uri
{
    if (!uri) return nil;

    id resource = nil;

    if ([_bundleProvider respondsToSelector:@selector(bundleDelegateWithURI:)])
    {
        id<BundleDelegate> delegate = [_bundleProvider bundleDelegateWithURI:uri];

        if(delegate && [delegate respondsToSelector:@selector(resourceWithURI:)])
        {
            resource = [delegate resourceWithURI:uri];
        }
    }

    return resource;
}

@end

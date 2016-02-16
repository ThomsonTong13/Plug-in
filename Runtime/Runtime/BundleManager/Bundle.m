//
//  Bundle.m
//  Runtime
//
//  Created by Thomson on 16/1/27.
//  Copyright © 2016年 Thomson. All rights reserved.
//

#import "Bundle.h"
#import "RuntimeUtility.h"

NSString const * kBIdentifier = @"identifier";
NSString const * kBVersion = @"version";
NSString const * kBFilePath = @"filePath";
NSString const * kBResources = @"resources";
NSString const * kBName = @"frameworkName";

@implementation Bundle

+ (instancetype)bundleWithKeyInformation:(NSDictionary *)information
{
    if (!information) return nil;

    Bundle *bundle = [[Bundle alloc] init];

    bundle.identifier   = information[kBIdentifier];
    bundle.resources    = information[kBResources];
    bundle.filePath     = information[kBFilePath];
    bundle.version      = information[kBVersion];
    bundle.name         = information[kBName];

    return bundle.identifier ?  bundle : nil;
}

- (instancetype)init
{
    self = [super init];

    if(self)
    {
        self.resources = @[];
    }

    return self;
}

- (BOOL)isLoaded
{
    return self.status == BundleLoaded;
}

- (BOOL)load
{
    if(self.status >= BundleLoading) return NO;

    self.status = BundleLoading;

    self.bundle = [NSBundle bundleWithPath:[self fullFilePath]];

    NSError *error = nil;

    if (![self.bundle preflightAndReturnError:&error])
    {
        NSLog(@"%@", error);
    }

    if (self.bundle && [self.bundle load])
    {
        self.status = BundleLoaded;

        self.principalObject = [[[self.bundle principalClass] alloc] init];

        if (self.principalObject && [self.principalObject respondsToSelector:@selector(bundleDidLoad)])
        {
            [self.principalObject performSelector:@selector(bundleDidLoad)];
        }
    }
    else
    {
        self.status = BundleLoadFailed;
    }

    return self.status == BundleLoaded;
}

- (NSString *)installFolder
{
    NSString *root = [RuntimeUtility bundleRootPath];

    return self.filePath ? [root stringByAppendingPathComponent:self.filePath] : root;
}

- (NSString *)fullFilePath
{
    if (!self.name) return nil;

    NSString *folder = [self installFolder];

    return [[folder stringByAppendingPathComponent:self.name] stringByAppendingPathExtension:@"framework"];
}

- (NSDictionary *)keyInformation
{
    return @{
             kBIdentifier : self.identifier,
             kBResources  : self.resources,
             kBFilePath   : self.filePath,
             kBVersion    : self.version,
             kBName       : self.name
             };
}

- (NSString *)description
{
    return self.identifier;
}

@end

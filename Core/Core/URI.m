//
//  URI.m
//  
//
//  Created by Thomson on 16/1/27.
//
//

#import "URI.h"

@interface URI ()
{
    NSString *_uriString;
}

@end

@implementation URI

- (void)setParameters:(NSDictionary *)parameter
{
    if (!parameter) return;

    NSMutableDictionary *parameters_temp = [NSMutableDictionary dictionaryWithDictionary:parameter];

    for (id key in [_parameters allKeys])
    {
        [parameters_temp setObject:[_parameters objectForKey:key] forKey:key];
    }

    _parameters = [NSDictionary dictionaryWithDictionary:parameters_temp];
}

+ (instancetype)URIWithString:(NSString *)uriString
{
    if (!uriString) return nil;

    return [[URI alloc] initWithURIString:uriString];
}

- (id)initWithURIString:(NSString *)uriString
{
    self = [self init];

    if (self)
    {
        _uriString = [uriString copy];

        NSURL *url = [NSURL URLWithString:_uriString];

        if (!url || !url.scheme) return nil;

        _scheme = url.scheme;

        NSRange pathRange = NSMakeRange(_scheme.length + 3, _uriString.length - _scheme.length - 3);

        if (url.query)
        {
            NSArray *components = [url.query componentsSeparatedByString:@"&"];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:0];

            for (NSString * item in components)
            {
                NSArray *subItems = [item componentsSeparatedByString:@"="];
                if ([subItems count] >= 2)
                {
                    parameters[subItems[0]] = subItems[1];
                }
            }

            _parameters = parameters;

            pathRange.length -= (url.query.length + 1);
        }

        if (pathRange.length > 0 && pathRange.location < uriString.length)
        {
            _resourcePath = [_uriString substringWithRange:pathRange];
        }
    }

    return self;
}

- (NSString *)description
{
    return _uriString;
}

@end

//
//  URI.h
//  
//
//  Created by Thomson on 16/1/27.
//
//

#import <Foundation/Foundation.h>

@interface URI : NSObject

+ (instancetype) URIWithString:(NSString *)uriString;

@property (nonatomic, retain) NSString *scheme;
@property (nonatomic, retain) NSString *resourcePath;

@property (nonatomic, retain) NSDictionary *parameters;

@end

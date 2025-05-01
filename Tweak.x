#import <Foundation/Foundation.h>

@interface MIBundle : NSObject
- (NSDictionary *)infoPlistSubset;
@end

@interface MIExecutableBundle : MIBundle
@end

%hook MIExecutableBundle

- (BOOL)isExtensionlessWatchKitApp {
    return [[self infoPlistSubset][@"WKApplication"] boolValue];
}

%end

# WatchInstallFix

In some iOS versions (presumably iOS < 15.4), `-[MIExecutableBundle isExtensionlessWatchKitApp]` is implemented like this:

```objc
@implementation MIExecutableBundle
- (BOOL)isExtensionlessWatchKitApp {
    BOOL isExtensionlessWatchKitAppFeatureEnabled = _os_feature_enabled_impl("watchkit", "extensionless_watchkit_apps");
    if (isExtensionlessWatchKitAppFeatureEnabled) {
        return [[self infoPlistSubset][@"WKApplication"] boolValue];
    }
    return isExtensionlessWatchKitAppFeatureEnabled;
}

@end
```

Based on my testing, this method returns `NO` on iPads. This means that if a developer has a watchOS app that is extensionless, it will not be able to be installed on iPads. Google Maps is one such example, according to my testing, not installable anymore on iPadOS 15.1. This should also be the case for iPod touch.

This tweak fixes this by directly returning `[[self infoPlistSubset][@"WKApplication"] boolValue]`, entirely bypassing the OS feature check.
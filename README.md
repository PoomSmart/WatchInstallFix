# WatchInstallFix

In some iOS versions (iOS 14 - 15?), `-[MIExecutableBundle isExtensionlessWatchKitApp]` is implemented like this:

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

Based on my testing, this method returns `NO` on iPads. This means that if a developer has a watchOS app that is extensionless, it will not be able to be installed on iPads. Google Maps is one such example, installing it is not possible on iPadOS 15.1. This is probably also the case on iPod touches.

This tweak fixes this by making `-isExtensionlessWatchKitApp` directly returning `[[self infoPlistSubset][@"WKApplication"] boolValue]`. This entirely bypasses the OS feature check and allows the installation of extensionless watchOS apps anywhere.

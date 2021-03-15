#import "FlutterEngaged2021Plugin.h"
#if __has_include(<flutter_engaged_2021/flutter_engaged_2021-Swift.h>)
#import <flutter_engaged_2021/flutter_engaged_2021-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_engaged_2021-Swift.h"
#endif

@implementation FlutterEngaged2021Plugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterEngaged2021Plugin registerWithRegistrar:registrar];
}
@end

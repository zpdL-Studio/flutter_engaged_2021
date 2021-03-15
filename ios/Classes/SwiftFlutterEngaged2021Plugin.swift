import Flutter
import UIKit

public class SwiftFlutterEngaged2021Plugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_engaged_2021", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterEngaged2021Plugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}

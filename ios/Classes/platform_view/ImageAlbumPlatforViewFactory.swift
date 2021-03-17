//
//  ImageAlbumPlatforViewFactory.swift
//  flutter_engaged_2021
//
//  Created by Flutter Web on 2021/03/17.
//

import Foundation

public class StoreCameraPluginCameraPlatformViewFactory: NSObject, FlutterPlatformViewFactory {
    
    static let CHANNEL = "\(SwiftFlutterEngaged2021Plugin.CHANNEL)_platform_view"

//    class func methodToIOS(method: String) -> PlatformMethod? {
//        let split = method.split(separator: "/")
//        if split.count >= 2 {
//            return PlatformMethod(rawValue: String(split[1]))
//        }
//        return nil
//    }
    
    class func methodToFlutter(method: FlutterMethod) -> String {
        return "\(StoreCameraPluginCameraPlatformViewFactory.CHANNEL)/\(method.rawValue)"
    }

    private let binaryMessenger: FlutterBinaryMessenger
    
    init(_ binaryMessenger: FlutterBinaryMessenger) {
        self.binaryMessenger = binaryMessenger
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }

    public func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return ImageAlbumPlatformView(binaryMessenger: binaryMessenger, frame: frame, viewId: viewId, args: args)
    }
}

enum FlutterMethod: String {
    case ON_PLUGIN_IMAGE = "ON_PLUGIN_IMAGE"
}

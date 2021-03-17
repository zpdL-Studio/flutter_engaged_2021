//
//  ImageAlbumPlatformView.swift
//  flutter_engaged_2021
//
//  Created by Flutter Web on 2021/03/17.
//

import MobileCoreServices
import UIKit

public class ImageAlbumPlatformView: NSObject, FlutterPlatformView {

    private let frame: CGRect
    private let viewId: Int64
    private let imageAlbumView: ImageAlbumView
    private let methodChannel: FlutterMethodChannel

    init(binaryMessenger: FlutterBinaryMessenger, frame: CGRect, viewId: Int64, args: Any?) {
        self.frame = frame
        self.viewId = viewId
        self.imageAlbumView = UINib(nibName: "ImageAlbumView", bundle: Bundle(for: ImageAlbumPlatformView.self)).instantiate(withOwner: nil, options: nil).first as! ImageAlbumView
        self.imageAlbumView.frame = frame
        self.methodChannel = FlutterMethodChannel(name: "\(StoreCameraPluginCameraPlatformViewFactory.CHANNEL)_\(viewId)", binaryMessenger: binaryMessenger)
        super.init()

        methodChannel.setMethodCallHandler({ [unowned self] in
            self.onMethodCall($0, $1) })
        
        self.imageAlbumView.onPluginImage = ({ [unowned self] in
            self.methodChannel.invokeMethod(StoreCameraPluginCameraPlatformViewFactory.methodToFlutter(method: FlutterMethod.ON_PLUGIN_IMAGE), arguments: $0.pluginToMap())
        })
    }
    
    deinit {
        self.methodChannel.setMethodCallHandler(nil)
        self.imageAlbumView.onPluginImage = nil
    }
    public func view() -> UIView {
        return imageAlbumView
    }
    
    private func onMethodCall(_ call: FlutterMethodCall ,_ result: @escaping FlutterResult) {
        result(FlutterMethodNotImplemented)
    }
}

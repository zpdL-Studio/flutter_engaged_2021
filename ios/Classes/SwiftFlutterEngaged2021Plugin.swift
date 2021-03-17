import Flutter
import UIKit

public class SwiftFlutterEngaged2021Plugin: NSObject, FlutterPlugin {
    
    static let CHANNEL = "flutter_engaged_2021"

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterEngaged2021Plugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        registrar.register(StoreCameraPluginCameraPlatformViewFactory(registrar.messenger()), withId: StoreCameraPluginCameraPlatformViewFactory.CHANNEL)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let method = methodToIOS(method: call.method) else {
            result(FlutterMethodNotImplemented)
            return
        }
        
        switch method {
        case .SHOW_IMAGE_ALBUM:
            result(nil)

            guard let window = UIApplication.shared.delegate?.window, let rootViewController = window?.rootViewController else {
                return
            }
            let bundle = Bundle(for: SwiftFlutterEngaged2021Plugin.self)
            let storyboard = UIStoryboard(name: "ImageAlbum", bundle: bundle)
            let viewController = storyboard.instantiateViewController(withIdentifier: "image_album_init_view_controller")
            viewController.modalPresentationStyle = UIModalPresentationStyle.currentContext
            
            DispatchQueue.main.async {
                Thread.sleep(forTimeInterval: 1)
                rootViewController.present(viewController, animated: true, completion: {
                    
                })
            }
            
        case .GET_IMAGES:
            FlutterEngagedImageQuery.shared.getImages { (images, _) in
                var list = [[String:Any]]()
                for image in images {
                    list.append(image.pluginToMap())
                }
                
                result(list)
            }
        case .READ_IMAGE_BYTES:
            if let id = call.arguments as? String {
                FlutterEngagedImageQuery.shared.readBytes(id, { (data) in
                    result(data)
                })
            } else {
                result(nil)
            }
        case .GET_THUMBNAIL_BITMAP:
            if let id = call.arguments as? String {
                FlutterEngagedImageQuery.shared.getThumbnail(id, 256, 256, { (pluginBitmap) in
                    result(pluginBitmap?.pluginToMap())
                })
            } else {
                result(nil)
            }
        }
    }
    
    func methodToIOS(method: String) -> Method? {
        let split = method.split(separator: "/")
        if split.count >= 2 {
            return Method(rawValue: String(split[1]))
        }
        return nil
    }
}

enum Method: String {
    case SHOW_IMAGE_ALBUM = "SHOW_IMAGE_ALBUM"
    case GET_IMAGES = "GET_IMAGES"
    case READ_IMAGE_BYTES = "READ_IMAGE_BYTES"
    case GET_THUMBNAIL_BITMAP = "GET_THUMBNAIL_BITMAP"
}

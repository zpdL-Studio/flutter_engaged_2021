//
//  FlutterEngagedImageQuery.swift
//  flutter_engaged_2021
//
//  Created by Flutter Web on 2021/03/16.
//

import MobileCoreServices
import Photos

class FlutterEngagedImageQuery {
    
    static let shared = FlutterEngagedImageQuery()
    
    private let imageManager = PHCachingImageManager()
    
    func getImages(_ completion: @escaping ([PluginImage], Bool) -> Void) {
        photoLibraryAuthorizationStatus(true) { authorization in
            if(authorization) {
                DispatchQueue.global(qos: .userInitiated).async {
                    var results = [PluginImage]()
                    
                    let fetchOPtions = PHFetchOptions()
                    fetchOPtions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                    PHAsset.fetchAssets(with: fetchOPtions).enumerateObjects { (phAsset, _, _) in
                        results.append(PluginImage(
                            id: phAsset.localIdentifier
                            ))
                    }
                    
                    DispatchQueue.main.async {
                        completion(results, true)
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion([], false)
                }
            }
        }
    }
    
    func getThumbnail(_ id: String, _ width: Int, _ height: Int, _ completion: @escaping (PluginBitmap?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let phAsset = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil).firstObject {
                let option = PHImageRequestOptions()
                option.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
                self.imageManager.requestImage(
                    for: phAsset,
                    targetSize: CGSize(width: width, height: height),
                    contentMode: .aspectFit,
                    options: option,
                    resultHandler: { (image: UIImage?, info) in
                        let pluginBitmap = PluginBitmap.init(image)
                        DispatchQueue.main.async {
                            completion(pluginBitmap)
                        }
                    })
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func getThumbnailUIImage(_ id: String, _ completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let phAsset = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil).firstObject {
                let option = PHImageRequestOptions()
                option.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
                self.imageManager.requestImage(
                    for: phAsset,
                    targetSize: CGSize(width: 256, height: 256),
                    contentMode: .aspectFit,
                    options: option,
                    resultHandler: { (image: UIImage?, info) in
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    })
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func readBytes(_ id: String, _ completion: @escaping (Data?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let phAsset = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil).firstObject {
                phAsset.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, dictInfo) in
                    PHImageManager.default().requestImageData(for: phAsset, options: nil) { (data: Data?, _, _, _) in
                        if let uniformTypeIdentifier = contentEditingInput?.uniformTypeIdentifier, uniformTypeIdentifier == kUTTypeJPEG as String || uniformTypeIdentifier == kUTTypePNG as String {
                            DispatchQueue.main.async {
                                completion(data)
                            }
                        } else if let imageData = data {
                            let uiImage = UIImage(data: imageData)
                            let jpgData = uiImage?.jpegData(compressionQuality: 1.0)
                            DispatchQueue.main.async {
                                completion(jpgData)
                            }
                        } else {
                            DispatchQueue.main.async {
                                completion(data)
                            }
                        }
                    }
                })
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    func photoLibraryAuthorizationStatus(_ request: Bool, _ completion: @escaping (Bool) -> Void) {
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined, .denied:
            if request {
                PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) in
                    if status == PHAuthorizationStatus.authorized {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            } else {
                completion(false)
            }
        case .authorized:
            completion(true)
        default:
            completion(false)
        }
    }
}

struct PluginImage {
    let id: String

    func pluginToMap() -> [String : Any] {
        return [
            "id": id,
        ]
    }
}

class PluginBitmap {
    let width: Int
    let height: Int
    let buffer: CFData
    
    init(_ width: Int, _ height: Int, _ buffer: CFData) {
        self.width = width
        self.height = height
        self.buffer = buffer
    }
    
    convenience init?(_ image: UIImage?) {
        if let cgImage = PluginBitmap.cgImageWithRGBA(image?.cgImage), let data = cgImage.dataProvider?.data {
            self.init(cgImage.width, cgImage.height, data)
        } else {
            return nil
        }
    }
    
    func pluginToMap() -> [String : Any] {
        return [
            "width": width,
            "height": height,
            "buffer": buffer
        ]
    }
    
    class func getPixelFormat(_ bitmapInfo: CGBitmapInfo) -> PixelFormat? {
        let alphaInfo: CGImageAlphaInfo? = CGImageAlphaInfo(rawValue: bitmapInfo.rawValue & type(of: bitmapInfo).alphaInfoMask.rawValue)
        let alphaFirst: Bool = alphaInfo == .premultipliedFirst || alphaInfo == .first || alphaInfo == .noneSkipFirst
        let alphaLast: Bool = alphaInfo == .premultipliedLast || alphaInfo == .last || alphaInfo == .noneSkipLast
        let endianLittle: Bool = bitmapInfo.contains(.byteOrder32Little)

        // This is slippery… while byte order host returns little endian, default bytes are stored in big endian
        // format. Here we just assume if no byte order is given, then simple RGB is used, aka big endian, though…

        if alphaFirst && endianLittle {
            return .BGRA
        } else if alphaFirst {
            return .ARGB
        } else if alphaLast && endianLittle {
            return .ABGR
        } else if alphaLast {
            return .RGBA
        } else {
            return nil
        }
    }
    
    class func cgImageWithRGBA(_ image: CGImage?) -> CGImage? {
        guard let cgImage = image else {
            return image
        }
        
        if let pixelFormat = getPixelFormat(cgImage.bitmapInfo) {
            if(pixelFormat == PixelFormat.RGBA) {
                return cgImage
            }
        }
        
        guard let context = cgContext(cgImage.width, cgImage.height) else {
            return cgImage
        }
        
        context.draw(cgImage, in: CGRect.init(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        if let makeImage = context.makeImage() {
            return makeImage
        }
        return image
    }
}

enum PixelFormat {
    case ABGR
    case ARGB
    case BGRA
    case RGBA
}

func getPixelFormat(_ bitmapInfo: CGBitmapInfo) -> PixelFormat? {
    let alphaInfo: CGImageAlphaInfo? = CGImageAlphaInfo(rawValue: bitmapInfo.rawValue & type(of: bitmapInfo).alphaInfoMask.rawValue)
    let alphaFirst: Bool = alphaInfo == .premultipliedFirst || alphaInfo == .first || alphaInfo == .noneSkipFirst
    let alphaLast: Bool = alphaInfo == .premultipliedLast || alphaInfo == .last || alphaInfo == .noneSkipLast
    let endianLittle: Bool = bitmapInfo.contains(.byteOrder32Little)

    // This is slippery… while byte order host returns little endian, default bytes are stored in big endian
    // format. Here we just assume if no byte order is given, then simple RGB is used, aka big endian, though…

    if alphaFirst && endianLittle {
        return .BGRA
    } else if alphaFirst {
        return .ARGB
    } else if alphaLast && endianLittle {
        return .ABGR
    } else if alphaLast {
        return .RGBA
    } else {
        return nil
    }
}

func cgContext(_ width: Int, _ height: Int) -> CGContext? {
    return CGContext.init(
        data: nil,
        width: width,
        height: height,
        bitsPerComponent: 8,
        bytesPerRow: (8 * 4 * width + 7)/8,
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
}

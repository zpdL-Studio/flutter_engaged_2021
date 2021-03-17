//
//  ImageAlbumItemCollectionViewCell.swift
//  flutter_engaged_2021
//
//  Created by Flutter Web on 2021/03/17.
//

import UIKit

class ImageAlbumItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    var tapDelegate: ((ImageAlbumItemCollectionViewCell) -> Void)?
    var image: PluginImage? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        tapDelegate = nil
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        tapDelegate?(self)
    }
    
    func setPluginImage(image: PluginImage) {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))

        imageView.image = nil
        self.image = image
        FlutterEngagedImageQuery.shared.getThumbnailUIImage(image.id) { (uiImage) in
            self.imageView.image = uiImage
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "ImageAlbumItemCollectionViewCell", bundle: Bundle(for: ImageAlbumItemCollectionViewCell.self))
    }
}

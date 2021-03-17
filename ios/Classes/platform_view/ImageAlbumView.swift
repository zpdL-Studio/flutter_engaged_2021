//
//  ImageAlbumView.swift
//  flutter_engaged_2021
//
//  Created by Flutter Web on 2021/03/17.
//

import UIKit

class ImageAlbumView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var uiCollectionView: UICollectionView!
    var collectionItems = [PluginImage]()
    var onPluginImage: ((PluginImage) -> Void)? = nil
    
    override func awakeFromNib() {
        uiCollectionView.delegate = self
        uiCollectionView.dataSource = self
        uiCollectionView.register(ImageAlbumItemCollectionViewCell.nib(), forCellWithReuseIdentifier: "ImageAlbumItemCollectionViewCell")

        FlutterEngagedImageQuery.shared.getImages { (images, _) in
            self.collectionItems = images
            self.uiCollectionView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageAlbumItemCollectionViewCell", for: indexPath) as! ImageAlbumItemCollectionViewCell
        cell.tapDelegate = { _ in
            self.onPluginImage?(self.collectionItems[indexPath.row])
        }
        cell.setPluginImage(image: collectionItems[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 72, height: 72)
    }
}

//
//  ImageAlbumViewController.swift
//  flutter_engaged_2021
//
//  Created by Flutter Web on 2021/03/16.
//

import Foundation

class ImageAlbumViewController: UICollectionViewController {
    
    @IBOutlet var uiCollectionView: UICollectionView!
    @IBOutlet weak var nevigationItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(onBack))

        uiCollectionView.register(ImageAlbumItemCollectionViewCell.nib(), forCellWithReuseIdentifier: "ImageAlbumItemCollectionViewCell")

        FlutterEngagedImageQuery.shared.getImages { (images, _) in
            self.collectionItems = images
            self.uiCollectionView.reloadData()
        }
    }
    
    @objc func onBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    var collectionItems = [PluginImage]()
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageAlbumItemCollectionViewCell", for: indexPath) as! ImageAlbumItemCollectionViewCell
        cell.tapDelegate = { _ in
            print("cell.tapDelegate")
        }
        cell.setPluginImage(image: collectionItems[indexPath.row])
        return cell
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 400)
    }
    
    func collectionView(_collectionView:UICollectionView,layoutcollectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 400)
    }
}

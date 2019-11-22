//
//  MainCollectionViewCell.swift
//  PhotoManager
//
//  Created by Andrii Pyvovarov on 11/21/19.
//  Copyright © 2019 Andrii Pyvovarov. All rights reserved.
//

import UIKit

class MainCollectionViewCell : UICollectionViewCell {
    
    var imagesArr : Picture?{
        didSet {
            DispatchQueue.main.async {
                self.photoCollectionView.reloadData()
            }
        }
    }
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "photoCellId")
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - setup collectionView
    
    private func setupViews(){
         addSubview(photoCollectionView)

         photoCollectionView.delegate = self
         photoCollectionView.dataSource = self

         photoCollectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
         photoCollectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
         photoCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
         photoCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
     }
    
    let photoCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
  
    override func prepareForReuse() {
        imagesArr = nil
    }
    func topMostController() -> UIViewController {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        var rootViewController: UIViewController = keyWindow!.rootViewController!
      while (rootViewController.presentedViewController != nil) {
        rootViewController = rootViewController.presentedViewController!
      }
      return rootViewController
    }
}
//MARK: - UICollectionViewDataSource

extension MainCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArr?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCellId", for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        
        if let image = imagesArr?[indexPath.row],
            let ulr = image.urls?.small {
            Downloader.image(link: ulr) { (image) in
                guard let image = image else { return }
                cell.imageView.image = image
            }
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let image = imagesArr?[indexPath.row],
            let ulr = image.urls?.full {
            Downloader.image(link: ulr) { (image) in
                guard let image = image else{return}
                let imageInfo = GSImageInfo(image: image, imageMode: .aspectFit)
                let transitionInfo = GSTransitionInfo(fromView: self.photoCollectionView)
                let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
                imageViewer.dismissCompletion = {
                    print("dismiss")
                }
                let rooViewController = self.topMostController()
                rooViewController.present(imageViewer, animated: true, completion: nil)
            }
        }
    }
}
//MARK: - UICollectionViewDelegateFlowLayout

extension MainCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let size = collectionView.frame.size
             return CGSize(width: size.width/2, height: (size.height-55)/3)
         }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
             return 0.0
         }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
             return 0.0
         }
}

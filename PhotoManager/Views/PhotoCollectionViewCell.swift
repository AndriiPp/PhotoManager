//
//  PhotoCollectionViewCell.swift
//  PhotoManager
//
//  Created by Andrii Pyvovarov on 11/21/19.
//  Copyright © 2019 Andrii Pyvovarov. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
            let imageV = UIImageView()
            imageV.translatesAutoresizingMaskIntoConstraints = false
            imageV.contentMode = .scaleToFill
            return imageV
        }()
    //MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - setup image view
    
    func setupViews(){
        addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}

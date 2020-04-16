//
//  SlideFotoCell.swift
//  tinderClone
//
//  Created by Cleber Reis on 16/04/20.
//  Copyright © 2020 Cleber Reis. All rights reserved.
//

import UIKit

class SlideFotoCell: UICollectionViewCell {
    
    var photoImageView: UIImageView = .photoImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 8
        clipsToBounds = true
        
        addSubview(photoImageView)
        photoImageView.preencherSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

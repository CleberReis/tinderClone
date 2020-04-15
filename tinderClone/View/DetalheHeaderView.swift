//
//  DetalheHeaderView.swift
//  tinderClone
//
//  Created by Cleber Reis on 14/04/20.
//  Copyright © 2020 Cleber Reis. All rights reserved.
//

import UIKit

class DetalheHeaderView: UICollectionReusableView {
    
    var user: User? {
        didSet{
            if let user = user {
                photoImageView.image = UIImage(named: user.image)
            }
        }
    }
    
    var photoImageView: UIImageView = .photoImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(photoImageView)
        photoImageView.preencherSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

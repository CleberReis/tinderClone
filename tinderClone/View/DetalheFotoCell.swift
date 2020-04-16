//
//  DetalheFotoCell.swift
//  tinderClone
//
//  Created by Cleber Reis on 16/04/20.
//  Copyright © 2020 Cleber Reis. All rights reserved.
//

import UIKit

class DetalheFotoCell: UICollectionViewCell {
    
    let descriptionLabel: UILabel = .textBoldLabel(16)
    let slideFotosVC = SlideFotosVC()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        descriptionLabel.text = "Fotos recentes Instagram"
        
        addSubview(descriptionLabel)
        descriptionLabel.preencher(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: nil,
            padding: .init(
                top: 0,
                left: 20,
                bottom: 0,
                right: 20
            ))
        
        addSubview(slideFotosVC.view)
        slideFotosVC.view.preencher(
            top: descriptionLabel.bottomAnchor,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  CombineCardView.swift
//  tinderClone
//
//  Created by Cleber Reis on 26/03/20.
//  Copyright © 2020 Cleber Reis. All rights reserved.
//

import UIKit

class CombineCardView: UIView {
    
    var users: User? {
        didSet{
            if let user = users{
                photoImageView.image = UIImage(named: user.image)
                nameLabel.text = user.name
                ageLabel.text = String(describing: user.age)
                phraseLabel.text = user.phrase
            }
        }
    }
    
    let photoImageView: UIImageView = .photoImageView()
    
    let nameLabel: UILabel = .textBoldLabel(32, textColor: .white)
    let ageLabel: UILabel = .textLabel(28, textColor: .white)
    let phraseLabel: UILabel = .textLabel(18, textColor: .white, numberOfLines: 2)
    
    let deslikeImageView: UIImageView = .iconCard(named: "card-deslike")
    let likeImageView: UIImageView = .iconCard(named: "card-like")
    
    var callback: ((User) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 0.3
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 8
        clipsToBounds = true

        addSubview(photoImageView)
        photoImageView.preencherSuperview()
        
        addSubview(deslikeImageView)
        deslikeImageView.preencher(
            top: topAnchor,
            leading: nil,
            trailing: trailingAnchor,
            bottom: nil,
            padding: .init(top: 20, left: 0, bottom: 0, right: 20)
        )
        
        addSubview(likeImageView)
        likeImageView.preencher(
            top: topAnchor,
            leading: leadingAnchor,
            trailing: nil,
            bottom: nil,
            padding: .init(top: 20, left: 20, bottom: 0, right: 0)
        )
        
        let nameAgeStackView = UIStackView(arrangedSubviews: [nameLabel, ageLabel, UIView()])
        nameAgeStackView.spacing = 12
        
        let stackView = UIStackView(arrangedSubviews: [nameAgeStackView, phraseLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        addSubview(stackView)
        stackView.preencher(
            top: nil,
            leading: leadingAnchor,
            trailing: trailingAnchor,
            bottom: bottomAnchor,
            padding: .init(top: 16, left: 16, bottom: 16, right: 16)
        )
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClick))
        stackView.isUserInteractionEnabled = true
        stackView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func viewClick(){
        if let user = self.users{
            self.callback?(user)
        }
    }
    
}

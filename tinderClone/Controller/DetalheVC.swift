//
//  DetalheVC.swift
//  tinderClone
//
//  Created by Cleber Reis on 12/04/20.
//  Copyright © 2020 Cleber Reis. All rights reserved.
//

import UIKit

class HeaderLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        layoutAttributes?.forEach({ (attribute) in
            if attribute.representedElementKind == UICollectionView.elementKindSectionHeader{
                guard let collectionView = collectionView else {return}
                
                let contentOffSetY = collectionView.contentOffset.y
                attribute.frame = CGRect(
                    x: 0,
                    y: contentOffSetY,
                    width: collectionView.bounds.width,
                    height: attribute.bounds.height - contentOffSetY)
            }
        })
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}

class DetalheVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var user: User? {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    let cellID = "cellID"
    let headerID = "headerID"
    let perfilID = "perfilID"
    let fotosID = "fotosID"
    
    var deslikeButton: UIButton = .iconFooter(named: "icone-deslike")
    var likeButton: UIButton = .iconFooter(named: "icone-like")
    var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icone-down"), for: .normal)
        button.backgroundColor = UIColor(red: 232/255, green: 88/255, blue: 54/255, alpha: 1)
        button.clipsToBounds = true
        
        return button
    }()
    
    var callback:((User?, Action) -> Void)?
    
    init(){
        super.init(collectionViewLayout: HeaderLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 134, right: 0)
        
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        collectionView.register(DetalheHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        collectionView.register(DetalhePerfilCell.self, forCellWithReuseIdentifier: perfilID)
        collectionView.register(DetalheFotoCell.self, forCellWithReuseIdentifier: fotosID)
        
        self.addBack()
        self.addFooter()
    }
    
    func addBack(){
        view.addSubview(backButton)
        backButton.frame = CGRect(
            x: view.bounds.width - 69,
            y: view.bounds.height * 0.7 - 24,
            width: 48,
            height: 48)
        backButton.layer.cornerRadius = 24
        backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)
    }
    
    func addFooter(){
        let stackView = UIStackView(arrangedSubviews: [UIView(), deslikeButton, likeButton, UIView()])
        stackView.distribution = .equalCentering
        
        view.addSubview(stackView)
        stackView.preencher(
            top: nil,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: view.bottomAnchor,
            padding: .init(top: 0, left: 16, bottom: 34, right: 16)
        )
        
        deslikeButton.addTarget(self, action: #selector(deslikeClick), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeClick), for: .touchUpInside)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! DetalheHeaderView
        header.user = self.user
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.bounds.width, height: view.bounds.height * 0.7)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: perfilID, for: indexPath) as! DetalhePerfilCell
            cell.user = self.user
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: fotosID, for: indexPath) as! DetalheFotoCell
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = UIScreen.main.bounds.width
        var height: CGFloat = UIScreen.main.bounds.width * 0.66
        
        if indexPath.item == 0{
            let cell = DetalhePerfilCell(frame: CGRect(x: 0, y: 0, width: width, height: height))
            cell.user = self.user
            cell.layoutIfNeeded()
            
            let estimateHeight = cell.systemLayoutSizeFitting(CGSize(width: width, height: 1000))
            height = estimateHeight.height
        }
        
        return .init(width: width, height: height)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let originY = view.bounds.height * 0.7 - 24
        
        if scrollView.contentOffset.y > 0{
            self.backButton.frame.origin.y = originY - scrollView.contentOffset.y
        }else{
            self.backButton.frame.origin.y = originY + scrollView.contentOffset.y * -1
        }
    }
    
    @objc func backClick(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func deslikeClick(){
        self.callback?(self.user, Action.deslike)
        self.backClick()
    }
    
    @objc func likeClick(){
        self.callback?(self.user, Action.like)
        self.backClick()
    }
}

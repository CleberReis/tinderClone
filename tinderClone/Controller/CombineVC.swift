//
//  CombineVC.swift
//  tinderClone
//
//  Created by Cleber Reis on 26/03/20.
//  Copyright © 2020 Cleber Reis. All rights reserved.
//

import UIKit

enum Action{
    case deslike
    case like
}

class CombineVC: UIViewController {
    
    var perfilButton: UIButton = .iconMenu(named: "icone-perfil")
    var chatButton: UIButton = .iconMenu(named: "icone-chat")
    var logoButton: UIButton = .iconMenu(named: "icone-logo")
    
    var deslikeButton: UIButton = .iconFooter(named: "icone-deslike")
    var superlikeButton: UIButton = .iconFooter(named: "icone-superlike")
    var likeButton: UIButton = .iconFooter(named: "icone-like")
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.systemGroupedBackground
        addHeader()
        addFooter()
        searchUsers()
    }
    
    func searchUsers(){
        users = UserService.shared.searchUsers()
        addCard()
    }
    
}

extension CombineVC{
    
    func addHeader(){
        let window = UIApplication.shared.windows.first {$0.isKeyWindow}
        let top: CGFloat = window?.safeAreaInsets.top ?? 44
        
        let stackView = UIStackView(arrangedSubviews: [perfilButton, logoButton, chatButton])
        stackView.distribution = .equalCentering
        
        view.addSubview(stackView)
        stackView.preencher(
            top: view.topAnchor,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: nil,
            padding: .init(top: top, left: 16, bottom: 0, right: 16)
        )
    }
    
    func addFooter(){
        let stackView = UIStackView(arrangedSubviews: [UIView(), deslikeButton, superlikeButton, likeButton, UIView()])
        stackView.distribution = .equalCentering
        
        view.addSubview(stackView)
        stackView.preencher(
            top: nil,
            leading: view.leadingAnchor,
            trailing: view.trailingAnchor,
            bottom: view.bottomAnchor,
            padding: .init(top: 0, left: 16, bottom: 34, right: 16)
        )
    }
}

extension CombineVC{
    func addCard(){
        for user in users{
            let card = CombineCardView()
            card.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 32, height: self.view.bounds.height * 0.7)
            card.center = view.center

            card.users = user
            card.tag = user.id
            
            let gesture = UIPanGestureRecognizer()
            gesture.addTarget(self, action: #selector(handlerCard))
            card.addGestureRecognizer(gesture)
            
            view.insertSubview(card, at: 0)
        }
    }
    
    func removeCard(card: UIView){
        card.removeFromSuperview()
        
        self.users = self.users.filter({ (user) -> Bool in
            return user.id != card.tag
        })
    }
    
}

extension CombineVC{
    @objc func handlerCard(_ gesture: UIPanGestureRecognizer){
        if let card = gesture.view as? CombineCardView{
            let point = gesture.translation(in: view)
            card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
            
            let rotationangle = point.x / view.bounds.width * 0.4
            
            if point.x > 0{
                card.likeImageView.alpha = rotationangle * 5
                card.deslikeImageView.alpha = 0
            }else{
                card.likeImageView.alpha = 0
                card.deslikeImageView.alpha = rotationangle * 5 * -1
            }
            
            card.transform = CGAffineTransform(rotationAngle: rotationangle)
            
            if gesture.state == .ended{
                
                if card.center.x > self.view.bounds.width + 50{
                    self.animetionCard(rotationAngle: rotationangle, action: .like)
                    return
                }
                
                if card.center.x < -50{
                    self.animetionCard(rotationAngle: rotationangle, action: .deslike)
                    return
                }
                
                UIView.animate(withDuration: 0.2) {
                    card.center = self.view.center
                    card.transform = .identity
                    
                    card.likeImageView.alpha = 0
                    card.deslikeImageView.alpha = 0
                }
            }
        }
    }
    
    func animetionCard(rotationAngle: CGFloat, action: Action){
        if let user = self.users.first{
            for view in self.view.subviews{
                if view.tag == user.id{
                    if let card = view as? CombineCardView{
                        let center: CGPoint
                        
                        switch action {
                        case .deslike:
                            center = CGPoint(x: card.center.x - self.view.bounds.width, y: card.center.y + 50)
                        case .like:
                            center = CGPoint(x: card.center.x + self.view.bounds.width, y: card.center.y + 50)
                        }
                        
                        UIView.animate(withDuration: 0.2, animations: {
                            card.center = center
                            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
                        }) { (_) in
                            self.removeCard(card: card)
                        }
                        
                    }
                }
            }
        }
    }
    
}
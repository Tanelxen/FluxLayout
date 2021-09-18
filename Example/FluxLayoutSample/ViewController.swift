//
//  ViewController.swift
//  FluxLayoutSamples
//
//  Created by Fedor Artemenkov on 16.09.2021.
//

import UIKit
import FluxLayout

class ViewController: UIViewController
{
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let avatar = UIImageView()
        avatar.image = UIImage(named: "avatar")
        avatar.layer.cornerRadius = 50
        avatar.clipsToBounds = true
        
        let headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        headerLabel.numberOfLines = 0
        headerLabel.text = "FluxLayout Test"
        
        let titleLabel = UILabel()
        titleLabel.backgroundColor = .magenta
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        titleLabel.numberOfLines = 0
        titleLabel.text = "title"
        
        let subtitleLabel = UILabel()
        subtitleLabel.backgroundColor = .cyan
        subtitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = "subtitle"
        
        let footerLabel = UILabel()
        footerLabel.backgroundColor = .green
        footerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        footerLabel.numberOfLines = 0
        footerLabel.text = "footer"
        
        Flux(containerView).direction(.column).justifyContent(.start).alignItems(.stretch).define
        {
            $0.addItem(headerLabel).margin(top: 24, left: 16, bottom: 0, right: 16)
            
            $0.addItem().backgroundColor(.systemGray2).height(0.5).marginTop(24).marginHorizontal(16)
            
            $0.addItem().direction(.row).marginTop(16).marginHorizontal(16).define
            {
                $0.addItem(avatar).width(100).height(100)
                
                $0.addItem().marginTop(6).marginHorizontal(16).define
                {
                    let nameLabel = UILabel()
                    nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
                    nameLabel.numberOfLines = 0
                    nameLabel.text = "Theodor Artemenkov"
                    
                    $0.addItem(nameLabel)
                    
                    let positionLabel = UILabel()
                    positionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
                    positionLabel.textColor = .systemGray2
                    positionLabel.numberOfLines = 0
                    positionLabel.text = "iOS Developer"
                    
                    $0.addItem(positionLabel).marginTop(8)
                }
            }
            
            let messageLabel = UILabel()
            messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            messageLabel.numberOfLines = 0
            messageLabel.text = "Если бы мы знали, что это такое. Но мы не знаем, что это такое."
            
            $0.addItem(messageLabel).marginTop(16).marginHorizontal(16)
            
//            $0.addItem(titleLabel)
//            $0.addItem(subtitleLabel)
//            $0.addItem(footerLabel)
        }
    }
}


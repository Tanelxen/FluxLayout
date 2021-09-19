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
    
    let headerLabel = UILabel()
    let avatarImageView = UIImageView()
    let nameLabel = UILabel()
    let positionLabel = UILabel()
    let messageLabel = UILabel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupStyles()
        setupLayout()
        setupData()
    }
    
    private func setupLayout()
    {
        Flux(containerView).direction(.column).justifyContent(.start).alignItems(.stretch).define
        {
            $0.addItem(headerLabel).name("header").marginTop(24).alignSelf(.center)
            
            //Separator
            $0.addItem().name("separator").backgroundColor(.systemGray2).height(0.5).marginTop(24).marginHorizontal(16)
            
            //User
            $0.addItem().name("user").direction(.row).justifyContent(.fill).alignItems(.start).marginTop(16).marginHorizontal(16).define
            {
                $0.addItem(avatarImageView).name("avatar").width(100).height(100)
                
                //Dot
                $0.addItem().backgroundColor(.green).position(.absolute).top(9).left(9).width(10).height(10)
                
                $0.addItem().name("info").marginTop(6).marginLeft(16).define
                {
                    $0.addItem(nameLabel).name("name")
                    $0.addItem(positionLabel).name("position").marginTop(8)
                }
            }
            
            $0.addItem(messageLabel).name("message").marginTop(16).marginHorizontal(16)
        }
    }
    
    private func setupStyles()
    {
        containerView.backgroundColor = .white
        
        headerLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        headerLabel.numberOfLines = 0
        
        avatarImageView.image = UIImage(named: "avatar")
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.clipsToBounds = true
        
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        nameLabel.numberOfLines = 0
        
        positionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        positionLabel.textColor = .systemGray2
        positionLabel.numberOfLines = 0
        
        messageLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        messageLabel.numberOfLines = 0
    }
    
    private func setupData()
    {
        headerLabel.text = "FluxLayout"
        nameLabel.text = "Theodor Artemenkov"
        positionLabel.text = "iOS Developer"
        messageLabel.text = "Если бы мы знали, что это такое. Но мы не знаем, что это такое."
    }
}


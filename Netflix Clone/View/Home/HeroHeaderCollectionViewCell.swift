//
//  HeroHeaderCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Ahmed Yamany on 01/09/2022.
//

import UIKit


class HeroHeaderCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifer = "HeroHeaderCollectionViewCell"
    
    
    // MARK: - SubViews
    private let imageView: UIImageView = {
        let imageVeiw = UIImageView()
        imageVeiw.contentMode = .scaleAspectFill
        return imageVeiw
    }()
    
    private let staticView: UIStackView = {
        let staticView = UIStackView()
        staticView.axis = .horizontal
        staticView.alignment = .fill
        staticView.distribution = .fill
        staticView.spacing = 20
        staticView.translatesAutoresizingMaskIntoConstraints = false

        return staticView
    }()

    private let playButton: HomeButton = {
        let button = HomeButton()
        button.setTitle("Play", for: .normal)
        
        return button
    }()

    private let downloadButton: HomeButton = {
        let button = HomeButton()
        button.setTitle("Download", for: .normal)
        return button
    }()
    
    
    
    // MARK: - Views
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        createGradiantLayer()
        configureStackViewSubViews()
     
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.frame = bounds
        configureStackViewLayout()

    }
  
    
    // MARK: - Helper Functions
    private func createGradiantLayer(){
       let gradiantLayer = CAGradientLayer()
       gradiantLayer.colors = [
           UIColor.clear.cgColor,
           UIColor.systemBackground.cgColor
       ]
       gradiantLayer.frame = bounds
       layer.addSublayer(gradiantLayer)
   }
    
    private func configureStackViewSubViews(){
        addSubview(staticView)
        staticView.addArrangedSubview(playButton)
        staticView.addArrangedSubview(downloadButton)
        
    }
    private func configureStackViewLayout(){
        NSLayoutConstraint.activate([
            staticView.centerXAnchor.constraint(equalTo: centerXAnchor),
            staticView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        ])
    }
    
    
    // MARK: - Configure Cell
     func configureCell(heroHeader: HeroHeader){
        imageView.backgroundColor = heroHeader.color
    }
    
    
    
    
}

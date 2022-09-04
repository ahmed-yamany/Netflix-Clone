//
//  HomeButton.swift
//  Netflix Clone
//
//  Created by Ahmed Yamany on 02/09/2022.
//

import UIKit

class HomeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderColor = UIColor.label.cgColor
        layer.borderWidth = 1
        setTitleColor(UIColor.label, for: .normal)
        widthAnchor.constraint(equalToConstant: 120).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   
}

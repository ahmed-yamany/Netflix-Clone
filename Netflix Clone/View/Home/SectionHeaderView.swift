//
//  SectionHeaderView.swift
//  Netflix Clone
//
//  Created by Ahmed Yamany on 02/09/2022.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifer = "SectionHeaderView"
    static let supplementaryViewOfKind = "SectionHeaderView"
    
    private let headerTitle: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerTitle)
        
        NSLayoutConstraint.activate([
            headerTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
   
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeader(_ title: String){
        self.headerTitle.text = title.capitalized
    }
    
    
}

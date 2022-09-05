//
//  MoviesCollectionViewCell.swift
//  Netflix Clone
//
//  Created by Ahmed Yamany on 03/09/2022.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifer = "MoviesCollectionViewCell"
    
    var movie: Show?
    
    // MARK: - SubViews
    private let imageView: UIImageView = {
        let imageVeiw = UIImageView()
        imageVeiw.contentMode = .scaleAspectFill
        imageVeiw.clipsToBounds = true
        return imageVeiw
    }()
    
    // MARK: - Views
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.frame = bounds

    }
    
    func configureCell(movie:Show, image: UIImage){
       imageView.image = image
        self.movie = movie
   }
    
    

}

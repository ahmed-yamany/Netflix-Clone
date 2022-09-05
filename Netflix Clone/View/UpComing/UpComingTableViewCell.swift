//
//  UpComingTableViewCell.swift
//  Netflix Clone
//
//  Created by Ahmed Yamany on 04/09/2022.
//

import UIKit

class UpComingTableViewCell: UITableViewCell {
    static let reuseIdentifer = "UpComingTableViewCell"
    var movie: Show?
    
    let PosterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .green
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    let nameLabel: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }()
    
    let playButton: UIButton = {
       let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(PosterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(playButton)
        
        createContraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createContraints(){
        
        let posterImageViewConstraints = [
            PosterImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            PosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            PosterImageView.widthAnchor.constraint(equalToConstant: 100),
            PosterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            PosterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ]
        
        let playButtonConstraints = [
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
        ]
        
        let nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: PosterImageView.trailingAnchor, constant: 10),
//            nameLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        
        NSLayoutConstraint.activate(posterImageViewConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)


    }
    
    func configureCell(with model: Show){
        self.movie = model
        self.nameLabel.text = model.title ?? model.originalTitle ?? "UnKnown"
        if let posterPath = model.posterPath{
            Task{
                let image = try await NetworkLayer.ImageRequest(imagePath: posterPath).send()
                PosterImageView.image = image
            }
        }
        
        
        
    }
    
}

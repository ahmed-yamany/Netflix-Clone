//
//  SearchResultViewController.swift
//  Netflix Clone
//
//  Created by Ahmed Yamany on 04/09/2022.
//

import UIKit

class SearchResultViewController: UIViewController {
    // MARK: - SubViews
    let collectionView: UICollectionView = {
       let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.reuseIdentifer)
        
        return collectionView
    }()

    
    // MARK: - Properties
    var searchMovies: [Show] = []
    var searchMoviesRequestTask: Task<Void, Never>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.collectionViewLayout = collectionViewLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}


extension SearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchMovies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.reuseIdentifer, for: indexPath) as? MoviesCollectionViewCell else{
            return UICollectionViewCell()
        }
        let movie = searchMovies[indexPath.row]
//        cell.movie = movie
        if let posterPath = movie.posterPath{
            Task{
                let image = try await NetworkLayer.ImageRequest(imagePath: posterPath).send()
                cell.configureCell(movie: movie, image: image)
            }
        }
              
        return cell
        
    }
    
    
    func collectionViewLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(0.333), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .fractionalWidth(0.5))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            group.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 10, trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
        guard let cell = collectionView.cellForItem(at: indexPath) as? MoviesCollectionViewCell else{return}
        let movie = cell.movie
        
        let VC = MovieDetailsViewController(movie: movie)
        present(VC, animated: true)
//        navigationController?.pushViewController(VC, animated: true)
    }
    
}

// MARK: - Network Request
extension SearchResultViewController{
    func searchMoviesNetworkRequest(query: String){
        searchMoviesRequestTask?.cancel()
        searchMoviesRequestTask = Task{
            guard let movies = try? await NetworkLayer.SearchRequest(query: query).send() else{return}
            if let results = movies.results{
                searchMovies = results
            }
            searchMoviesRequestTask = nil
            collectionView.reloadData()
        }
    }
}


//
//  HomeViewController.swift
//  Netflix Clone
//
//  Created by Ahmed Yamany on 31/08/2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - SubViews
    let collectionView: UICollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewLayout())
    
    
    // MARK: - ViewModel
        enum Section: Hashable {
           case header
           case movies(String)
       }
        enum Item: Hashable{
            case heroHeader(HeroHeader)
            case show(Show)
            
            var heroHeader: HeroHeader? {
                if case .heroHeader(let header) = self {
                    return header
                } else {
                    return nil
                }
            }
            var show: Show?{
                if case .show(let show) = self {
                    return show
                } else {
                    return nil
                }
            }

        }
    
    // MARK: - Properties
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, Item>!
    var sections = [Section]()
    
     var heroHeader: Item? = nil
     var treandingMovies: [Item] = []
     var popularMovies: [Item] = []
     var upcomingMovies: [Item] = []
     var topRatedMovies: [Item] = []

    var moviesRequestTask: [IndexPath: Task<Void, Never>] = [:]
    var treandingMoviesRequestTask: Task<Void, Never>? = nil
    var popularMoviesRequestTask: Task<Void, Never>? = nil
    var upcomingMoviesRequestTask: Task<Void, Never>? = nil
    var topRatedMoviesRequestTask: Task<Void, Never>? = nil

    // MARK: - Views
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        


    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.register(HeroHeaderCollectionViewCell.self, forCellWithReuseIdentifier: HeroHeaderCollectionViewCell.reuseIdentifer)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: SectionHeaderView.supplementaryViewOfKind, withReuseIdentifier: SectionHeaderView.reuseIdentifer)
        collectionView.register(MoviesCollectionViewCell.self, forCellWithReuseIdentifier: MoviesCollectionViewCell.reuseIdentifer)
        

        
        collectionView.collectionViewLayout = collectionViewLayout()
        endAllTasks()
        configureNavigationItem()
        
        networkRequest()
       
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds

    }
    
    
    // MARK: - Configure NavigationBar
    func configureNavigationItem(){
        let netflixLogo = UIImage(named: "netflix")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: netflixLogo, style: .done, target: nil, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: nil, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .label
    }
    
    func endAllTasks(){
//        treandingMoviesRequestTask = nil
//        popularMoviesRequestTask = nil
//        upcomingMoviesRequestTask = nil
//        topRatedMoviesRequestTask = nil
        self.moviesRequestTask.values.forEach({ $0.cancel()})
        self.moviesRequestTask = [:]

    }
}
// MARK: - Configure CollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate{
    // change navbar position based on scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let saveAreaOffset = view.safeAreaInsets.top
        let scrollViewOffset = scrollView.contentOffset.y + saveAreaOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: -scrollViewOffset)
    }
    
    // end task for not showing cell
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        moviesRequestTask[indexPath]?.cancel()
    }

}

// MARK: - Configure CollectinsViewDataSource
extension HomeViewController{
    // MARK: - CollectionViewLayout
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = self.sections[sectionIndex]
            
            switch section{
            case .header:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),heightDimension: .estimated(450))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                return section
                       
            case .movies:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(310),heightDimension: .absolute(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                
                let header = self.createSupplementaryItem(ofWidth: .fractionalWidth(1), ofHeight: .estimated(33), alignment: .top, for: SectionHeaderView.supplementaryViewOfKind)
                section.boundarySupplementaryItems = [header]
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 20, trailing: 0)
                
                return section
            }
        }
        return layout
    }
    
    // MARK: - Configure Data Source
    func configureDataSource() {
        
        dataSourceInitialization()
        supplementaryViewProfider()
        snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        if let heroHeader = heroHeader{
            snapshot.appendSections([.header])
            snapshot.appendItems([heroHeader], toSection: .header)
        }
        
        
    
    }

    
    // MARK: - cell for item at
    func dataSourceInitialization(){
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let section = self.sections[indexPath.section]
            switch section{
            case .header:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroHeaderCollectionViewCell.reuseIdentifer, for: indexPath) as! HeroHeaderCollectionViewCell
                if let item = itemIdentifier.heroHeader{
                    cell.configureCell(heroHeader: item)
                }
                return cell
            case .movies:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesCollectionViewCell.reuseIdentifer, for: indexPath) as! MoviesCollectionViewCell
                cell.backgroundColor = .gray
                if let movie = itemIdentifier.show, let imagePath = movie.posterPath{
                    self.moviesRequestTask[indexPath] = Task{
                        guard let image = try? await NetworkLayer.ImageRequest(imagePath: imagePath).send() else{return}
//
                        cell.configureCell(image: image)
                        self.moviesRequestTask[indexPath] = nil
                    }
//
                }
                return cell
            }
           
        })
        
    }
    
    
    // MARK: - configure Sections Header
    func createSupplementaryItem(ofWidth width: NSCollectionLayoutDimension,ofHeight height: NSCollectionLayoutDimension, alignment: NSRectAlignment, for supplenentaryKind: String) -> NSCollectionLayoutBoundarySupplementaryItem{
        
        let headerItemSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: supplenentaryKind, alignment: alignment)
//        headerItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        
        return headerItem
    }
    
    func supplementaryViewProfider(){
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            
            switch kind{
            case SectionHeaderView.supplementaryViewOfKind:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: SectionHeaderView.supplementaryViewOfKind, withReuseIdentifier: SectionHeaderView.reuseIdentifer, for: indexPath) as! SectionHeaderView
                switch self.sections[indexPath.section]{
                case .movies(let headerName):
                    header.configureHeader(headerName)
                default:
                    fatalError("")
                }
                
                return header
            default:
                fatalError("")
            }
            
        }
    }

}

// MARK: - Network Requests
extension HomeViewController{
    // MARK: - Network Request
    func networkRequest(){
        heroHeader = .heroHeader(HeroHeader())
        configureDataSource()

        TreandingMoviesnetworkRequest()
        popularMoviesNetworkRequest()
//        upcomingMoviesNetworkRequest()
        topRatedMoviesNetWorkRequest()

    }
    
    func TreandingMoviesnetworkRequest(){
        let treandingMoviesSection = Section.movies("Treanding Movies")
        snapshot.appendSections([treandingMoviesSection])
        treandingMoviesRequestTask?.cancel()
        treandingMoviesRequestTask = Task{
            guard let movies = try? await NetworkLayer.getTreandingMovies().send() else{return}
            if let result = movies.results{
                result.forEach { show in
                    treandingMovies.append(.show(show))
                }
            }
            snapshot.appendItems(self.treandingMovies, toSection: treandingMoviesSection)
            self.sections = snapshot.sectionIdentifiers
            await dataSource.apply(snapshot, animatingDifferences: true)
            treandingMoviesRequestTask = nil
        }
    }
    
    func popularMoviesNetworkRequest(){
        let popularMoviesSection = Section.movies("Popular Movies")
        snapshot.appendSections([popularMoviesSection])
        popularMoviesRequestTask?.cancel()
        popularMoviesRequestTask = Task{
            guard let movies = try? await NetworkLayer.getPopularMovies().send() else{return}
            if let result = movies.results{
                result.forEach { show in
                    popularMovies.append(.show(show))
                }
            }
            snapshot.appendItems(self.popularMovies, toSection: popularMoviesSection)
            self.sections = snapshot.sectionIdentifiers
            await dataSource.apply(snapshot, animatingDifferences: true)
            popularMoviesRequestTask = nil
        }
    }
    
    func upcomingMoviesNetworkRequest(){
        let upcomingMoviesSection = Section.movies("Upcoming Movies")
        snapshot.appendSections([upcomingMoviesSection])
        upcomingMoviesRequestTask?.cancel()
        upcomingMoviesRequestTask = Task{
            guard let movies = try? await NetworkLayer.getUpcomingMovies().send() else{return}
            if let result = movies.results{
                result.forEach { show in
                    upcomingMovies.append(.show(show))
                }
            }
            snapshot.appendItems(self.upcomingMovies, toSection: upcomingMoviesSection)
            self.sections = snapshot.sectionIdentifiers
            await dataSource.apply(snapshot, animatingDifferences: true)
            upcomingMoviesRequestTask = nil
        }
    }
    
    
    func topRatedMoviesNetWorkRequest(){
        let topRatedMoviesSection = Section.movies("Top rated")

        snapshot.appendSections([topRatedMoviesSection])
        topRatedMoviesRequestTask?.cancel()
        topRatedMoviesRequestTask = Task{
            guard let movies = try? await NetworkLayer.getTopRatedMovies().send() else{return}
            if let result = movies.results{
                result.forEach { show in
                    topRatedMovies.append(.show(show))
                }
            }
            snapshot.appendItems(self.topRatedMovies, toSection: topRatedMoviesSection)
            self.sections = snapshot.sectionIdentifiers
            await dataSource.apply(snapshot, animatingDifferences: true)
            topRatedMoviesRequestTask = nil
        }
    }
}

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
    enum ViewModel {
        enum Section: Hashable {
           case header
           case movies(String)
       }

        enum Item: Hashable{
            case header(HeroHeader)

            var header: HeroHeader? {
                if case .header(let header) = self {
                    return header
                } else {
                    return nil
                }
            }

            static var heroHeader: Item? = nil
            static var treandingMovies: [Item] = []
            static var popular: [Item] = []
            static var upcomingMovies: [Item] = []
            static var topRated: [Item] = []

            
        }
    }
    
    // MARK: - Properties
    var dataSource: UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>!
    var snapshot: NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>!
    var sections = [ViewModel.Section]()
    
    // MARK: - Views
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.register(HeroHeaderCollectionViewCell.self, forCellWithReuseIdentifier: HeroHeaderCollectionViewCell.reuseIdentifer)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: SectionHeaderView.supplementaryViewOfKind, withReuseIdentifier: SectionHeaderView.reuseIdentifer)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        

        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.collectionViewLayout = collectionViewLayout()


    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        networkRequest()
        collectionView.delegate = self
        configureNavigationItem()
        
        Task{
            let movies = try await NetworkLayer.getTreandingTVs().send()
            print(movies.results![0])
        }
    
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: - Network Request
    func networkRequest(){
        ViewModel.Item.heroHeader = .header(HeroHeader())
        
        ViewModel.Item.treandingMovies = [.header(HeroHeader()), .header((HeroHeader())), .header(HeroHeader()), .header((HeroHeader())), .header(HeroHeader()), .header((HeroHeader()))]
        ViewModel.Item.popular = [.header(HeroHeader()), .header((HeroHeader())), .header(HeroHeader()), .header((HeroHeader())), .header(HeroHeader()), .header((HeroHeader()))]
        ViewModel.Item.upcomingMovies = [.header(HeroHeader()), .header((HeroHeader())), .header(HeroHeader()), .header((HeroHeader())), .header(HeroHeader()), .header((HeroHeader()))]
        ViewModel.Item.topRated = [.header(HeroHeader()), .header((HeroHeader())), .header(HeroHeader()), .header((HeroHeader())), .header(HeroHeader()), .header((HeroHeader()))]
        configureDataSource()
    }
    
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
                section.orthogonalScrollingBehavior = .groupPaging
                return section
                       
            case .movies:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85),heightDimension: .estimated(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                
                let header = self.createSupplementaryItem(ofWidth: .fractionalWidth(1), ofHeight: .estimated(33), alignment: .top, for: SectionHeaderView.supplementaryViewOfKind)
                section.boundarySupplementaryItems = [header]
                
                return section
            }
        }
        return layout
    }
    
    // MARK: - Configure Data Source
    func configureDataSource() {
        dataSourceInitialization()
        supplementaryViewProfider()
        snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
        
        snapshot.appendSections([.header])
        if let heroHeader = ViewModel.Item.heroHeader{
            snapshot.appendItems([heroHeader], toSection: .header)
        }
        
        let treandingMovies = ViewModel.Section.movies("Treanding Movies")
        let popular = ViewModel.Section.movies("Popular")
        let upcomingMovies = ViewModel.Section.movies("Upcoming Movies")
        let topRated = ViewModel.Section.movies("Top rated")
        
        snapshot.appendSections([treandingMovies, popular, upcomingMovies, topRated])

        snapshot.appendItems(ViewModel.Item.treandingMovies, toSection: treandingMovies)
        snapshot.appendItems(ViewModel.Item.popular, toSection: popular)
        snapshot.appendItems(ViewModel.Item.upcomingMovies, toSection: upcomingMovies)
        snapshot.appendItems(ViewModel.Item.topRated, toSection: topRated)
        self.sections = snapshot.sectionIdentifiers
        
        dataSource.apply(snapshot)

    }

    
    // MARK: - Data Source initialization
    func dataSourceInitialization(){
        dataSource = .init(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let section = self.sections[indexPath.section]
            switch section{
            case .header:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeroHeaderCollectionViewCell.reuseIdentifer, for: indexPath) as! HeroHeaderCollectionViewCell
                if let item = itemIdentifier.header{
                    cell.configureCell(heroHeader: item)
                }
                return cell
            case .movies:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = UIColor.random
                return cell
            }
           
        })
        
    }
    
    
    // MARK: - configure Sections Header
    func createSupplementaryItem(ofWidth width: NSCollectionLayoutDimension,ofHeight height: NSCollectionLayoutDimension, alignment: NSRectAlignment, for supplenentaryKind: String) -> NSCollectionLayoutBoundarySupplementaryItem{
        
        let headerItemSize = NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
        let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: supplenentaryKind, alignment: alignment)
//        headerItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
        
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

    
    // MARK: - Configure navigationItem
    func configureNavigationItem(){
        let netflixLogo = UIImage(named: "netflix")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: netflixLogo, style: .done, target: nil, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: nil, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: nil, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .label
    }
    
}

extension HomeViewController: UICollectionViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let saveAreaOffset = view.safeAreaInsets.top
        let scrollViewOffset = scrollView.contentOffset.y + saveAreaOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: -scrollViewOffset)
    }
    
 

    
}




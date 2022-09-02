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
            static var moviesCollcetion: [Item] = []
            
        }
    }
    
    // MARK: - Properties
    var dataSource: UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>!
    var sections = [ViewModel.Section]()


    // MARK: - Views
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.register(HeroHeaderCollectionViewCell.self, forCellWithReuseIdentifier: HeroHeaderCollectionViewCell.reuseIdentifer)
        
        

        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.collectionViewLayout = collectionViewLayout()


    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        networkRequest()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }
    

    // MARK: - Network Request
    func networkRequest(){
        ViewModel.Item.heroHeader = .header(HeroHeader())
        
        ViewModel.Item.moviesCollcetion = [.header(HeroHeader()), .header((HeroHeader())), .header(HeroHeader()), .header((HeroHeader())), .header(HeroHeader()), .header((HeroHeader()))]

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
                
                return section
            }
        }
        return layout
    }
    
    // MARK: - Configure Data Source
    func configureDataSource() {
        dataSourceInitialization()

        var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
        
//        let treandingMoviesSection = ViewModel.Section.movies("treanding")
//        let treandingTVSection = ViewModel.Section.movies("TV")
//
        snapshot.appendSections([.header])
        if let heroHeader = ViewModel.Item.heroHeader{
            snapshot.appendItems([heroHeader], toSection: .header)
        }
//        snapshot.appendItems(ViewModel.Item.moviesCollcetion, toSection: treandingMoviesSection)
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
            default:
                fatalError("")
            }
           
        })
    }


}

//
//  UpComingViewController.swift
//  Netflix Clone
//
//  Created by Ahmed Yamany on 31/08/2022.
//

import UIKit

class UpComingViewController: UIViewController {
    // MARK: - SubViews
    let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(UpComingTableViewCell.self, forCellReuseIdentifier: UpComingTableViewCell.reuseIdentifer)
        return tableView
    }()
    
    // MARK: - Properties
    var upcomingMovies: [Show] = []
    
    var upcomingMoviesRequestTask: Task<Void, Never>? = nil
    
    // MARK: - Views
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Coming Soon"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        upcomingMoviesNetworkRequest()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}


extension UpComingViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpComingTableViewCell.reuseIdentifer, for: indexPath) as? UpComingTableViewCell else {return UITableViewCell()}
        let movie = upcomingMovies[indexPath.row]
        
        cell.configureCell(with: movie)

        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

// MARK: - Network Request
extension UpComingViewController{
    func upcomingMoviesNetworkRequest(){
        
        upcomingMoviesRequestTask?.cancel()
        upcomingMoviesRequestTask = Task{
            guard let movies = try? await NetworkLayer.getUpcomingMovies().send() else{return}
            if let results = movies.results{
                upcomingMovies = results
            }
            upcomingMoviesRequestTask = nil
            tableView.reloadData()
        }
    }
}

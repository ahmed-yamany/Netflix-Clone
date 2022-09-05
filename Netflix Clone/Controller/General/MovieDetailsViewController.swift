//
//  MovieDetailsViewController.swift
//  Netflix Clone
//
//  Created by Ahmed Yamany on 05/09/2022.
//

import UIKit
import WebKit
class MovieDetailsViewController: UIViewController {
    // MARK: - SubViews
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let webKitView: WKWebView = {
        let webView = WKWebView()
        let myURL = URL(string:"https://www.youtube.com/embed/1O6Qstncpnc")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        return webView
    }()
    
    let movieDescriptionLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
                
        return label
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        
        button.backgroundColor = .red
        
        return button
    }()
    
    // MARK: - Properties
    let webKitViewIndexPath = IndexPath(row: 0, section: 0)
    let movieDescriptionIndexPath = IndexPath(row: 1, section: 0)
    let downloadButtonIndexPth = IndexPath(row: 2, section: 0)
  
    var movie: Show?
    
    // MARK: - Views
    convenience init(movie: Show?) {
          self.init()
          self.movie = movie
      }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.transform = .init(translationX: 0, y: 0)
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        guard let movie = movie else {
            return
        }

        navigationItem.title = movie.title
        movieDescriptionLabel.text = movie.overview
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.reloadData()
    }


}

// MARK: - UITableViewDelegate
extension MovieDetailsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath{
        case webKitViewIndexPath:
            return 300
        case movieDescriptionIndexPath:
            return 150
        case downloadButtonIndexPth:
            return 100
        default:
            return tableView.estimatedRowHeight
        }
    }
    
}

// MARK: - UITableViewDataSource
extension MovieDetailsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        switch indexPath{
        case webKitViewIndexPath:
            cell.addSubview(webKitView)
            
            webKitView.frame = cell.bounds
        case movieDescriptionIndexPath:
            cell.addSubview(movieDescriptionLabel)
            movieDescriptionLabel.frame = cell.bounds
        case downloadButtonIndexPth:
            cell.addSubview(downloadButton)
            downloadButton.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            downloadButton.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        default:
            return cell
        }
       
        return cell

    }

}


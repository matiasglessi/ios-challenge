//
//  FeedViewController.swift
//  ios-challenge
//
//  Created by Matias Glessi on 06/10/2020.
//

import UIKit

class FeedViewController: UIViewController,
                          UITableViewDelegate,
                          UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var feedViewModel: FeedViewModel!
    private let refreshControl = UIRefreshControl()
    
    private let apiClient = URLSessionAPIClient(mapper: PostMapper())

    override func viewDidLoad() {
        super.viewDidLoad()
        feedViewModel = FeedViewModel(apiClient: apiClient)
        feedViewModel.delegate = self
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAllPosts), for: .valueChanged)
        refreshControl.tintColor = .orange
        
        self.getPosts()
    }
    
    @objc private func refreshAllPosts() {
        self.getPosts()
    }

    private func getPosts() {
        feedViewModel.getPosts { [weak self] (error) in
            if error == nil {
                self?.updateTableView()
            }
        }
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    @IBAction func dismissAll(_ sender: Any) {
        let postCount = feedViewModel.getPostsCount()
        feedViewModel.removeAllPosts()
        let indexes = getAllIndexes(with: postCount)
        deleteRows(at: indexes)
    }
    
    private func getAllIndexes(with count: Int) -> [IndexPath] {
        return (0..<count).compactMap { value in
            return IndexPath(item: value, section: 0)
        }
    }
    
    private func deleteRows(at indexes: [IndexPath]) {
        tableView.deleteRows(at: indexes, with: .automatic)
    }
        
    func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.getPostsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        let post = feedViewModel.getPostForNewCell(at: indexPath.row)
        cell.configure(for: post)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            
            if let indexPath = sender as? IndexPath,
               let post = self.feedViewModel.getPost(at: indexPath.row) {
                
                
                let destination = segue.destination as? UINavigationController
                let detailViewController = destination?.viewControllers[0] as? DetailViewController
                detailViewController?.viewModel = DetailViewModel(post: post, apiClient: apiClient)
            }
        }
        
    }
}

extension FeedViewController: FeedCellDelegate {
    func dismissPost(in cell: FeedTableViewCell){
        if let indexPath = tableView.indexPath(for: cell) {
            self.feedViewModel.removePost(at: indexPath.row)
            self.deleteRows(at: [indexPath])
        }
    }

    func markAsRead(in cell: FeedTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            self.feedViewModel.markAsRead(at: indexPath.row)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func openImageUrl(in cell: FeedTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let post = self.feedViewModel.getPost(at: indexPath.row)
            if let fullPictureUrl = post?.fullPictureUrl,
               let url = URL(string: fullPictureUrl) {
                UIApplication.shared.open(url)
            }
        }

    }
}

extension FeedViewController: FeedViewModelDelegate {
    func newPostsAdded() {
        self.updateTableView()
    }
}

protocol FeedCellDelegate: class {
    func openImageUrl(in cell: FeedTableViewCell)
    func dismissPost(in cell: FeedTableViewCell)
    func markAsRead(in cell: FeedTableViewCell)
}

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

    override func viewDidLoad() {
        super.viewDidLoad()
        feedViewModel = FeedViewModel(apiClient: URLSessionAPIClient(mapper: PostMapper()))
        tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        feedViewModel.getPosts { [weak self] (error) in
            if error == nil {
                self?.updateTableView()
            }
        }
    }
    
    private func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
        let post = feedViewModel.getPost(at: indexPath.row)
        cell.configure(for: post)
        return cell
    }
}

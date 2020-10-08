//
//  FeedTableViewController.swift
//  ios-challenge
//
//  Created by Matias Glessi on 06/10/2020.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    var feedViewModel: FeedViewModel!

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

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView,numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.getPostsCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as! FeedTableViewCell
        let post = feedViewModel.getPost(at: indexPath.row)
        cell.configure(for: post)
        return cell
    }
}

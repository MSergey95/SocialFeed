
import Foundation
import UIKit


class PostListViewController: UIViewController {

    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let viewModel = PostListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Posts"

        setupTableView()

        // Загружаем первую страницу
        viewModel.refreshPosts {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none

        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func pullToRefresh() {
        viewModel.refreshPosts {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
}

extension PostListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        let post = viewModel.posts[indexPath.row]
        cell.configure(with: post)
        cell.onLikeTapped = { [weak self] updatedPost in
            self?.viewModel.updateLike(updatedPost)
            if let row = self?.viewModel.posts.firstIndex(where: { $0.id == updatedPost.id }) {
                self?.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
            }
        }
        return cell
    }

    // Пагинация: когда доходим до 5 последних ячеек, загружаем следующую страницу
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let thresholdIndex = viewModel.posts.count - 5
        if indexPath.row == thresholdIndex {
            viewModel.fetchNextPage {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}


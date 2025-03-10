
import Foundation
import UIKit

class PostListViewController: UIViewController {

    let tableView = UITableView()
    let viewModel = PostListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = "Posts"

        setupTableView()

        // Если в init() ViewModel загрузила офлайн-посты,
        // то у нас уже есть что показывать
        tableView.reloadData()

        // Потом делаем сетевой запрос
        viewModel.fetchPostsFromAPI {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
    }
}

extension PostListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.posts.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
                as? PostTableViewCell else {
            return UITableViewCell()
        }

        let post = viewModel.posts[indexPath.row]
        cell.configure(with: post)
        return cell
    }
}

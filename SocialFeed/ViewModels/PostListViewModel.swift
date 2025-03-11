import Foundation
import UIKit


class PostListViewModel {
    private let repository = PostRepository()
    var posts: [Post] = []

    // Параметры пагинации
    private var currentStart = 0
    private let limit = 20
    private var isFetching = false
    private var allDataLoaded = false

    // Синхронизация через serialQueue
    private let serialQueue = DispatchQueue(label: "com.myapp.PostListViewModelQueue", attributes: .concurrent)

    init() {
        posts = repository.loadPosts()
        currentStart = posts.count
    }

    /// Полная перезагрузка (pull-to-refresh)
    func refreshPosts(completion: @escaping () -> Void) {
        serialQueue.async(flags: .barrier) {
            self.currentStart = 0
            self.allDataLoaded = false
            self.isFetching = false
        }
        APIClient.getPosts(start: 0, limit: limit) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let fetchedPosts):
                self.repository.savePosts(fetchedPosts) {
                    let updatedPosts = self.repository.loadPosts()
                    self.serialQueue.async(flags: .barrier) {
                        self.posts = updatedPosts
                        self.currentStart = updatedPosts.count
                        self.isFetching = false
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                }
            case .failure(let error):
                print("Error refreshing posts: \(error)")
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }

    /// Загрузка следующей страницы (пагинация)
    func fetchNextPage(completion: @escaping () -> Void) {
        serialQueue.async(flags: .barrier) {
            if self.isFetching || self.allDataLoaded {
                DispatchQueue.main.async { completion() }
                return
            }
            self.isFetching = true
            let startIndex = self.currentStart
            APIClient.getPosts(start: startIndex, limit: self.limit) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let newPosts):
                    if newPosts.isEmpty {
                        self.serialQueue.async(flags: .barrier) {
                            self.allDataLoaded = true
                            self.isFetching = false
                            DispatchQueue.main.async { completion() }
                        }
                    } else {
                        self.repository.savePosts(newPosts) {
                            let updatedPosts = self.repository.loadPosts()
                            self.serialQueue.async(flags: .barrier) {
                                self.posts = updatedPosts
                                self.currentStart = updatedPosts.count
                                self.isFetching = false
                                DispatchQueue.main.async { completion() }
                            }
                        }
                    }
                case .failure(let error):
                    print("Error fetching next page: \(error)")
                    self.serialQueue.async(flags: .barrier) {
                        self.isFetching = false
                        DispatchQueue.main.async { completion() }
                    }
                }
            }
        }
    }

    func updateLike(_ updatedPost: Post) {
        serialQueue.async(flags: .barrier) {
            if let index = self.posts.firstIndex(where: { $0.id == updatedPost.id }) {
                self.posts[index] = updatedPost
            }
            self.repository.updateLikeState(updatedPost)
        }
    }
}

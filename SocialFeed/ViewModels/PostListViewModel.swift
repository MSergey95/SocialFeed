import Foundation

class PostListViewModel {
    var posts: [Post] = []
    private let postRepository = PostRepository()

    // При инициализации — загрузить сохранённые посты (офлайн)
    init() {
        self.posts = postRepository.loadPosts()
    }

    var errorMessage: String?

    // Метод для загрузки реальных данных (с JSONPlaceholder)
      func fetchPostsFromAPI(completion: @escaping () -> Void) {
          APIClient.getPosts { [weak self] result in
              switch result {
              case .success(let posts):
                  self?.posts = posts
                  // Сохраняем в CoreData
                  self?.postRepository.savePosts(posts)
              case .failure(let error):
                  print("Error: \(error)")
                  // Можно тут показать Alert или еще что
              }
              completion()
          }
      }
  }

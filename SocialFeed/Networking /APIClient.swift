import Foundation
import Alamofire


struct APIClient {
    /// Получаем часть постов с JSONPlaceholder
    static func getPosts(
        start: Int,
        limit: Int,
        completion: @escaping (Result<[Post], Error>) -> Void
    ) {
        let url = "https://jsonplaceholder.typicode.com/posts?_start=\(start)&_limit=\(limit)"

        AF.request(url).responseDecodable(of: [Post].self) { response in
            switch response.result {
            case .success(let posts):
                completion(.success(posts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

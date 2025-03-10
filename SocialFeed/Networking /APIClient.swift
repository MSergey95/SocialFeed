
import Foundation
import Alamofire

struct APIClient {
    static func getPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        let url = "https://jsonplaceholder.typicode.com/posts"
        AF.request(url, method: .get).responseDecodable(of: [Post].self) { response in
            switch response.result {
            case .success(let posts):
                // Если парсинг успешен, posts — это массив [Post].
                completion(.success(posts))
            case .failure(let error):
                // Если запрос упал, передаём ошибку.
                completion(.failure(error))
            }
        }
    }
}

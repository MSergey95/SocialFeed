import Foundation

struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String

    // В JSONPlaceholder нет поля "imageURL",
    // но мы можем сами придумать логику, напр. через Lorem Picsum:
    var imageURL: URL {
        // Пример: https://picsum.photos/200?random=ID
        // или просто https://picsum.photos/200/300
        // Можем привязать к userId (чтобы аватарка была "стабильной") или к id
        return URL(string: "https://picsum.photos/id/\(userId)/200/300")!
    }
}

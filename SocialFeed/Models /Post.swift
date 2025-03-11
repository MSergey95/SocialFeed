import Foundation

struct Post: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let body: String

    // Эти поля заполняются из CoreData после скачивания изображений.
    var imageData: Data?
    var avatarData: Data?

    // Лайк по умолчанию.
    var isLiked: Bool = false

    // Вычисляемая ссылка для картинки поста.
    // Используем id % 20 для seed, чтобы seed всегда был в диапазоне 0...19 (где гарантировано есть изображение).
    var imageURL: URL {
        return URL(string: "https://picsum.photos/seed/\(id % 20)/400/300")!
    }

    // Вычисляемая ссылка для аватарки.
    // Используем userId % 10 для seed, чтобы seed был в диапазоне 0...9.
    var avatarURL: URL {
        return URL(string: "https://picsum.photos/seed/\(userId % 10)/50/50")!
    }

    enum CodingKeys: String, CodingKey {
        case userId, id, title, body
    }
}

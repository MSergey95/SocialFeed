
import Foundation
import CoreData

class PostRepository {

    // Сохранить массив постов
    func savePosts(_ posts: [Post]) {
        let context = CoreDataStack.shared.mainContext

        // Например, сначала можно очистить старые записи (если нужно)
        // let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PostEntity.fetchRequest()
        // let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        // try? context.execute(deleteRequest)

        for post in posts {
            let entity = PostEntity(context: context)
            entity.id = Int64(post.id)
            entity.userId = Int64(post.userId)
            entity.title = post.title
            entity.body = post.body
        }
        // Сохраняем изменения
        CoreDataStack.shared.saveContext()
    }

    // Загрузить все посты
    func loadPosts() -> [Post] {
        let context = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()

        do {
            let entities = try context.fetch(fetchRequest)
            // Преобразуем PostEntity -> Post
            return entities.map { entity in
                Post(
                    userId: Int(entity.userId),
                    id: Int(entity.id),
                    title: entity.title ?? "",
                    body: entity.body ?? ""
                )
            }
        } catch {
            print("Error loading posts: \(error)")
            return []
        }
    }
}

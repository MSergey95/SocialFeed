import Foundation
import CoreData

class PostRepository {

    func savePosts(_ posts: [Post], completion: @escaping () -> Void) {
        let bgContext = CoreDataStack.shared.persistentContainer.newBackgroundContext()

        // Очистим существующие записи, чтобы избежать конфликтов и дублирования.
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = PostEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try bgContext.execute(deleteRequest)
        } catch {
            print("Error deleting old posts: \(error)")
        }

        let dispatchGroup = DispatchGroup()

        for post in posts {
            let entity = PostEntity(context: bgContext)
            entity.id = Int64(post.id)
            entity.userId = Int64(post.userId)
            entity.title = post.title
            entity.body = post.body
            entity.isLiked = post.isLiked

            // Скачиваем изображение поста по вычисляемому URL.
            dispatchGroup.enter()
            downloadImage(from: post.imageURL) { data in
                bgContext.perform {
                    if let data = data {
                        entity.imageData = data
                        print("Saved imageData for post.id=\(post.id), size=\(data.count)")
                    } else {
                        print("No imageData for post.id=\(post.id)")
                    }
                    dispatchGroup.leave()
                }
            }

            // Скачиваем аватарку.
            dispatchGroup.enter()
            downloadImage(from: post.avatarURL) { data in
                bgContext.perform {
                    if let data = data {
                        entity.avatarData = data
                        print("Saved avatarData for post.id=\(post.id), size=\(data.count)")
                    } else {
                        print("No avatarData for post.id=\(post.id)")
                    }
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .global()) {
            bgContext.perform {
                do {
                    try bgContext.save()
                    print("savePosts done. Attempting to see if data is saved.")
                } catch {
                    print("Error saving background context: \(error)")
                }
                completion()
            }
        }
    }

    func loadPosts() -> [Post] {
        let context = CoreDataStack.shared.mainContext
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        // Сортируем по id, чтобы порядок соответствовал ожиданиям.
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]

        do {
            let entities = try context.fetch(request)
            // Выведем для отладки
            for (i, entity) in entities.enumerated().prefix(5) {
                print("[\(i)] entity.id=\(entity.id), imageData=\(entity.imageData?.count ?? 0) bytes, avatarData=\(entity.avatarData?.count ?? 0) bytes")
            }
            return entities.map { entity in
                var post = Post(
                    userId: Int(entity.userId),
                    id: Int(entity.id),
                    title: entity.title ?? "",
                    body: entity.body ?? ""
                )
                post.isLiked = entity.isLiked
                post.imageData = entity.imageData
                post.avatarData = entity.avatarData
                return post
            }
        } catch {
            print("Error loading posts: \(error)")
            return []
        }
    }

    func updateLikeState(_ post: Post) {
        let context = CoreDataStack.shared.mainContext
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", post.id)
        do {
            if let entity = try context.fetch(request).first {
                entity.isLiked = post.isLiked
                try context.save()
            }
        } catch {
            print("Error updating like: \(error)")
        }
    }

    private func downloadImage(from url: URL, completion: @escaping (Data?) -> Void) {
        print("Downloading image from: \(url.absoluteString)")
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data, error == nil {
                print("Got \(data.count) bytes for: \(url.absoluteString)")
                completion(data)
            } else {
                print("Error downloading image from \(url): \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }.resume()
    }
}

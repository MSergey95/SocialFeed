
import CoreData
import Foundation

class CoreDataStack {

    // Синглтон
    static let shared = CoreDataStack()
    private init() {}

    // Создаём NSPersistentContainer
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PostModel")
        // "PostModel" — это то же имя, что и .xcdatamodeld

        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
        return container
    }()

    // Удобный доступ к viewContext (главному контексту)
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Сохранить контекст
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}

import CoreData

final class CoreDataManager {
    
    // MARK: - Static Properties
    static let shared = CoreDataManager()
    
    // MARK: - Private Properties
    private let persistentContainer: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    // MARK: - Initializers
    private init() {
        DaysValueTransformer.register()
        UIColorValueTransformer.register()
        
        persistentContainer = NSPersistentContainer(name: "Tracker")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data error: \(error)")
            }
        }
        self.context = persistentContainer.viewContext
        
    }
    
    // MARK: - Public Methods
    func getContext() -> NSManagedObjectContext {
        return self.context
    }
}

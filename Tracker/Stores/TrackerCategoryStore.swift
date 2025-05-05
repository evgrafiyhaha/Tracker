import CoreData
import UIKit

enum TrackerCategoryStoreError: Error {
    case decodingError
}

final class TrackerCategoryStore: NSObject {

    // MARK: - Public Properties
    var catigories: [TrackerCategory] {
        guard let objects = fetchedResultsController.fetchedObjects else { return [] }
        return objects.compactMap { try? category(from: $0) }
    }

    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>

    // MARK: - Initializers
    init(context: NSManagedObjectContext) {
        self.context = context

        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCategoryCoreData.name, ascending: true)]
        fetchRequest.relationshipKeyPathsForPrefetching = ["trackers"]

        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        self.fetchedResultsController = controller

        super.init()
        do {
            try controller.performFetch()
        } catch {
            print("[TrackerCategoryStore.init]: Не удалось выполнить fetch — \(error.localizedDescription)")
        }
    }

    // MARK: - Public Methods
    func addNewCategory(_ category: TrackerCategory) {
        do {
            if let _ = try fetchCategoryCoreData(by: category) {
                print("[TrackerCategoryStore.addNewCategory]: Категория \"\(category.name)\" уже существует")
                return
            }

            let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
            trackerCategoryCoreData.name = category.name

            saveContext()
            try? fetchedResultsController.performFetch()

        } catch {
            print("[TrackerCategoryStore.addNewCategory]: Ошибка при поиске категории — \(error.localizedDescription)")
        }
    }

    func fetchCategoryCoreData(by category: TrackerCategory) throws -> TrackerCategoryCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", category.name)
        fetchRequest.fetchLimit = 1

        let results = try context.fetch(fetchRequest)
        return results.first
    }

    // MARK: - Private Methods
    private func category(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let name = trackerCategoryCoreData.name else {
            print("[TrackerCategoryStore.category]: name == nil")
            throw TrackerCategoryStoreError.decodingError
        }

        let trackerCoreDataSet = trackerCategoryCoreData.trackers as? Set<TrackerCoreData> ?? []
        let trackers = try trackerCoreDataSet.map { trackerCoreData in
            guard
                let id = trackerCoreData.id,
                let name = trackerCoreData.name,
                let emojiString = trackerCoreData.emoji,
                let color = trackerCoreData.color as? UIColor,
                let emoji = emojiString.first
            else {
                print("[TrackerCategoryStore.category]: Не удалось декодировать Tracker")
                throw TrackerCategoryStoreError.decodingError
            }

            guard let scheduleSet = trackerCoreData.schedule as? Set<Day> else {
                print("[TrackerCategoryStore.category]: schedule не является Set<Day> — \(String(describing: trackerCoreData.schedule))")
                throw TrackerCategoryStoreError.decodingError
            }

            return Tracker(
                id: id,
                name: name,
                color: color,
                emoji: emoji,
                schedule: scheduleSet
            )
        }

        return TrackerCategory(name: name, trackers: trackers)
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("[TrackerCategoryStore.saveContext]: Контекст сохранён.")
            } catch {
                context.rollback()
                print("[TrackerCategoryStore.saveContext]: Ошибка при сохранении — \(error.localizedDescription)")
            }
        }
    }
}

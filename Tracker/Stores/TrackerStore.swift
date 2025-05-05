import CoreData
import UIKit

enum TrackerStoreError: Error {
    case decodingError
}

final class TrackerStore: NSObject {

    // MARK: - Public Properties
    var trackers: [Tracker] {
        guard let objects = fetchedResultsController.fetchedObjects else {
            print("[TrackerStore.trackers]: Ошибка — fetchedObjects пуст")
            return []
        }
        return objects.compactMap { try? tracker(from: $0) }
    }

    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>

    // MARK: - Initializers
    init(context: NSManagedObjectContext) {
        self.context = context

        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)]

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
            print("[TrackerStore.init]: Ошибка при выполнении fetch — \(error.localizedDescription)")
        }
    }

    // MARK: - Public Methods
    func addNewTracker(_ tracker: Tracker, to category: TrackerCategoryCoreData) {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = String(tracker.emoji)
        trackerCoreData.color = tracker.color
        trackerCoreData.setValue(tracker.schedule, forKey: "schedule")
        trackerCoreData.category = category

        category.addToTrackers(trackerCoreData)

        saveContext()
    }

    func fetchTrackerCoreData(by trackerId: UUID) throws -> TrackerCoreData? {
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trackerId as CVarArg)
        fetchRequest.fetchLimit = 1

        do {
            let results = try context.fetch(fetchRequest)
            return results.first
        } catch {
            print("[TrackerStore.fetchTrackerCoreData]: Ошибка при выполнении fetch — \(error.localizedDescription)")
            throw error
        }
    }

    // MARK: - Private Methods
    private func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard
            let id = trackerCoreData.id,
            let name = trackerCoreData.name,
            let emojiString = trackerCoreData.emoji,
            let emoji = emojiString.first,
            let color = trackerCoreData.color as? UIColor,
            let scheduleSet = trackerCoreData.schedule as? Set<Day>
        else {
            print("""
            [TrackerStore.tracker(from:)]: Ошибка декодирования:
            id: \(String(describing: trackerCoreData.id)),
            name: \(String(describing: trackerCoreData.name)),
            emoji: \(String(describing: trackerCoreData.emoji)),
            color: \(String(describing: trackerCoreData.color)),
            schedule: \(String(describing: trackerCoreData.schedule))
            """)
            throw TrackerStoreError.decodingError
        }

        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: scheduleSet
        )
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("[TrackerStore.saveContext]: Контекст сохранён.")
            } catch {
                context.rollback()
                print("[TrackerStore.saveContext]: Ошибка при сохранении — \(error.localizedDescription)")
            }
        }
    }
}

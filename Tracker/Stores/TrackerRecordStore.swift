import CoreData

enum TrackerRecordStoreError: Error {
    case decodingError
}

final class TrackerRecordStore {

    // MARK: - Public Properties
    func fetchTrackerRecords() {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)]

        do {
            let coreDataRecords = try context.fetch(fetchRequest)
            self.trackerRecords = coreDataRecords.compactMap { try? trackerRecord(from: $0) }
        } catch {
            print("[TrackerRecordStore.fetchTrackerRecords]: Не удалось выполнить fetch — \(error.localizedDescription)")
            self.trackerRecords = []
        }
    }

    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private(set) var trackerRecords: [TrackerRecord] = []

    // MARK: - Initializers
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchTrackerRecords()
    }

    // MARK: - Public Methods
    func addNewTrackerRecord(_ trackerRecord: TrackerRecord, to tracker: TrackerCoreData) {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.date = trackerRecord.date
        trackerRecordCoreData.tracker = tracker

        saveContext()
        fetchTrackerRecords()
    }

    func deleteTrackerRecord(with trackerId: UUID, on date: Date, using calendar: Calendar) {
        let fetchRequest: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tracker.id == %@", trackerId as CVarArg)

        do {
            let records = try context.fetch(fetchRequest)
            for record in records {
                if let recordDate = record.date, calendar.isDate(recordDate, inSameDayAs: date) {
                    context.delete(record)
                }
            }
            saveContext()
            fetchTrackerRecords()
        } catch {
            print("[TrackerRecordStore.deleteTrackerRecord]: Не удалось удалить запись — \(error.localizedDescription)")
        }
    }

    // MARK: - Private Methods
    private func trackerRecord(from coreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard
            let date = coreData.date,
            let tracker = coreData.tracker,
            let trackerID = tracker.id
        else {
            print("[TrackerRecordStore.trackerRecord]: Ошибка декодирования TrackerRecordCoreData")
            throw TrackerRecordStoreError.decodingError
        }

        return TrackerRecord(trackerId: trackerID, date: date)
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                print("[TrackerRecordStore.saveContext]: Контекст сохранён.")
            } catch {
                context.rollback()
                print("[TrackerRecordStore.saveContext]: Ошибка при сохранении — \(error.localizedDescription)")
            }
        }
    }
}

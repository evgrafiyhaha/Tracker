import Foundation

final class TrackerService: UserTrackersServiceProtocol {
    // MARK: - Public Properties
    weak var delegate: UserTrackersServiceDelegate?

    private(set) var categories: [TrackerCategory] = []
    private(set) var completedTrackers: [TrackerRecord] = []

    // MARK: - Private Properties
    private let trackerStore: TrackerStore
    private let trackerCategoryStore: TrackerCategoryStore
    private let trackerRecordStore: TrackerRecordStore

    // MARK: - Initializers
    init(
        trackerStore: TrackerStore = TrackerStore(context: CoreDataManager.shared.getContext()),
        trackerCategoryStore: TrackerCategoryStore = TrackerCategoryStore(context: CoreDataManager.shared.getContext()),
        trackerRecordStore: TrackerRecordStore = TrackerRecordStore(context: CoreDataManager.shared.getContext())
    ) {
        self.trackerStore = trackerStore
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerRecordStore = trackerRecordStore

        addCategory(TrackerCategory(name: "Домашний уют", trackers: []))
        self.categories = trackerCategoryStore.catigories
        self.completedTrackers = trackerRecordStore.trackerRecords
    }

    // MARK: - Public Methods

    func addCategory(_ category: TrackerCategory) {
        trackerCategoryStore.addNewCategory(category)
        categories = trackerCategoryStore.catigories
    }

    func getAllCategories() -> [TrackerCategory] {
        return trackerCategoryStore.catigories
    }

    func addTracker(tracker: Tracker, to category: TrackerCategory) {
        do {
            guard let trackerCategoryCoreData = try trackerCategoryStore.fetchCategoryCoreData(by: category) else {
                print("[TrackerService.addTracker]: Не удалось найти категорию с именем '\(category.name)'")
                return
            }

            trackerStore.addNewTracker(tracker, to: trackerCategoryCoreData)
            self.categories = trackerCategoryStore.catigories
            delegate?.reloadData()
        } catch {
            print("[TrackerService.addTracker]: Ошибка при получении категории — \(error)")
        }
    }

    func addTrackerRecord(_ record: TrackerRecord) {
        do {
            guard let trackerCoreData = try trackerStore.fetchTrackerCoreData(by: record.trackerId) else {
                print("[TrackerService.addTrackerRecord]: Не найден TrackerCoreData с id: \(record.trackerId)")
                return
            }

            trackerRecordStore.addNewTrackerRecord(record, to: trackerCoreData)
            completedTrackers = trackerRecordStore.trackerRecords
        } catch {
            print("[TrackerService.addTrackerRecord]: Ошибка при получении TrackerCoreData — \(error)")
        }
    }

    func removeTrackerRecord(_ record: TrackerRecord, forDate date: Date, using calendar: Calendar) {
        trackerRecordStore.deleteTrackerRecord(with: record.trackerId, on: date, using: calendar)
        completedTrackers = trackerRecordStore.trackerRecords
    }

    func updateDisplayedCategories(categories: [TrackerCategory]) {
        self.categories = categories
    }

    func getAllTrackersCount() -> Int {
        return categories.flatMap { $0.trackers }.count
    }
}

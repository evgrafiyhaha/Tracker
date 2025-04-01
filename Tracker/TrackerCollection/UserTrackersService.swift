import Foundation

protocol UserTrackersServiceProtocol {
    var delegate: UserTrackersServiceDelegate? { get set }
    var categories: [TrackerCategory] { get }
    var completedTrackers: [TrackerRecord] { get }
    func addCategory(_ category: TrackerCategory)
    func getAllCategories() -> [TrackerCategory]
    func addTracker(tracker: Tracker, to category: TrackerCategory)
    func addTrackerRecord(_ record: TrackerRecord)
    func removeTrackerRecord(_ record: TrackerRecord, forDate date: Date, using calendar: Calendar)
    func updateDisplayedCategories(categories: [TrackerCategory])
    func getAllTrackersCount() -> Int
}

final class UserTrackersService: UserTrackersServiceProtocol {
    
    // MARK: - Public Properties
    weak var delegate: UserTrackersServiceDelegate?
    
    lazy var categories: [TrackerCategory] = categoriesSource
    lazy var completedTrackers: [TrackerRecord] = [TrackerRecord(trackerId: trackers[0].id, date: Date()),
                                                   TrackerRecord(trackerId: trackers2[1].id, date: Date())]
    
    // MARK: - Private Properties
    private let trackers: [Tracker] = [Tracker(id: UUID(),
                                               name: "Поливать растения",
                                               color: .selection5,
                                               emoji: "❤️",
                                               schedule: [.Friday,.Monday])
    ]
    private let trackers2: [Tracker] = [Tracker(id: UUID(),
                                                name: "Кошка заслонила камеру на созвоне",
                                                color: .selection2,
                                                emoji: "😻",
                                                schedule: [.Monday]),
                                        Tracker(id: UUID(),
                                                name: "Бабушка прислала открытку в вотсапе",
                                                color: .selection1,
                                                emoji: "🌺",
                                                schedule: [.Saturday]),
                                        Tracker(id: UUID(),
                                                name: "Свидания в апреле",
                                                color: .selection14,
                                                emoji: "❤️",
                                                schedule: [.Thursday,.Monday])
    ]
    private let trackers3: [Tracker] = [Tracker(id: UUID(),
                                                name: "Хорошее настроение",
                                                color: .selection16,
                                                emoji: "🙂",
                                                schedule: [.Sunday]),
                                        Tracker(id: UUID(),
                                                name: "Легкая тревожность",
                                                color: .selection8,
                                                emoji: "😪",
                                                schedule: [.Friday]),
    ]
    private lazy var categoriesSource: [TrackerCategory] = [TrackerCategory(name: "Домашний уют", trackers: trackers),
                                                            TrackerCategory(name: "Радостные мелочи", trackers: trackers2),
                                                            TrackerCategory(name: "Самочувствие", trackers: trackers3),
                                                            TrackerCategory(name: "имя", trackers: [])
    ]//обращения к categoriesSource в следующих спринтах заменю обращением к бд, пока тут моковые данные
    
    // MARK: - Public Methods
    func addCategory(_ category: TrackerCategory) {
        categoriesSource.append(category)
    }

    func getAllCategories() -> [TrackerCategory] {
        return categoriesSource
    }

    func addTracker(tracker: Tracker, to category: TrackerCategory) {
        if let categoryIndex = categoriesSource.firstIndex(where: { $0.name == category.name }) {
            let category = categoriesSource[categoryIndex]
            let updatedCategory = TrackerCategory(name: category.name, trackers: category.trackers + [tracker])
            
            categoriesSource[categoryIndex] = updatedCategory
            categories = categoriesSource
            delegate?.reloadData()
        }
    }

    func addTrackerRecord(_ record: TrackerRecord) {
        completedTrackers.append(record)
    }

    func removeTrackerRecord(_ record: TrackerRecord, forDate date: Date, using calendar: Calendar) {
        completedTrackers.removeAll { $0.trackerId == record.trackerId && calendar.isDate($0.date, inSameDayAs: date) }
    }

    func updateDisplayedCategories(categories: [TrackerCategory]) {
        self.categories = categories
    }

    func getAllTrackersCount() -> Int {
        return categories.flatMap { $0.trackers }.count
    }
}

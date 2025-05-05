import Foundation
import UIKit

@objc
final class DaysValueTransformer: ValueTransformer {
    
    // MARK: - Static Methods
    static func register() {
        ValueTransformer.setValueTransformer(
            DaysValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: DaysValueTransformer.self))
        )
    }
    
    // MARK: - Overrides Methods
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? Set<Day> else { return nil }
        return try? JSONEncoder().encode(Array(days))
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        guard let decodedArray = try? JSONDecoder().decode([Day].self, from: data as Data) else { return nil }
        return Set(decodedArray)
    }
}

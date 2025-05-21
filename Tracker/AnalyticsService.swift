import Foundation
import YandexMobileMetrica

final class AnalyticsService {

    // MARK: - Public Methods
    func reportEvent(event: String, screen: String, item: String? = nil) {
        var params : [AnyHashable : Any] = ["event": event, "screen": screen]
        if let item = item {
            params["item"] = item
        }
        YMMYandexMetrica.reportEvent(event, parameters: params) { error in
            print("[AnalyticsService.reportEvent]: Ошибка: \(String(describing: error))")
        }
    }
}

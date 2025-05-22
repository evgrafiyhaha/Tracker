import Foundation
import YandexMobileMetrica

final class AnalyticsService {

    // MARK: - Static Methods
    static func initAnalytics() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "b2c7bda8-54fb-43b0-a358-6b2dedd0f284") else {
            return
        }
        YMMYandexMetrica.activate(with: configuration)
    }
    static func reportEvent(event: String, screen: String, item: String? = nil) {
        var params : [AnyHashable : Any] = ["event": event, "screen": screen]
        if let item = item {
            params["item"] = item
        }
        YMMYandexMetrica.reportEvent(event, parameters: params) { error in
            print("[AnalyticsService.reportEvent]: Ошибка: \(String(describing: error))")
        }
    }
}

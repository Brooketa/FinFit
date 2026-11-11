@testable import HealthCheck

extension HealthCheckResult {

    static func fixture(score: Int = 78, category: Category = .good) -> HealthCheckResult {
        HealthCheckResult(score: score, category: category)
    }

}

import Foundation
import Testing
@testable import HealthCheck

@MainActor
@Suite("ResultPresenter")
final class ResultPresenterTests {

    private let routerSpy = HealthCheckRouterSpy()

    @Test("The summary's progress is the score out of 100")
    func progressIsScoreOutOf100() {
        let resultPresenter = ResultPresenter(result: .fixture(score: 64), router: routerSpy)

        #expect(resultPresenter.summary.progress == 0.64)
    }

    @Test(
        "Each category shows its own title and subtitle",
        arguments: [
            (
                HealthCheckResult.Category.poor,
                LocalizedStringResource.resultPoorTitle,
                LocalizedStringResource.resultPoorSubtitle
            ),
            (.fair, .resultFairTitle, .resultFairSubtitle),
            (.good, .resultGoodTitle, .resultGoodSubtitle),
            (.excellent, .resultExcellentTitle, .resultExcellentSubtitle)
        ])
    func categoryShowsItsTitleAndSubtitle(
        category: HealthCheckResult.Category,
        title: LocalizedStringResource,
        subtitle: LocalizedStringResource
    ) {
        let resultPresenter = ResultPresenter(result: .fixture(category: category), router: routerSpy)

        #expect(resultPresenter.summary.title == title)
        #expect(resultPresenter.summary.subtitle == subtitle)
    }

    @Test("Tapping Finish navigates to the intro")
    func finishNavigatesToIntro() {
        let resultPresenter = ResultPresenter(result: .fixture(), router: routerSpy)

        resultPresenter.onFinishTapped()

        #expect(routerSpy.calls == [.intro])
    }

    @Test("Tapping Retake navigates back to the questionnaire")
    func retakeNavigatesBackToQuestionnaire() {
        let resultPresenter = ResultPresenter(result: .fixture(), router: routerSpy)

        resultPresenter.onRetakeTapped()

        #expect(routerSpy.calls == [.backToQuestionnaire])
    }

}

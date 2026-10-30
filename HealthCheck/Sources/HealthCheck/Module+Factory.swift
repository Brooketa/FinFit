import FactoryKit
import Networking

extension Container {

    // MARK: Presenters

    @MainActor
    public var introPresenter: Factory<IntroPresenter> {
        self { IntroPresenter(router: self.healthCheckRouting()!) }
    }

    @MainActor
    public var questionnairePresenter: Factory<QuestionnairePresenter> {
        self { QuestionnairePresenter(questionnaireUseCase: self.questionnaireUseCase) }
    }

    @MainActor
    public var resultPresenter: Factory<ResultPresenter> {
        self { ResultPresenter() }
    }

    // MARK: Routing

    public var healthCheckRouting: Factory<(any HealthCheckRoutingProtocol)?> {
        promised()
    }

    // MARK: Use cases

    private var questionnaireUseCase: any QuestionnaireUseCaseProtocol {
        self { QuestionnaireUseCase(questionnaireRepository: self.questionnaireRepository) }.resolve()
    }

    // MARK: Repositories

    private var questionnaireRepository: any QuestionnaireRepositoryProtocol {
        self { QuestionnaireRepository(questionnaireDataSource: self.questionnaireDataSource) }.resolve()
    }

    // MARK: Data sources

    private var questionnaireDataSource: any QuestionnaireDataSourceProtocol {
        self { QuestionnaireDataSource(questionnaireNetworkClient: self.questionnaireNetworkClient) }.resolve()
    }

    // MARK: Clients

    private var questionnaireNetworkClient: any QuestionnaireNetworkClientProtocol {
        self { QuestionnaireNetworkClient(baseNetworkClient: self.baseNetworkClient()) }.resolve()
    }

}

import Foundation
import FactoryKit
import Core
import Networking

extension Container {

    // MARK: Presenters

    @MainActor
    public var introPresenter: Factory<IntroPresenter> {
        self { IntroPresenter(sessionStore: self.sessionStore, router: self.healthCheckRouting()!) }
    }

    @MainActor
    public var questionnairePresenter: ParameterFactory<UUID, QuestionnairePresenter> {
        self { sessionID in
            QuestionnairePresenter(
                sessionID: sessionID,
                questionnaireUseCase: self.questionnaireUseCase,
                sessionStore: self.sessionStore,
                router: self.healthCheckRouting()!)
        }
    }

    @MainActor
    public var resultPresenter: ParameterFactory<HealthCheckResult, ResultPresenter> {
        self { result in ResultPresenter(result: result, router: self.healthCheckRouting()!) }
    }

    // MARK: Routing

    public var healthCheckRouting: Factory<(any HealthCheckRoutingProtocol)?> {
        promised()
    }

    // MARK: Use cases

    private var questionnaireUseCase: any QuestionnaireUseCaseProtocol {
        self { QuestionnaireUseCase(questionnaireRepository: self.questionnaireRepository) }.resolve()
    }

    // MARK: Stores

    private var sessionStore: any SessionStoreProtocol {
        self { UserDefaultsSessionStore(userDefaultsService: self.userDefaultsService()) }.resolve()
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

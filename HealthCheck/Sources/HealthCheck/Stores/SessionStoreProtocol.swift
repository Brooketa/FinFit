import Foundation

protocol SessionStoreProtocol {

    var sessionID: UUID? { get }

    func save(sessionID: UUID)
    func removeSessionID()

}

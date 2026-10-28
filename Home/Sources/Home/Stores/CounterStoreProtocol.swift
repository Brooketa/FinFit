protocol CounterStoreProtocol {

    var count: Int { get }

    func save(count: Int)

}

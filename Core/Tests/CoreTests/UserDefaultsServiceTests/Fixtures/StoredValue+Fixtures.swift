extension StoredValue {

    static func fixture(name: String = "Savings goal", count: Int = 3) -> StoredValue {
        StoredValue(name: name, count: count)
    }

}

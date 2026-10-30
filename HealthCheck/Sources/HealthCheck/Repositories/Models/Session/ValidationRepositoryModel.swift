struct ValidationRepositoryModel: Sendable {

    let required: Bool?
    let min: Double?
    let max: Double?
    let minSelections: Int?
    let maxSelections: Int?

}

extension ValidationRepositoryModel {

    init(from model: ValidationDataSourceModel) {
        self.init(
            required: model.required,
            min: model.min,
            max: model.max,
            minSelections: model.minSelections,
            maxSelections: model.maxSelections)
    }

}

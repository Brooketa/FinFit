extension TestBody {

    static func fixture(questionId: String = "monthly_income", answer: Int = 2500) -> TestBody {
        TestBody(questionId: questionId, answer: answer)
    }

}

import Foundation

enum SessionJSON {

    static let singleChoiceInProgress = Data("""
        {
          "sessionId": "9cf3dc4b-7e4e-4073-bd4c-12aadfdf4930",
          "status": "in_progress",
          "question": {
            "id": "income_stability",
            "title": "How predictable is your income?",
            "type": "single_choice",
            "options": [
              { "id": "very_stable", "title": "Very predictable" },
              { "id": "unpredictable", "title": "Very unpredictable" }
            ],
            "validation": { "required": true }
          },
          "progress": { "current": 1, "total": 5 }
        }
        """.utf8)

    static let multipleChoiceInProgress = Data("""
        {
          "sessionId": "9cf3dc4b-7e4e-4073-bd4c-12aadfdf4930",
          "status": "in_progress",
          "question": {
            "id": "investment_goals",
            "title": "What are you investing for?",
            "description": "Select up to three goals.",
            "type": "multiple_choice",
            "options": [
              { "id": "retirement", "title": "Retirement" },
              { "id": "home", "title": "Buying a home" }
            ],
            "validation": { "required": true, "minSelections": 1, "maxSelections": 3 }
          },
          "progress": { "current": 2, "total": 5 }
        }
        """.utf8)

    static let numberInProgress = Data("""
        {
          "sessionId": "9cf3dc4b-7e4e-4073-bd4c-12aadfdf4930",
          "status": "in_progress",
          "question": {
            "id": "emergency_fund_months",
            "title": "How many months of expenses could your emergency fund cover?",
            "type": "number",
            "validation": { "required": true, "min": 0, "max": 36 }
          },
          "progress": { "current": 3, "total": 5 }
        }
        """.utf8)

    static let questionWithoutValidation = Data("""
        {
          "sessionId": "9cf3dc4b-7e4e-4073-bd4c-12aadfdf4930",
          "status": "in_progress",
          "question": {
            "id": "monthly_income",
            "title": "What is your monthly net income?",
            "type": "number"
          },
          "progress": { "current": 4, "total": 5 }
        }
        """.utf8)

    static let completed = Data("""
        {
          "sessionId": "9cf3dc4b-7e4e-4073-bd4c-12aadfdf4930",
          "status": "completed",
          "result": { "score": 78, "category": "good" },
          "progress": { "current": 5, "total": 5 }
        }
        """.utf8)

}

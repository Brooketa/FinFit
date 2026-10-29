# Questionnaire API

How the `HealthCheck` module talks to the health-check API, through `QuestionnaireNetworkClient` and the shared base
network client.

## Start or resume a session

`startOrResumeSession(id:)` sends `POST /health-check/v1/sessions/{id}` with no body. The id is a UUID the app
generates, sent lowercased. A new id starts a session; an id the server already knows resumes that session where it
left off.

## Submit an answer

`submitAnswer(sessionID:questionID:answer:)` sends `POST /health-check/v1/sessions/{id}/submission` with the body
`{ "questionId": …, "answer": … }`, answering the session's current question. It returns the same session response as
starting a session: the next question, or the result after the last one.

The answer is an `AnswerClientModel`, encoded as a bare JSON value whose shape depends on the question type.

| Case | Question type | Sent as |
|---|---|---|
| `option(id)` | `singleChoice` | `"unpredictable"` |
| `options(ids)` | `multipleChoice` | `["retirement", "home"]` |
| `number(value)` | `number` | `18`; whole numbers are sent without a decimal point |

## Session response

The response is decoded straight into the client models, which mirror the JSON field for field.

| Model | Fields |
|---|---|
| `SessionClientModel` | `sessionId`, `status` (`inProgress` or `completed`), `question` (while in progress), `result` (once completed), `progress` |
| `QuestionClientModel` | `id`, `title`, `description` (optional), `type` (`singleChoice`, `multipleChoice` or `number`), `options` (choice questions), `validation` (optional) |
| `OptionClientModel` | `id`, `title` |
| `ValidationClientModel` | `required`, `min` and `max` (number questions), `minSelections` and `maxSelections` (multiple choice); all optional |
| `ResultClientModel` | `score` (0–100), `category` (`poor`, `fair`, `good` or `excellent`, decided by the server) |
| `ProgressClientModel` | `current`, `total` |

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

## Data source

`QuestionnaireDataSource` sits on top of the network client and offers the same two calls,
`startOrResumeSession(id:)` and `submitAnswer(sessionID:questionID:answer:)`. Its models copy the client models one to
one: session responses are mapped up from the client models, answers down to `AnswerClientModel`. The session id is
always passed in: the data source does not remember it.

The data source and the network client are registered privately in the `HealthCheck` container.

## Repository

`QuestionnaireRepository` sits on top of the data source and offers the same two calls. It decides where session
data comes from; today the data source is the only source, so every call goes to it. Its models copy the data source
models one to one, mapped up for session responses and down for answers.

The repository is registered privately in the `HealthCheck` container.

## Use case

`QuestionnaireUseCase` is what the questionnaire screens call. It sits on top of the repository, offers the same two
calls, and reshapes the session for the screens. The session id is always passed in: the use case does not remember
it.

Both calls return a `SessionUseCaseModel`:

| Case | Carries |
|---|---|
| `inProgress(question:progress:)` | The question to show, and the progress through the session |
| `completed(result:)` | The score and the category the server decided |

A question carries `isRequired` (`false` when the server sends no rule) and its `type`, which holds only what that
kind of question needs:

| Type | Carries | Missing limits become |
|---|---|---|
| `singleChoice(options:)` | The options | — |
| `multipleChoice(options:selectionRange:)` | The options, and how many may be selected | Lower: 1 if required, otherwise 0. Upper: the number of options |
| `number(valueRange:)` | The allowed values | Unbounded on that side |

An upper limit below the lower one is raised to match it, so a range always exists.

A session the server reports as in progress without a question, or completed without a result, throws
`QuestionnaireUseCaseError.invalidSession`.

The use case is registered privately in the `HealthCheck` container.

## Session store

`SessionStoreProtocol` remembers the id of the unfinished session, so a session survives the app being force-quit.
It is built on Core's `UserDefaultsService` and shared by the module's screens.

| Call | Does |
|---|---|
| `sessionID` | The saved session id, or `nil` when no session is unfinished |
| `save(sessionID:)` | Saves the id, replacing any saved one |
| `removeSessionID()` | Removes the saved id |

- **Saved:** once the server has started or resumed the session
- **Removed:** when the session completes, so a saved id always means an unfinished session

The store is registered privately in the `HealthCheck` container.


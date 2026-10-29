# Networking

The shared networking layer for every module that talks to the internet. Feature modules depend on it; it depends
on nothing above `Core`.

## Endpoint

What a feature's endpoint enum conforms to. Each case describes one request; values the request needs travel on the
case.

| Member | Content | Default |
|---|---|---|
| `path` | Appended to the base URL | — |
| `method` | `HTTPMethod`: GET, POST, PUT, DELETE or PATCH | — |
| `queryParameters` | Added to the URL as query items | None |
| `headers` | Set on the request, after the default `content-type: application/json` | None |
| `body` | Any `Encodable` value, sent JSON-encoded | None |

## Base network client

`BaseNetworkClientProtocol.request(_:)` takes an endpoint and returns the response decoded into the type the caller
asks for.

- **Building:** the request URL is the base URL followed by the endpoint's path and query parameters. Every request
  is sent as `application/json`; the endpoint's headers are set after that, so they can override it
- **Success:** any 2xx status; the body is decoded as JSON

## Errors

Every failure is an `APIError`.

| Case | When |
|---|---|
| `invalidURL` | The base URL and path do not form a valid URL |
| `encodingFailed(error)` | The body could not be JSON-encoded |
| `requestFailed(error)` | The request could not be sent or got no answer, e.g. offline or timed out |
| `invalidResponse` | The answer is not an HTTP response |
| `unexpectedStatusCode(code)` | The server answered with a status outside 2xx |
| `decodingFailed(error)` | The response could not be decoded into the requested type |

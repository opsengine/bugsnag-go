Feature: Plain handled errors

Background:
  Given I set environment variable "API_KEY" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I configure the bugsnag endpoint
  And I have built the service "nethttp"
  And I stop the service "nethttp"
  And I set environment variable "SERVER_PORT" to "4512"

Scenario: A handled error sends a report
  When I start the service "nethttp"
  And I wait for the app to open port "4512"
  And I wait for 1 seconds
  And I open the URL "http://localhost:4512/handled"
  And I wait for 1 seconds
  Then I should receive 2 requests
  And the request 0 is valid for the error reporting API
  And the request 0 contained the api key "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And the request 1 is valid for the session tracking API
  And the session in request 1 contained the api key "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And the event "unhandled" is false for request 0
  And the event "severity" equals "warning" for request 0
  And the event "severityReason.type" equals "handledError" for request 0
  And the exception "errorClass" equals "*os.PathError" for request 0
  And the "file" of stack frame 0 equals "main.go" for request 0
  And the events handled sessions count equals 1 for request 0
  And the number of sessions started equals 1 in request 1
  
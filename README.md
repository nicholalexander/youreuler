# youreuler

A cutting edge state of the art URL shortener.  (And Elongator?)

## A Note On the Naming

A guy I met once pronounced URLs as "you're ul".  But with no real empty space between the two words.  And That was different.  It is only a happy accident that the name I picked also says Your Euler.  Which I wish I an Euler.

## Installation

## TODO

1. custom errors
2. parse url for url requests
3. no api slugs and what else?

## Yaks
1. Guard
2. monitoring
3. ci & deployment
4. ssl problem?
5. 404
6. rake run leaves zombie process
7. controllers

## Actual Ideas
1. Register callback actions on link shortening.

## Requirements

### Product Requirements

A client of this API should be able to create a shortened URL from a longer URLby sending an HTTP request.

As part of this HTTP request, the client may specify an optional "slug" string to use as the path portion of the shortened URL.

The response body should include some representation of the shortened URLalong with the original URL to which it will redirect.

### Project Requirements

The project should include an automated test suite.

The project should include a README file with instructions for running the web service and its tests. You should also use the README to provide context on choices made during development.

The project should be packaged as a compressed archive (e.g. a zip file).

Questions
1. do we not actually handle the redirection or a getting of the link?

## Topics for Discussion
1. scaffolding
2. if the shortener should be a gem included into my project.
3. Tooling & Project Setup
4. Where the redis client lives.
5. client.write / client.read
6. postman bundle?

## Notes

request:
{
  url:
  slug:
}

response:
{
  url:
  short_url:
}

routes:
GET / - api index
POST /shorten - create a link and return a response
GET /[slug]/pattern - resolve and redirect

https://github.com/Netflix/fast_jsonapi
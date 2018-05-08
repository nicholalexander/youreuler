# youreuler

A cutting edge state of the art URL shortener.  (And Elongator?)

## A Note On the Naming

A guy I met once pronounced URLs as "you're ul".  But with no real empty space between the two words.  And that was different.  It is only a happy accident that the name I picked also says Your Euler.  Which I wish I an Euler.

## Installation

`bundle install`

## Running the App

`rake run`

*nb, you will need a redis instance running locally.*

## Running the Test Suit, Rubocop, and Test Coverage Tools

`rake`

## Discussion


## TODO

2. parse url for api requests
1. custom errors
3. no api slugs and what else?

## Yaks
1. Guard
2. monitoring
3. ci & deployment
4. ssl problem?
5. 404
6. rake run leaves zombie process
7. controllers

## More fun Ideas
1. Register callback actions on link shortening.

## Requirements

### Product Requirements

A client of this API should be able to create a shortened URL from a longer URLby sending an HTTP request.

As part of this HTTP request, the client may specify an optional "slug" string to use as the path portion of the shortened URL.

The response body should include some representation of the shortened URLalong with the original URL to which it will redirect.



## Topics for Discussion
1. scaffolding
2. if the shortener should be a gem included into my project.
3. Tooling & Project Setup
4. Where the redis client lives.
5. client.write / client.read
6. postman bundle?

## Notes
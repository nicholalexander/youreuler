# youreuler

A cutting edge state of the art URL shortener.  (And Elongator.  Eventually.)

## A Note On the Naming

A guy I met once pronounced URLs as "you're ul".  But with no real empty space between the two words.  And that was different.  It is only a happy accident that the name I picked also says Your Euler.

## Installation

`bundle install`

## Running the App

`ruby server.rb`

*nb, you will need a redis instance running locally.*

## Running the Test Suit, Rubocop, and Test Coverage Tools

`rake`

## Deployment

This is a heroku app deployed at http://www.youreuler.com/

## Discussion

This was a fun project!

### Redis Client

I found one of the most interesting questions to be where the redis client lives.  If it is included in the UrlShortener or if the server knows about it.  I think there were two considerations, one: if the UrlShortener knows how to determine if it has a unique link or not so that other links are not overwritten.  Ultimately, I decided to let the UrlShortener know how to save and resolve it's links, so that gives it access to the redis client.

The other consideration was how the UrlShortener should be instantiated within the server.  In setting it up in the configure block, I think I've limited the number of connections that can be created against the client, but I need to do more research on how Sinatra handles each request and what that impact would be.  For now, I feel it's symantically in the right place.

### Server

The sinatra server is setup as a classic sinatra application.  The only slightly strange thing was using the lambda to handle the processing of the api request from the params.  I set it up this way so that I could handle posts to the api route with params but also get's, so you can get it from your browswer without setting anything up.  I know that's not standard, but I thought it'd be nice to be able to see it working without having to use Postman or curl.

### UrlShortener

Where most of the work gets done.  Aside from the server handling all the server things, all the logic for shortening the urls happens here.  I had considered packaging this as a gem and including it into the sinatra project that way - as that might have helped with some of the organization decisions of the project, but maybe next time.

There are three public methods, `payload_valid?`, `shorten`, and `resolve`.  `shorten` and `resolve` essentially map to the two main routes in the server.  

The big missing element here is error handling.  Next on my todo list would be building custom error classes with messages to surface in the server response so as to be more informative to the user.  Right now, errors are just raised and don't do anything very productive or communicative.

I also was thinking that I'd like to add a `enlengthen` method that does the opposite of `shorten`.  I was thinking that would be a good litmus test as to how flexible the code is and it feels like there would have to be a lot of changes to make that semantic and nice.

Lastly, if, based on the Redis/Sinatra research, it would make sense to instantiate a UrlShortener class for each request, I'd like to add a to_json method to make rendering the response work nicely with sinatra.

### Scaffolding and Tooling

I don't think I've ever not used a scaffold for a Sinatra application like this, but there was a lot of setup and tooling which was mostly fun.  I'm not sure I like not having an app folder, with the server in it, but this setup seemed easiest for the scope of what needed to be done.

## TODOs & Notes

1. custom errors - See discussion above.
2. no api slugs and what else - Maybe to prevent using the slug /api/.
3. match only the slug with no short code - So that you could have links of www.youreuler.com/blurgh instead of www.youreuler.com/blurgh/as34d3.  

### Yaks

1. guard - I wasn't happy with the server reloading and would like to fix.
2. monitoring - I've been wanting to play with Honeybadger
3. ci & deployment - I haven't seen that Heroku CI pipeline setup and would like to play with that.
4. ssl - Likewise, I haven't done SSL with Heroku.
5. rake run leaves zombie process - Not exactly sure what's up with this but would like to fix.

### More fun Ideas

1. Register callback actions on link shortening.
2. Enlengthen

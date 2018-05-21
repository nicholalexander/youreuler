# youreuler

A cutting edge state of the art URL shortener.  And Enlengthener.

## Installation

`bundle install`

## Running the App

`ruby server.rb`

*nb, you will need a redis instance running locally.*

## Running the Test Suit, Rubocop, and Test Coverage Tools

`rake`

## Deployment

This is a heroku app deployed at http://www.youreuler.com/

## TODOs & Notes

3. match only the slug with no short code - So that you could have links of www.youreuler.com/blurgh instead of www.youreuler.com/blurgh/as34d3.
4. remove newrelic

### Yaks

1. guard - I wasn't happy with the server reloading and would like to fix.
3. ci & deployment - I haven't seen that Heroku CI pipeline setup and would like to play with that.
4. ssl - Likewise, I haven't done SSL with Heroku.
5. rake run leaves zombie process - Not exactly sure what's up with this but would like to fix.
6. heroku staging env.

### More fun Ideas

1. Register callback actions on link shortening.
2. encrypt / sign url
3. apivore / swagger / rspec docs.

## A Note On the Naming

A guy I met once pronounced URLs as "you're ul".  But with no real empty space between the two words.  And that was different.  It is only a happy accident that the name I picked also says Your Euler.


----

{
  "original_url":"http://www.google.com",
  "properties": {
    "expires_after":{
      "resolutions": 3
    }
  }
}   

Sample request?

Time in UTC: DateTime.now.new_offset(0)


```json
{
  "original_url":"http://www.google.com",
  "properties": {
          "expires_after":{
            "resolutions": 3,
            "dateTime": "2018-05-15T16:40:42+00:00"  
            },
    
          "callback": {
            "url": "asdf",
            "body": "json-string"
          }
        }
}
```

what we put into redis:

```json
{
  "xxx-key-xxx": 
    {
      "redirect_url": "http://www.google.com",
      "properties": {
        "expires_after": "data",
        "callback":"data"
      }

}
```

for stakes - request

```json
{
  "original_url":"http://www.google.com",
  "properties": {
    "stake": {
      "value": 3
    },   
  }
}
```

```json
{
  "xxx-key-xxx": 
    {
      "redirect_url": "http://www.google.com",
      "properties": {
        "stake": {
          "value": 3,
          "resolved": false,
          "completed": false
        }
      }
    }
}
```

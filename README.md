# README
 
# URL shortening service :sunny:
 
- Rails API mode service.
 
## Getting Started
 
1. Clone the repository
2. Install dependencies and run `bundle install`
4. Start the server with `rails s`
 
## Dependencies
 
- Ruby 2.7.2
- MongoDB 6.0.0
 
## Requriments
- The end-user provides the service with a valid URL, the service should generate a shorter and unique alias for it
- I assumed the short link should not be more than 10 chars and hard and not predictable.
- When users access the short generated link that is provided by the service, the service should redirect them to the original link.
- The service should provide 2 endpoints the first one to generate the short link and the other endpoint for redirection.
## Database
* When creating the data model, I found that we don't need many relations between our models, in this case, we don't need relational DB and a NoSQL database like MongoDB can be used.
- Currently, we have one document that store the Orignal link and the Short-id.
- If we decided to add a user model if it will have one-to-many relation to the Url document which is easy to manage.
- Url docuemnt will be read heavy, that's why an index has been added on the short_id attribute.
 
## Development
1. ``Authentication``
- The service is currently public (for simplicty) but for future developmet API key might be added if we don't require the user to be authenticated.
- If we added a User model, then we can introduce a JWT token for each user.
2.``Genrating short links``
- Encode the original Url 
  - One solution is to encode the original Url, using any hashing  algorithm (MD5), but that will lead to a long url and if we cut some characters from the encoded hash, we might have a duplication in our generated short URLs.
- Generate a secure URL-friendly unique string(NanoId).
This is the solution that I used to map the original URLs to a short link.
- The idea is to have a unique generated string per each URL and avoid the duplication as possible.
- The current mechanism has less collision probability, but it's still a valid issue in this solution I handled the collision once per each request, it's not ideal but the main Idea is to regenerate the NanoId whenever we have the same key assigned to another URL.
The disadvantage of that solution is we will need to regenerate the id every time we got a collision which affects the performance of the service in the long term.
- One way to fix this problem is to have pre-generated keys stored in another document and every time we use one of those keys we mark it as used.
 
3. ``JSON Responses``
- it's a good practice to follow [JSON API specification]
so any consumer can expect how the results will look like while the development of the APIs is happening.
- `fast_jsonapi` or `active_model_serializers` can be added to the service.
 
 
## Running the tests
 
```shell
# Rspec
 rspec
```
## Usage
```shell
1. Generate a short Url
 
- POST: `http://localhost:3000/api/v1/urls`
- Format `JSON`
- Params: required
 - `original_url` : `https://www.google.com/`
 
- Response
 - Status code: `201`
 - `` {"short_url": "localhost:3000/CRlJZLtxUI"}``
- Errors
 - Status code: `[422]`
 -  ``{ "errors": "The following errors were found: Original Url can not be empty }``
1. Access a short url
 
- Get: `http://localhost:3000/short_id`
 
- Response: the service will redirect the client to the original URL
 - Status code: `302`
 - Header: "location": `original_url`
```shell

# README
 
# URL shortening service :sunny:
 
- This service is a built using Rails in API mode. It's designed to provide quick and reliable URL shortening functionality, transforming lengthy URLs into shorter ones.

 
## Getting Started
 
1. Clone the repository
2. Install dependencies and run `bundle install`
4. Start the server with `rails s`
 
## Dependencies
 
- Ruby 3.2.2
- MongoDB 6.0.0
- Rails 7.1.3.2
 
## Requriments
- Users can submit a valid URL to generate a shorter and unique alias.
- Short links are no more than 10 characters, hard to guess, and non-sequential.
- Accessing the short link redirects users to the original URL.
- Provides two endpoints: one for generating the short link and another for redirection.
## Database

MongoDB, a NoSQL database, is used due to its flexibility and scalability, suitable for the service's non-relational data model.

- **ShortenedUrl Document**: Stores the original link and its corresponding short ID.
- **Indexing**: An index on the `short_id` attribute optimizes read operations, enhancing the service's performance for redirection.
- **Future Considerations**: Adding user authentication could introduce a User model with a one-to-many relationship to the Url document.
 
## Development
1. **Authentication** (Planned)
   - API key-based access for public endpoints.
   - JWT authentication for user-specific operations.

2. **Generating Short Links**
   - Utilizes NanoId to generate secure, URL-friendly unique strings, minimizing collision probability.
   - Handles collision by regenerating the NanoId, with considerations for optimizing performance through pre-generated keys.

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

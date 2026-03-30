# Tito Ruby

A Ruby client for the [Tito](https://ti.to) Admin API v3.

**WARNING:** This is a very early release, and I'm only using a small portion of it, so although we have automated tests, most of them are not backed up by real-world experience.

## Installation

Add to your Gemfile:

```ruby
gem "tito_ruby"
```

Or install directly:

```
gem install tito_ruby
```

## Configuration

```ruby
Tito.configure do |config|
  config.token   = "your_api_token"
  config.account = "your_account_slug"
end
```

Or pass credentials directly to the client:

```ruby
client = Tito::Admin::Client.new(token: "your_api_token", account: "your_account_slug")
```

## Usage

### Events

```ruby
client = Tito::Admin::Client.new

# List events
client.events.each { |event| puts event.title }

# Find a specific event
event = client.events.find("my-event-slug")

# Past and archived events
client.past_events.each { |e| puts e.title }
client.archived_events.each { |e| puts e.title }
```

### Tickets

```ruby
client = Tito::Admin::Client.new(event: "my-event")

# List tickets
client.tickets.each { |ticket| puts ticket.reference }

# Search and filter
client.tickets.search("john").each { |t| puts t.reference }

# Pagination
client.tickets.page(2).per(50).each { |t| puts t.reference }
```

### Registrations

```ruby
client.registrations.each { |reg| puts reg.name }
```

### Releases

```ruby
client.releases.each { |release| puts release.title }
```

### Discount Codes

```ruby
client.discount_codes.each { |code| puts code.code }
```

### Query Builder

All collections support a chainable query interface:

```ruby
client.tickets
  .where(state: "complete")
  .order("created_at_desc")
  .expand("registration", "release")
  .page(1)
  .per(25)
  .each { |t| puts t.reference }
```

### Resource Status

| Resource | List | Find | Create | Update | Delete | Notes |
|----------|------|------|--------|--------|--------|-------|
| Events | :white_check_mark: | :white_check_mark: | :grey_question: | :grey_question: | :grey_question: | Account-scoped |
| Releases | :white_check_mark: | :white_check_mark: | :white_check_mark: | :grey_question: | :white_check_mark: | |
| Tickets | :white_check_mark: | :white_check_mark: | :grey_question: | :grey_question: | N/A | |
| Registrations | :white_check_mark: | :white_check_mark: | :grey_question: | :grey_question: | N/A | |
| Questions | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | |
| Answers | :grey_question: | :grey_question: | N/A | N/A | N/A | Nested under Questions |
| Discount Codes | :white_check_mark: | :grey_question: | :white_check_mark: | :grey_question: | :white_check_mark: | |
| Activities | :white_check_mark: | :grey_question: | :white_check_mark: | :grey_question: | :white_check_mark: | |
| Checkin Lists | :x: | :grey_question: | :white_check_mark: | :grey_question: | :white_check_mark: | List broken by Tito API bug |
| Opt-Ins | :white_check_mark: | :grey_question: | :white_check_mark: | :grey_question: | :white_check_mark: | |
| Interested Users | :white_check_mark: | :grey_question: | :white_check_mark: | :grey_question: | :white_check_mark: | |
| RSVP Lists | :white_check_mark: | :grey_question: | :white_check_mark: | :grey_question: | :white_check_mark: | |
| Release Invitations | :white_check_mark: | :grey_question: | :grey_question: | :grey_question: | :grey_question: | Nested under RSVP Lists |
| Webhook Endpoints | :white_check_mark: | :grey_question: | :white_check_mark: | :grey_question: | :white_check_mark: | Event-scoped |
| Waitlisted People | :white_check_mark: | :grey_question: | :grey_question: | :grey_question: | :grey_question: | |
| Refunds | :grey_question: | :grey_question: | N/A | N/A | N/A | Nested under Registrations |
| Venues | :white_check_mark: | :grey_question: | :grey_question: | :grey_question: | :grey_question: | |

:white_check_mark: = tested against live API&ensp; :grey_question: = implemented but untested&ensp; :x: = known broken

## Logging

In a Rails app, request logging is enabled automatically via `Rails.logger`. You'll see output like:

```
request: GET https://api.tito.io/v3/letterblock/test-event-1/tickets?page%5Bnumber%5D=1
response: Status 200
```

Outside of Rails, set a logger manually:

```ruby
Tito.logger = Logger.new(STDOUT)
```

Or via the configure block:

```ruby
Tito.configure do |config|
  config.logger = Logger.new(STDOUT)
end
```

This uses Faraday's built-in logger middleware, omitting headers and bodies. Set `Tito.logger = nil` to disable.

Note: the logger is captured when the first request is made on a client. If you set `Tito.logger` after a client has already been used, create a new client for it to take effect.

## Development

```
bundle install
bundle exec rake test
```

## License

MIT License. See [LICENSE.txt](LICENSE.txt).

# Tito Ruby

A Ruby client for the [Tito](https://ti.to) Admin API v3.

**WARNING:** This is pre-release, mostly-Claude-code-generated, mostly-untested software. It mostly doesn't work at all. Only the Tickets resource is known even to successfully load data. Use at your own risk.

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

### Available Resources

- Events, Releases, Tickets, Registrations
- Activities, Questions, Answers
- Discount Codes, Checkin Lists
- Opt-Ins, Interested Users, RSVP Lists
- Release Invitations, Waitlisted People
- Webhook Endpoints, Refunds, Venues

## Development

```
bundle install
bundle exec rake test
```

## License

MIT License. See [LICENSE.txt](LICENSE.txt).

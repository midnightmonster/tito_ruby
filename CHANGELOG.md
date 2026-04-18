# Changelog

## 0.4.0 (Unreleased)

- Fixed Resource to declare expandable fields as JSON attributes so expanded data can be read
- Fixed QueryBuilder freeform search param (now `search[q]` instead of `q`)
- Ticket resource exposes expandable `activities_ids` and `answer_ids`

## 0.3.0

- Added request logging via Faraday's built-in logger middleware
- Added `Tito.logger` / `Tito.logger=` for easy logger configuration
- Added Rails Railtie that auto-sets `Tito.logger = Rails.logger`
- Fixed QueryBuilder array params adding an extra `[]` suffix (e.g. `where(state: ["complete"])` now sends correctly)

## 0.2.0

- Updated all resource definitions to match actual Tito API v3 responses
- Fixed Resource to silently drop unknown attributes from API responses instead of crashing
- Fixed WebhookEndpoint: changed from account-scoped to event-scoped to match API
- Added VCR integration tests covering list, find, create, and delete for most resources
- Fixed field types: Event.metadata, Release.metadata, Registration.metadata now `:json`; Question.options now `:json` (array); Ticket.event now `:json` (object)
- Added many missing fields to Event, Release, Registration, Discount Code, Question, Activity, and Release Invitation resources
- Removed fields not present in API responses (e.g. Activity.show_to_attendee)

## 0.1.0

**WARNING:** This is pre-release, mostly-Claude-code-generated, mostly-untested software. It mostly doesn't work at all. Only the Tickets resource is known even to successfully load data. Use at your own risk.

- Initial release
- Admin API client with token-based authentication
- Support for 18 resource types: Events, Releases, Tickets, Registrations, Activities, Questions, Answers, Discount Codes, Checkin Lists, Opt-Ins, Interested Users, RSVP Lists, Release Invitations, Waitlisted People, Webhook Endpoints, Refunds, Venues
- Chainable query builder with search, filtering, ordering, pagination, and field expansion
- ActiveModel-backed resources with dirty tracking
- Lazy-loaded, paginated collections

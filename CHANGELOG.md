# Changelog

## 0.2.0 (Unreleased)

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

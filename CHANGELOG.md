# Changelog

## 0.1.0 (Unreleased)

**WARNING:** This is pre-release, mostly-Claude-code-generated, mostly-untested software. It mostly doesn't work at all. Only the Tickets resource is known even to successfully load data. Use at your own risk.

- Initial release
- Admin API client with token-based authentication
- Support for 18 resource types: Events, Releases, Tickets, Registrations, Activities, Questions, Answers, Discount Codes, Checkin Lists, Opt-Ins, Interested Users, RSVP Lists, Release Invitations, Waitlisted People, Webhook Endpoints, Refunds, Venues
- Chainable query builder with search, filtering, ordering, pagination, and field expansion
- ActiveModel-backed resources with dirty tracking
- Lazy-loaded, paginated collections

# RailsGuides Readings - API Layer

Read all sections unless otherwise specified:

## Routing

[RailsGuides: Routing][rails-guides-routing]


* Skip 2.6 Controller Namespaces and Routing.
* Skip 2.8 Routing Concerns
* Skip 2.9 Creating Paths and URLs From Objects
* Read 2.10
* In Section 3 Non-Resourceful Routes, remember to never use `match`.
* Never use `:controller/:action`; always use `=>
  "controller#action".
* Skip 3.8 Segment Constraints, 3.9 Request-Based Constraints,
  3.10 Advanced Constraints, 3.11 Route Globbing.
* Skip 3.13 Routing to Rack Applications.
* Skip all of Section 4 Customizing Resourceful Routes except:
    * 4.6 Restricting the Routes Created
* Skip 5.2 Testing Routes.

## Action Controller

[RailsGuides: Action Controller][rails-guides-action-controller]

* Skip 4.4 default_url_options
* In 4.5 Strong Parameters, avoid the use of `permit!`
* In Section 5 Session, ignore setting different session stores
* Skip Section 11 HTTP Authentications
* Skip Section 12 Streaming and File Downloads
* Skip Section 13 Log Filtering

## Layouts and Rendering

[RailsGuides: Layouts and Rendering][rails-guides-layouts]

* Skip 2.2.4 Rendering an Arbitrary File
* Skip 2.2.6 Using render with :inline
* Skip 2.2.9 Rendering XML and 2.2.10 Rendering Vanilla JavaScript
* Skip 2.2.12 Finding Layouts
* Skip 2.4 Using head To Build Header-Only Responses
* Skip 3.1 Asset Tag Helpers
* Skip 3.5 Using Nested Layouts

[rails-guides-routing]: http://guides.rubyonrails.org/routing.html
[rails-guides-action-controller]: http://guides.rubyonrails.org/action_controller_overview.html
[rails-guides-layouts]: http://guides.rubyonrails.org/layouts_and_rendering.html

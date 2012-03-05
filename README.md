Copycopter
==========

Copycopter is a service for storing the static copy text of an application in a
managed database, editable both by developers and clients.

Each application has its own Project. Each individual piece of copy text in a
Project is represented by a Blurb. Each Blurb has many Versions, which track
changes users make to copy text.

Each Version is either draft or published. The intention is to display
published content in production, and draft in all other environments. A
developer can issue a deploy, which marks the latest Version of all Blurbs as
published.

Setup
-----

The following assumes `bake` as an alias for `bundle exec rake`.

    bundle
    bake setup

Development
-----------

Run the test suite:

    bake

Run the server:

    foreman start

Automatically regenerate CSS when you edit Sass files:

    sass --watch public/stylesheets/sass:public/stylesheets \
      -r public/stylesheets/sass/bourbon/lib/bourbon.rb


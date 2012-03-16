Copycopter
==========

Copycopter is a service for editing the copy text of a Rails application.

Each Rails application has its own Project, connected by an API key.
Each piece of copy in a Project is a Blurb. Each Blurb has many Versions, which
track changes users make to copy.

Each Version is either draft or published. The most typical scenario is to
display published content in production, and draft in all other environments.

A developer can issue a deploy, which marks the latest Version of all Blurbs as
published.

Setup
-----

    git clone git@github.com:copycopter/copycopter-server.git
    cd copycopter-server
    bundle
    bundle exec rake setup

Development
-----------

Run the test suite:

    bundle exec rake

Run the server:

    foreman start

Automatically regenerate CSS when you edit Sass files:

    sass --watch public/stylesheets/sass:public/stylesheets \
      -r ./public/stylesheets/sass/bourbon/lib/bourbon.rb

Contributing
------------

See the [style guide](https://github.com/copycopter/style-guide).

Credits
-------

![thoughtbot](http://thoughtbot.com/images/tm/logo.png)

Copycopter Server was created by [thoughtbot, inc](http://thoughtbot.com)

It is maintained by the fine folks at [Crowdtap](http://crowdtap.com) and
[Iora Health](http://iorahealth.com).

License
-------

Copycopter Server is free software, and may be redistributed under the terms
specified in the MIT-LICENSE file.

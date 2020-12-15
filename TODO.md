# The Almighty TODO List

This file contains ideas for future functionality. For open issues and tasks
under development, see the [CV-1.0 Development Project] (link to follow) in
GitHub.

## Before v1.0.0 release

* Cleanup unused images, CSS, JS (Jason)
* Add `/heath` path to CV.pm

## Immediately after push to github

* Add a "CV-1.0 Development" project and paste the link to this file (first
paragraph above).
* Add an issue -- Add support for Google Analytics tracking code (add to config_local.yml, load in CV.pm and include into index.tt)
* Add issues from cromedome project <https://github.com/cromedome/CollectiveVoice/projects/1>
  * Disable reviews once a feedback form has been submitted (idea being that we don't want user to be able to rate us publicly if they've provided feedback)


========

## New Features

* Make a11y-friendly
* Add support for Audio and Video testimonials


## Testing

* Create a Perl Critic test with Test::Perl::Critic <https://metacpan.org/pod/Test::Perl::Critic>
* Add email testing support - see https://metacpan.org/source/GSG/Email-SendGrid-V3-v0.900.1/t/send.t
* Test with Firefox::Marionette <https://metacpan.org/pod/Firefox::Marionette>


## Deployment

* Dockerize
* Add support for HealthCheck - https://grantstreetgroup.github.io/HealthCheck.html

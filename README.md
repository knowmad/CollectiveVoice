# Collective Voice (or, CV for short)

Collective Voice helps companies generate online reviews.

## Background

The growth of the web has empowered customers to have greater power than ever.
Buyers often turn to customer testimonials and reviews to determine whether or
not they trust a product, service, and even a seller. In fact, surveys show that
buyers read [seven reviews on
average](https://www.brightlocal.com/research/local-consumer-review-survey/#Q17)
before deciding to trust a business.

But, getting reviews can be challenging. How do you make it easy for happy
clients to leave reviews? And, when soliciting reviews from your customers, how
do you prevent unhappy clients from leaving negative reviews? A testimonial
review portal can benefit.


## Example Sites

* [Knowmad Digital Marketing](https://review.knowmad.com)


## Quick Start

If you have a modern Perl already installed, you can get started with the steps
below (detail instructions follow):

1. run `carton install`
2. edit `environments/shell-env`
3. start the app with `./bin/cvlauncher console`


## Setting Up the Application

As always in Perl, TIMTOWTDI! You can either use your system Perl,
install a new version just for this project via Perlbrew or plenv, or,
use an existing Perl and install the app dependencies via Carton.

The remainder of this section expects that you are using Carton and
plenv. If you are not, the dependencies you need are listed in the
`cpanfile`.

From the root of the project, run `carton install`. Use the modifier
`--deployment` when deploying the application to a server. This command
will install copies of all the project dependencies in a subdirectory
under the project root. This will take a while, so go grab a coffee or
a pint :)

When that's finished, edit `environments/shell-env` (or create a localized
version at `environments/shell-env-local`). These files are used by `cvlauncher`
and `cvdeploy`. As a matter of good practice, whenever you open a new shell to
work on this project, source this file (e.g., `source environments/shell-env`).
This will add the local library and bin directories to your operating environment.


## Running the Application in development

It's always a good practice to develop with multiple server processes -
some problems just don't happen in a single process environment, so this
will simulate some issues you might see in production. To make it easy
to start a development server, there's a helper script to start one.
Just run `./bin/cvlauncher console` from the root Collective Voice directory
and within a moment you will have a development server.

The development server has a hamburger menu in the upper right hand
corner. You may click on it to get detailed information as to what is
going on with your Application. You can also look at the console log, or
the `collective-voice.log` file in the `logs/` directory.

If you need to run the Perl debugger on your application, run the
development server in single-process mode using the `./bin/cvlauncher debug`
script.

## Config.yml Files

The primary config file is `config.yml`. It contains global settings for the
app. A localized version of this file which contains site specific details is
included as `config_local.yaml`.

These files can contain the following settings:

* Company information - name, url, email, brand color
* review_sites: list of review sites with the preferred site being first
* logos: review site logos to display (more info below)
* ratings: labels/descriptions for 1-5 stars
* sendgrid: Sendgrid credentials for email delivery


## Deploying/Running the Application in production

Configuration information that is not likely to change can be found
in `environments/shell-env`. Every convenience script in `bin/` will
source this file, along with any local overrides you may have. Local
overrides can be found in `environments/shell-env-local`:

* `$CV_ROOT` - the directory where you have cloned the application.

* `$CV_DEPLOY_HOST` - Host you will deploy the site to.

* `$CV_DEPLOY_DIR` - Parent directory on the server that Collective
  Voice will be deployed to.

* `$SS_WORKERS` - How many worker processes to start. The busier the
  site, the higher this should be.

* `$SS_USER` - user the script will run under (typically, the web server
  user)

* `$SS_GROUP` - group the script will run under (typically, the web
  server user)

Once these are set, you can use `./bin/cvdeploy` to rsync the
application to the target server. If you are deploying *from* a macOS
box, make sure you install the `rsync` port from Homebrew.

You can run the application on the server with `./bin/cvlauncher start` or,
if using the systemd service script, `./bin/cvlauncher systemd`.

The systemd unit file available in `bin/collectivevoice.service` which can
used on Debian and related systems. For usage examples, see the README-Linode.txt.


## Testing the Application

`carton exec prove -lr t/`

`carton exec prove -lr t/frontend/*`

### Logging errors

By default, CV is setup to use log4perl in the development.yml config file (in
environments directory). When debugging, you can use the following to log
messages to the selected logging library:

`error $message;`


## Logos

Any logo images need to be reviewed for copyright.

Logo images should be textual logos, PNG formats and sized to 250px x 100px for
consistent layout. Try https://commons.wikimedia.org for copyright-free media
files.

Logos can be set in config.yml or as part of the review_sites hash.


## Resources

Links to more information about Tailwind and AlpineJS:

* https://codewithhugo.com/alpinejs-x-data-fetching/
* https://tailwindcss.com/docs/align-content
* https://dev.to/nugetchar/starting-with-alpinejs-hjn
* https://github.com/alpinejs/alpine#watch
* https://tailwindcss.com/docs/installation/#webpack
* https://www.alptail.com (modal and star ratings)


## Enjoy

Happy hacking! -WM

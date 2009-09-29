#!/bin/bash

SITE_HOME=/usr/local/site/bokukoyo/current
RUBY=/usr/local/bin/ruby

RAILS_ENV=production $RUBY $SITE_HOME/script/runner 'Mailer.receive(STDIN.read)'
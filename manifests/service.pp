# == Class: amazon_ses::service
#
# Manages the postfix service
#
# === Parameters
#
# === Variables
#
# === Authors
#
# Michael Speth <spethm@landcareresearch.co.nz>
#
# === Copyright
# GPLv3
#
class amazon_ses::service {
  service { 'postfix':
    ensure => running,
  }
}
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
# Robin Bowes <robin.bowes@yo61.com>
#
# === Copyright
# GPLv3
#
class amazon_ses::service {
  service { 'postfix':
    ensure => running,
    enable => true,
  }
}
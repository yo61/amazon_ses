# == Class: amazon_ses::install
#
# Installs postfix
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
class amazon_ses::install {

  include ::amazon_ses::params
  package { $::amazon_ses::params::package_names:
      ensure => installed,
  }
}

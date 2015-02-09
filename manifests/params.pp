# == Class: amazon_ses::params
#
# Sets OS-specific values
#
# === Parameters
#
# === Variables
#
# === Authors
#
# Robin Bowes <robin.bowes@yo61.com>
#
# === Copyright
# GPLv3
#
class amazon_ses::params{

  $package_names = $::osfamily ? {
    'debian' => ['postfix', 'libsasl2-modules'],
    default  => 'postfix',
  }

}
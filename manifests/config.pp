# == Class: amazon_ses::config
#
# Manages the configuration files for postfix.
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
class amazon_ses::config {
  
  # setup passwords
  # note, its best practice to delete this file
  # however, it needs to exist in order for puppet
  # to work correctly with generating the db file
  # also, if the password changes, creating the db file is notified.
  # So the solution for now is to restrict the permissions.
  file { '/etc/postfix/sasl_passwd':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('amazon_ses/sasl_passwd.erb') 
  }
  
  # create the db
  exec { 'create_db_file':
    command       => '/usr/sbin/postmap -r hash:/etc/postfix/sasl_passwd',
    cwd           => '/etc/postfix',
    refreshonly   => true,
    subscribe     => File['/etc/postfix/sasl_passwd'],
  }

  # manage the postfix main configuration file 
  file {'/etc/postfix/main.cf':
    ensure  => file,
    content => template('amazon_ses/main.cf.erb'),
    require => Exec['create_db_file'],
  }
}
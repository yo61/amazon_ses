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

  $default_ses_region = 'US EAST'

  $default_smtp_port = 587

  $default_smtp_tls_ca_file = $::osfamily ? {
    'debian' => '/etc/ssl/certs/ca-certificates.crt',
    default  => '/etc/pki/tls/cert.pem',
  }

  $default_smtpd_tls_cert_file = $::osfamily ? {
    'debian' => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
    default  => '/etc/pki/tls/certs/localhost.crt',
  }

  $default_smtpd_tls_key_file = $::osfamily ? {
    'debian' => '/etc/ssl/private/ssl-cert-snakeoil.key',
    default  => '/etc/pki/tls/private/localhost.key',
  }

  $package_names = $::osfamily ? {
    'debian' => ['postfix', 'libsasl2-modules'],
    default  => ['postfix', 'cyrus-sasl-plain'],
  }

}

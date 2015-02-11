# == Class: amazon_ses
#
# Manages postfix to fuly integrate with Amazon SES.
#
# === Parameters
#
# Document parameters here.
#
# [*domain*]
#   The domain of your web site.  In order to send email through SES servers, 
#   your domain must be verified.
#   SES Management Console -> Domains -> Verify a New Domain
#   See http://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-domains.html
#   for additional details
#
# [*smtp_username*] 
#   The username of the smtp user.  Note, this is not your IAM user.
#   You need to create a unique user for the SES service.
#   The new user can be created via:
#   SES -> smtp settings -> 'Create My SMTP Credentials' button.
#
# [*smtp_password*]
#   The password of the smtp user.
#
# [*inet_interfaces*]
#   The interfaces to which postfix should bind
#   Default: 'all'
#
# [*inet_protocols*]
#   The protocols postfix should use. 'ipv4', 'ipv6', 'all'
#   Default: 'all'
#
# [*ses_region*]
#   The region of the Amazon smtp server to relay to.  Valid options:
#   * 'US EAST'      - N. Virginia (us-east-1)
#   * 'US WEST'      - Oregon (us-west-2)
#   * 'EU'           - Ireland (eu-west-1)
#   * 'us-east-1'    - uses 'US EAST'
#   * 'us-west-1'    - uses 'US WEST'
#   * 'us-west-2'    - uses 'US WEST'
#   * 'eu-west-1'    - uses 'EU'
#   * 'eu-central-1' - uses 'EU'
#   The default region is 'US EAST'
#
# [*smtp_port*]
#   The port used to connect to the Amazon SMTP server.
#   The default is 587 as there are no limits. If you use port 25, than you will
#   need to request that Amazon disables the rate limit (which is 1 email
#   per minute).
#
# [*smtp_tls_ca_file*]
#   A file containing CA certificates of root CAs trusted to sign either
#   remote SMTP server certificates or intermediate CA certificates.
#   If not specified the OS default location is used.
#
# [*smtpd_tls_cert_file*]
#   File with the Postfix SMTP server RSA certificate in PEM format. This
#   file may also contain the Postfix SMTP server pri vate RSA key.
#   If not specified the OS default location is used.
#
# [*smtpd_tls_key_file*]
#   File with the Postfix SMTP server RSA private key in PEM format. This
#   file may be combined with the Postfix SMTP server RSA certificate file
#   specified with $smtpd_tls_cert_file. The private key must be accessible
#   without a pass-phrase, i.e. it must not be encrypted.
#   If not specified the OS default location is used.
#
# === Variables
#
# [*region_url*] 
#   The full url based on the region for the SES smtp server
#
# [*region_url2*]
#   Through my testing, postfix would not authenticate without an additional
#   hash in the password file. The docs here specify this 2nd url:
#   http://docs.aws.amazon.com/ses/latest/DeveloperGuide/smtp-issues.html
#
# === Examples
#
#   # Sets up SES for the US EAST region
#   class { 'amazon_ses':
#     domain        => 'test.com', 
#     smtp_username => 'USERNAME',
#     smtp_password => 'PASSWORD',
#   }
#
#   # Sets up SES for the EU region
#   class { 'amazon_ses':
#     domain        => 'test.com', 
#     smtp_username => 'USERNAME',
#     smtp_password => 'PASSWORD',
#     ses_region    => 'EU',
#   }
#
# === Authors
#
# Michael Speth <spethm@landcareresearch.co.nz>
# Robin Bowes <robin.bowes@yo61.com>
#
# === Copyright
# GPLv3
#
class amazon_ses (
  $domain,
  $smtp_username,
  $smtp_password,
  $inet_interfaces = $::amazon_ses::params::default_inet_interfaces,
  $inet_protocols = $::amazon_ses::params::default_inet_protocols,
  $ses_region = $::amazon_ses::params::default_ses_region,
  $smtp_port = $::amazon_ses::params::default_smtp_port,
  $smtp_tls_ca_file = $::amazon_ses::params::default_smtp_tls_ca_file,
  $smtpd_tls_cert_file = $::amazon_ses::params::default_smtpd_tls_cert_file,
  $smtpd_tls_key_file = $::amazon_ses::params::default_smtpd_tls_key_file,
) inherits ::amazon_ses::params {

  anchor { 'amazon_ses::begin': }

  # check for OS Family
  case $::osfamily {
    'debian', 'fedora', 'redhat': {
      # debian (so ubuntu and debian are only supported)
      # we also support RedHat/CentOS and Fedora
    }
    default: {
      fail("${::osfamily} - Unsupported OS Family")
    }
  }

  # Maps the real AWS regions to the SES service regions
  # Previously-used keys added for backwards compatibility
  $ses_region_map = {
    'us-east-1'    => 'us_east',
    'us-west-1'    => 'us_west',
    'us-west-2'    => 'us_west',
    'eu-west-1'    => 'eu',
    'eu-central-1' => 'eu',
    'US EAST'      => 'us_east',
    'US WEST'      => 'us_west',
    'EU'           => 'eu',
  }

  # Data for SES service by region
  $ses_data = {
    us_east => {
      region_url  => "email-smtp.us-east-1.amazonaws.com:${smtp_port}",
      region_url2 => "ses-smtp-prod-335357831.us-east-1.elb.amazonaws.com:${smtp_port}",
    },
    us_west => {
      region_url  => "email-smtp.us-west-2.amazonaws.com:${smtp_port}",
      region_url2 => "ses-smtp-us-west-2-prod-14896026.us-west-2.elb.amazonaws.com:${smtp_port}",
    },
    eu => {
      region_url  => "email-smtp.eu-west-1.amazonaws.com:${smtp_port}",
      region_url2 => "ses-smtp-eu-west-1-prod-345515633.eu-west-1.elb.amazonaws.com:${smtp_port}",
    },
  }

  if has_key($ses_region_map, $ses_region) {
    $region_url = $ses_data[$ses_region_map[$ses_region]][region_url]
    $region_url2 = $ses_data[$ses_region_map[$ses_region]][region_url2]
  }
  else {
    fail("${ses_region} - Invalid ses_region")
  }

  class {'amazon_ses::install':
    require => Anchor['amazon_ses::begin'],
  }
  class {'amazon_ses::config':
    require => Class['amazon_ses::install'],
  }
  class {'amazon_ses::service':
    subscribe => Class['amazon_ses::config'],
  }
  anchor { 'amazon_ses::end':
    require => Class['amazon_ses::service']
  }
}

# amazon_ses

[![Puppet Forge](http://img.shields.io/puppetforge/v/conzar/amazon_ses.svg)](https://forge.puppetlabs.com/conzar/amazon_ses)
[![Build Status](https://travis-ci.org/Conzar/amazon_ses.svg?branch=master)](https://travis-ci.org/Conzar/amazon_ses)

## Overview

Configures and sets up postfix to integrate with Amazon Simple Email Service (Amazon SES).

## Module Description

The module installs postfix and configures it to relay smtp to the Amazon SES smtp server.  
It uses the self-signed certs for TLS authentication with Amazon SES.  By default it connects to 
port 587 as this port does not have any restrictions.  Port 25 by default limits 1 email per minute,
if you choose port 25, make sure you apply for that restriction to be removed from your domain.

The intention of this module is to reduce the startup and configuration time of integration with
Amazon SES and to avoid simple postfix configuration errors.  

The current release is supported for debian based systems with Ubuntu as the tested platform.  
Contributions are welcome for Redhat based systems.

## Setup

### What amazon_ses affects

* /etc/postfix/main.cf
* /etc/postfix/sasl_passwd
* /etc/postfix/sasl_passwd.db

### Setup Requirements 

In order to use Amazon SES, you must login to your Amazon account and do the following.

#### Register for Amazon SES
Go to the following link and sign up. 
([sign-up-for-aws](http://docs.aws.amazon.com/ses/latest/DeveloperGuide/sign-up-for-aws.html))

#### Create a SMTP user
Create a SMTP user which is separate from your existing IAM users.
The new user can be created via:

    SES -> smtp settings -> 'Create My SMTP Credentials' button.

Take note of the username and password which will used by this module.

#### Verify Email Addresses
In order to test this module (once installed on your amazon ec2 instance),
verify at least one email address that will be the recipient of your testing.
([verify-email-addresses](http://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-email-addresses.html))

#### Verify Domain
In order to test this module (once installed), verify the domain that emails
will be sent from.  Amazon's SMTP servers will reject emails from unverified domains.
So this is a very important step in order to start testing Amazon SES.  See the following guide: 
([verify-domains](http://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-domains.html))

#### Amazon SES Production Access
Your Amazon SES instance is by default setup in a sandbox.  Once a domain and emails 
have been verified, you can start sending emails (only to the verified addresses).  This obviously
is limiting and only useful in a testing environment.  Once you are ready to move to production,
you need to apply for production level access which has no restriction on recipient addresses.

Follow this guide to apply for production access:
([request-production-access](http://docs.aws.amazon.com/ses/latest/DeveloperGuide/request-production-access.html))

### Beginning with amazon_ses

To install postfix with Amazon SES configuration with the default parameters.

```puppet
	class { 'amazon_ses':
  		domain => 'test.com',
  		smtp_username => 'USERNAME',
  		smtp_password => 'PASSWORD',
	}
```


## Usage

###Classes and Defined Types

This module modifies the postfix configuration files and replaces the main configuration file.

####Class: `amazon_ses`

The amazon_ses module's primary class, `amazon_ses`, guides the basic setup of postfix on your system enabled for Amazon SES.

**Parameters within `amazon_ses`:**

#####`domain`
   The domain of your web site.  In order to send email through SES servers, your domain must be verified.
   SES Management Console -> Domains -> Verify a New Domain
   See [verify-domain](http://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-domains.html) for additional details.

#####`smtp_port`
   The port used to connect to the Amazon SMTP server.  The default is 587 as there are no limits.
   If you use port 25, than you will need to request that Amazon disables the rate limit (which is 1 email per minute).

#####`smtp_username`
   The username of the smtp user.  Note, this is not your IAM user.  You need to create a unique
   user for the SES service.  The new user can be created via:

    SES -> smtp settings -> 'Create My SMTP Credentials' button.

#####`smtp_password`
   The password of the smtp user.

#####`ses_region`
   The region of the Amazon smtp server to relay to.  Amazon only offers [3 regions](http://docs.aws.amazon.com/ses/latest/DeveloperGuide/regions.html) with 1 availability zone each.

   Valid options:
   
| Puppet Option | Region Name | Region |
| ------------- | ----------- | ------ |
| `US EAST`     | N. Virginia | us-east-1 
| `US WEST`     | Oregon      | us-west-2 
| `EU`          | Ireland     | eu-west-1 

	The default region is `US EAST`

 * `US EAST` - The (N. Virginia) Region - us-east-1
 * `US WEST` - The (Oregon) Region - us-west-2
 * `EU` - The (Ireland) Region - eu-west-1
 * The default region is 'US EAST'

## Limitations

Only works with debian based OS's.

## Development

The module is open source and available on github.  Please fork!
#
# == Define: freight::config
#
# Configure an instance of freight
#
# [*varcache*]
#   The directory from which freight-managed packages are served.
# [*gpg_key_id*]
#   The ID of the key to install. For example 'D50582E6'. The private and public
#   keys need to be on the Puppet fileserver and accessible at these URIs:
#
#   "puppet:///files/${gpg_key_id}-private.key"
#
#   "puppet:///files/${gpg_key_id}-public.key"
#
#   Defaults to $::freight::default_gpg_key_id.
#
# [*gpg_key_email*]
#   Email address of the package signing key - check with "gpg --list-keys". No
#   default value. Defaults to $::freight::default_gpg_key_email.
# [*gpg_key_passphrase*]
#   The passphrase of the GPG keypair's private key. If omitted, freight will
#   ask for the passphrase whenever packages are added to the repo using
#   freight-add. No default value.
# [*manage_webserver*]
#   This parameter is inherited from the ::freight class and should not be
#   defined here.
define freight::config (
  Boolean $manage_webserver,
  String $label,
  String $origin,
  String $varcache,
  String $varlib,
  String $www_group,
  String $www_user,
  Optional[String] $gpg_key_id         = undef,
  Optional[String] $gpg_key_email      = undef,
  Optional[String] $gpg_key_passphrase = undef
) {
  include ::freight::params

  ### Parameter defaults and validation

  # Default to values in ::freight class if GPG parameters have not been
  # defined here.
  $l_gpg_key_id = $gpg_key_id ? {
    undef   => $::freight::default_gpg_key_id,
    default => $gpg_key_id,
  }
  $l_gpg_key_email = $gpg_key_email ? {
    undef   => $::freight::default_gpg_key_email,
    default => $gpg_key_email,
  }
  $l_gpg_key_passphrase = $gpg_key_passphrase ? {
    undef   => $::freight::default_gpg_key_passphrase,
    default => $gpg_key_passphrase,
  }
  # Set default values
  File {
    owner   => $::os::params::adminuser,
    group   => $::os::params::admingroup,
  }

  # Check whether we're told to manage the webserver and set a require
  # accordingly
  $require = $manage_webserver ? {
    true    => Nginx::Http_server['freight'],
    false   => undef,
    default => undef,
  }

  # The directory served by the webserver
  file { "freight-${title}-varcache-dir":
    ensure  => directory,
    group   => $www_group,
    mode    => '0755',
    name    => $varcache,
    owner   => $www_user,
    require => $require,
  }

  # The freight lib directory used for staging the packages
  file { "freight-${title}-varlib-dir":
    ensure  => directory,
    group   => $www_group,
    mode    => '0775',
    name    => $varlib,
    owner   => $www_user,
    require => $require,
  }

  # Freight configuration file
  file { "freight-${title}.conf":
    ensure  => present,
    name    => "/etc/freight-${title}.conf",
    content => template('freight/freight.conf.erb'),
    mode    => '0644',
    require => Class['freight::install'],
  }

  # File with the GPG key passphrase for allowing automatic signing
  if $l_gpg_key_passphrase {
    file { "freight-${title}.pass":
      ensure  => present,
      name    => "/etc/freight-${title}.pass",
      content => template('freight/freight.pass.erb'),
      mode    => '0600',
      require => Class['freight::install'],
    }
  } else {
    file { "freight-${title}.pass":
      ensure => absent,
      name   => "/etc/${title}.pass",
    }
  }
}

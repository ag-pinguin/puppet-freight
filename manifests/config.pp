#
# == Class: freight::config
#
# Configure freight
#
class freight::config
(
    $varcache,
    $gpg_key_id,
    $gpg_key_email,
    $gpg_key_passphrase,
    $manage_webserver

) inherits freight::params
{

    validate_string($gpg_key_id)
    validate_string($gpg_key_email)

    class { '::freight::config::gnupg':
        gpg_key_id => $gpg_key_id,
    }

    if $gpg_key_passphrase {
        $gpg_key_passphrase_line = 'GPG_PASSPHRASE_FILE="/etc/freight.pass"'
    } else {
        $gpg_key_passphrase_line = '#GPG_PASSPHRASE_FILE="/etc/freight.pass"'
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
    file { 'freight-varcache-dir':
        ensure  => directory,
        name    => $varcache,
        mode    => '0755',
        require => $require,
    }

    # Freight configuration file
    file { 'freight-freight.conf':
        ensure  => present,
        name    => '/etc/freight.conf',
        content => template('freight/freight.conf.erb'),
        mode    => '0644',
        require => Class['freight::install'],
    }

    # File with the GPG key passphrase for allowing automatic signing

    if $gpg_key_passphrase {

        file { 'freight-freight.pass':
            ensure  => present,
            name    => '/etc/freight.pass',
            content => template('freight/freight.pass.erb'),
            mode    => '0600',
            require => Class['freight::install'],
        }
    } else {

        file { 'freight-freight.pass':
            ensure => absent,
            name   => '/etc/freight.pass',
        }
    }
}

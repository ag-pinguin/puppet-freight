#
# == Class: freight::config
#
# Configure freight
#
class freight::config
(
    $varcache,
    $gpg_key_email,
    $gpg_key_passphrase

) inherits freight::params
{

    # The directory served by the webserver
    file { 'freight-varcache-dir':
        ensure => directory,
        name   => $varcache,
        owner  => $::os::params::adminuser,
        group  => $::os::params::admingroup,
        mode   => '0755',
    }

    # Freight configuration file
    file { 'freight-freight.conf':
        ensure  => present,
        name    => '/etc/freight.conf',
        content => template('freight/freight.conf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['freight::install'],
    }

    # File with the GPG key passphrase for allowing automatic signing

    if $gpg_key_passphrase {

        file { 'freight-freight.pass':
            ensure  => present,
            name    => '/etc/freight.pass',
            content => template('freight/freight.pass.erb'),
            owner   => $::os::params::adminuser,
            group   => $::os::params::admingroup,
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

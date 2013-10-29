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
)
{

    # The directory served by the webserver
    file { 'freight-varcache-dir':
        ensure => directory,
        name => "$varcache",
        owner => root,
        group => root,
        mode => 755,
    }

    # Freight configuration file
    file { 'freight-freight.conf':
        ensure => present,
        name => '/etc/freight.conf',
        content => template('freight/freight.conf.erb'),
        owner => root,
        group => root,
        mode => 644,
        require => Class['freight::install'],
    }

    # File with the GPG key passphrase for allowing automatic signing

    if $gpg_key_passphrase == '' {

        file { 'freight-freight.pass':
            ensure => absent,
            name => '/etc/freight.pass',
        }

    } else {

        file { 'freight-freight.pass':
            ensure => present,
            name => '/etc/freight.pass',
            content => template('freight/freight.pass.erb'),
            owner => root,
            group => root,
            mode => 600,
            require => Class['freight::install'],
        }
    }
}

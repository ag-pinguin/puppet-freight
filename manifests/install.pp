class freight::install {

    package { 'freight-freight':
        name => 'freight',
        ensure => installed,
        require => Class['freight::aptrepo'],
    }

}

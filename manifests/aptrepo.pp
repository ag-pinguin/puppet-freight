#
# == Class: freight::aptrepo
#
# Setup rcrowley's apt repository. This class depends on the "puppetlabs/apt" 
# puppet module:
#
# <https://forge.puppetlabs.com/puppetlabs/apt>
#
class freight::aptrepo inherits freight::params {

    include ::apt

    apt::source { 'freight-aptrepo':
        ensure   => 'present',
        location => 'http://packages.rcrowley.org',
        release  => $::lsbdistcodename,
        repos    => 'main',
        pin      => '501',
        key      => {
            'id'     => '9CF9E62D541145B65B30961F29B2064E7DF49CEF',
            'source' => 'http://packages.rcrowley.org/keyring.gpg',
        },
    }
}

#
# == Class: freight::aptrepo
#
# Setup rcrowley's apt repository. This class depends on the "puppetlabs/apt" 
# puppet module:
#
# <https://forge.puppetlabs.com/puppetlabs/apt>
#
class freight::aptrepo {

    apt::source { 'freight-aptrepo':
        location          => 'http://packages.rcrowley.org',
        release           => "${::lsbdistcodename}",
        repos             => 'main',
        required_packages => undef,
        key               => '7DF49CEF',
        key_source        => 'http://packages.rcrowley.org/keyring.gpg',
        pin               => '501',
        include_src       => false,
    }
}

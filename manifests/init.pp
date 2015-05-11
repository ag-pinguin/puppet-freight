#
# == Class: freight
#
# Manage freight (apt) repositories.
#
# == Parameters
#
# [*manage*]
#  Whether to manage freight with Puppet or not. Valid values are 'yes' 
#  (default) and 'no'.
# [*varcache*]
#   The directory where freight-managed repositories are placed. For example 
#   '/var/www/repos'. Make sure the parent directory exists. No default value.
# [*gpg_key_email*]
#   Email address of the package signing key - check with "gpg --list-keys". No 
#   default value.
# [*gpg_key_passphrase*]
#   The passphrase of the GPG keypair's private key. If omitted, freight will 
#   ask for the passphrase whenever packages are added to the repo using 
#   freight-add. No default value.
#
# == Examples
#
#   class { 'freight':
#       varcache => '/var/www/repos',
#       gpg_key_email => 'packager@domain.com',
#       gpg_key_passphrase => 'mysecretpassphrase',
#   }
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class freight
(
    $varcache,
    $gpg_key_email,
    $gpg_key_passphrase=undef,
    $manage = 'yes'
)
{

if $manage == 'yes' {

    include ::freight::aptrepo

    include ::freight::install

    class { '::freight::config':
        varcache           => $varcache,
        gpg_key_email      => $gpg_key_email,
        gpg_key_passphrase => $gpg_key_passphrase,
    }
}
}

#
# == Class: freight
#
# Manage freight (apt) repositories.
#
# == Parameters
#
# [*manage*]
#   Whether to manage freight with Puppet or not. Valid values are true 
#   (default) and false.
# [*manage_webserver*]
#   Whether to manage the webserver (nginx) or not. Valid values are true 
#   (default) and false. If you set this to false, make sure that a webserver is 
#   configured and that the parent directory of $varcache directory exists 
#   before this class is included.
# [*allow_address_ipv4*]
#   IPv4 addresses/networks from which to allow connections. This parameter can
#   be either a string or an array. Defaults to 'anyv4' which means that access
#   is allowed from any IPv4 address. Uses the webserver module to do the hard
#   lifting. This parameter has no effect if $manage_webserver is false.
# [*allow_address_ipv6*]
#   As above but for IPv6 addresses. Defaults to 'anyv6', thus allowing access 
#   from any IPv6 address. This parameter has no effect if $manage_webserver is 
#   false.
# [*document_root*]
#   The document root for the webserver. This parameter is ignored unless you've 
#   set $manage_webserver to true. Defaults to '/var/www'.
# [*varcache*]
#   The directory where freight-managed repositories are placed. The default 
#   value is '/var/www/apt'.
# [*gpg_key_id*]
#   The ID of the key to install. For example 'D50582E6'. The private and public 
#   keys need to be on the Puppet fileserver and accessible at these URIs:
#   
#   "puppet:///files/${gpg_key_id}-private.key"
#   
#   "puppet:///files/${gpg_key_id}-public.key"
#
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
#       gpg_key_id => 'D50582E6',
#       gpg_key_email => 'packager@domain.com',
#       gpg_key_passphrase => 'mysecretpassphrase',
#   }
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# Samuli Seppänen <samuli@openvpn.net>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class freight
(
    $gpg_key_id,
    $gpg_key_email,
    $allow_address_ipv4 = 'anyv4',
    $allow_address_ipv6 = 'anyv6',
    $document_root = '/var/www',
    $varcache = '/var/www/apt',
    $gpg_key_passphrase=undef,
    $manage = true,
    $manage_webserver = true
)
{

# Validate parameters
validate_bool($manage)
validate_bool($manage_webserver)

if $manage {

    if $manage_webserver {
        class { '::freight::webserver':
            document_root      => $document_root,
            allow_address_ipv4 => $allow_address_ipv4,
            allow_address_ipv6 => $allow_address_ipv6,
        }
    }
    include ::freight::aptrepo
    include ::freight::install

    class { '::freight::config':
        varcache           => $varcache,
        gpg_key_id         => $gpg_key_id,
        gpg_key_email      => $gpg_key_email,
        gpg_key_passphrase => $gpg_key_passphrase,
        # We need to pass this parameter to set the value of a require
        manage_webserver   => $manage_webserver,
    }
}
}

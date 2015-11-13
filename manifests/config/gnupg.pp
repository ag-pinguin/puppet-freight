#
# == Class: freight::config::gnupg
#
# Add the GPG keys used with freight
#
class freight::config::gnupg
(
    $gpg_key_id
)
{
    Gnupg_key {
        ensure => present,
        user   => 'root',
        key_id => $gpg_key_id,
    }

    gnupg_key { 'freight-public-key':
        key_source => "puppet:///files/${gpg_key_id}-public.key",
        key_type   => 'public',
    }

    gnupg_key { 'freight-private-key':
        key_source => "puppet:///files/${gpg_key_id}-private.key",
        key_type   => 'private',
    }
}

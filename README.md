# freight

A Puppet module for managing Freight - a tool for creating and maintaining apt 
repositories easily. This module can manage several freight repositories 
residing on the same host.

# Module usage

Creating a two freight repositories using Hiera:

    classes:
        - freight
    
    # Automatic webserver (nginx) configuration
    freight::manage_webserver: true
    freight::document_root: '/var/www/html'
    freight::allow_address_ipv4: 'anyv4'
    freight::allow_address_ipv6: 'anyv6'
    
    # Default GPG keys to use
    freight::default_gpg_key_id: 'C42A86B2'
    freight::default_gpg_key_email: 'john@domain.com'
    
    # Freight instances
    freight::configs:
        repo1:
            # Use the default GPG keys and store the passphrase on disk 
            varcache: '/var/www/html/repo1'
            gpg_key_passphrase: 'mysecret'
        repo2:
            # Use a custom set of GPG keys and always prompt for the passphrase
            varcache: '/var/www/html/repo2'
            gpg_key_id: '974C71E8'
            gpg_key_email: 'jane@domain.com'

For details look here:

* [Class: freight](manifests/init.pp)
* [Define: freight::config](manifests/config.pp)

# Dependencies

See [metadata.json](metadata.json).

# Operating system support

This module has been tested on

* Debian 7
* Ubuntu 12.04
* Ubuntu 14.04

Any Debian-based operating system should work out of the box or with small 
modifications.

For details see [params.pp](manifests/params.pp).

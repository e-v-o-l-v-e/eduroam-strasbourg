# eduroam-flake

Install Eduroam on NixOS.

## TDLR for helpdesk people

Installing Eduroam on NixOS is not much different from installing it on other Linux distributions.
Users need to use network-manager and execute the python script provided by the cat.eduroam.org.
Main difference on NixOS: the way we manage dependencies is different.

In case you are not familiar with Nix, but you need to help a NixOS user to install Eduroam, here are two options:

### Using this Nix Flake

Take a look at the `flake.nix` file. All this flake does:

1. Copy the python script into the nix store
2. Execute it with Python3 and the dependencies needed

It should be easy to verify what it does, since all URL's are listed.
The `flake.lock` file contains the hashes of the files.
This README also describes how to extend the flake for other Universities. 


Execute the script from GitHub directly:
```sh
nix run 'github:mayniklas/eduroam-flake'#strasbourg
```

Execute the script from a local clone:
```sh
git clone https://github.com/MayNiklas/eduroam-flake.git
cd eduroam-flake
nix run .#strasbourg
```

Warning: Nix flakes are pure. In other words: everything that is fetched needs to be hashed and locked in the `flake.lock` file.
This `flake.nix` will fail to build if the hashes are not correct (e.g. if the Eduroam.py script changes). There is a super easy fix for this:

```sh
# Execute the flake without updating the lock file
nix run 'github:mayniklas/eduroam-flake'#strasbourg --recreate-lock-file --no-write-lock-file

# Update the flake.lock file
nix flake lock --update-input eduroam-university-bonn
```

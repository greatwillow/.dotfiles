# .dotfiles
My personal dotfiles combined with a portable development environment setup designed to work on Mac, WSL2 and most Linux distributions.

## Usage

#### Download and run the setup scripts with the following command:

```cd / & mkdir personal-setup-scripts & cd $_ & curl https://raw.githubusercontent.com/greatwillow/.dotfiles/main/0-run-setup.sh -O & bash 0-run-setup.sh```

## Context

#### Logic of the setup scripts:

##### 1-setup-user.sh

- Ensures that the currently logged in user is not the root user.  Only non-root users are able to install packages using Nix.  
- If the current user is the root user, a prompt is added to allow either for a new user to be created and used, or another user to be selected.
- Once a non root user has been selected, the script logs the shell into the system as that user.

##### 2-get-dotfiles.sh
- A user selected dotfiles directory is downloaded and unzipped using ```curl``` and ```tar```.
  
##### 3-setup-environment.sh
- This is the main script for installing the environment for the logged in user with the dotfiles as specified in ths previous scripts.
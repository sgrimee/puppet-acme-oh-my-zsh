# == Class: ohmyzsh::install
#
# This is the ohmyzsh module. It installs oh-my-zsh for a user and changes
# their shell to zsh. It has been tested under Ubuntu.
#
# This module is called ohmyzsh as Puppet does not support hyphens in module
# names.
#
# oh-my-zsh is a community-driven framework for managing your zsh configuration.
#
# === Parameters
#
# None.
#
# === Examples
#
# class { 'ohmyzsh': }
# ohmyzsh::install { 'acme': }
#
# === Authors
#
# Leon Brocard <acme@astray.com>
#
# === Copyright
#
# Copyright 2013 Leon Brocard
#
define ohmyzsh::install() {

  if $name == 'root' { $home = '/root' } else { $home = "${ohmyzsh::params::home}/${name}" }

  exec { "ohmyzsh::git clone ${name}":
    path    => '/bin:/usr/bin',
    cwd     => "/home/$name",
    creates => "${home}/.oh-my-zsh",
    command => "/usr/bin/git clone https://github.com/robbyrussell/oh-my-zsh.git ${home}/.oh-my-zsh",
    #returns => [ 0, 128],
    user    => $name,
    require => [Package['git'], Package['zsh'], Package['curl']]
  }

  exec { "ohmyzsh::cp .zshrc ${name}":
    creates => "${home}/.zshrc",
    command => "/bin/cp ${home}/.oh-my-zsh/templates/zshrc.zsh-template ${home}/.zshrc",
    user    => $name,
    require => Exec["ohmyzsh::git clone ${name}"],
  }

  if ! defined(User[$name]) {
    user { "ohmyzsh::user ${name}":
      ensure  => present,
      name    => $name,
      shell   => $ohmyzsh::params::zsh,
      require => Package['zsh'],
    }
  } else {
    User <| title == $name |> {
      shell => $ohmyzsh::params::zsh
    }
  }
}

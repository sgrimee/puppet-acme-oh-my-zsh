# install an environment variable into .zshrc for a user
define ohmyzsh::variable(
  $variable = $name,
  $value,
  $user,
) {
  if $user == 'root' { $home = '/root' } else { $home = "${ohmyzsh::params::home}/${user}" }
  if $user {
    file_line { "${user}-${variable}-install":
      path    => "${home}/.zshrc",
      line    => "${variable}={$value}",
      match   => "^${variable}=",
      require => Ohmyzsh::Install[$user]
    }
  }
}

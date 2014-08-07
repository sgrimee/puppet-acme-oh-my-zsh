class ohmyzsh::params {

  $update_repo = false

  case $::operatingsystem {
    default: {
      $zsh = '/usr/bin/zsh'
      $home = '/home'
    }
  }
}

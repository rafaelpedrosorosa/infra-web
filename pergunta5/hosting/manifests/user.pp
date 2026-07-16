# Cria o ambiente isolado de um cliente de hospedagem.
#
# Este recurso definido pode ser reutilizado para múltiplos clientes.
define hosting::user (
  String $system_user,
  String $base_dir = "/var/www/hosting/${system_user}",
) {

  group { $system_user:
    ensure => present,
  }

  user { $system_user:
    ensure     => present,
    gid        => $system_user,
    home       => $base_dir,
    managehome => false,
    shell      => '/usr/sbin/nologin',
    require    => Group[$system_user],
  }

  file { $base_dir:
    ensure  => directory,
    owner   => $system_user,
    group   => $system_user,
    mode    => '0750',
    require => [
      User[$system_user],
      File['/var/www/hosting'],
    ],
  }

  file { "${base_dir}/public_html":
    ensure  => directory,
    owner   => $system_user,
    group   => $system_user,
    mode    => '0755',
    require => File[$base_dir],
  }

  file { "${base_dir}/logs":
    ensure  => directory,
    owner   => $system_user,
    group   => $system_user,
    mode    => '0750',
    require => File[$base_dir],
  }
}

# Gerencia a stack web compartilhada da plataforma de hospedagem.
#
# Premissa de laboratório:
# - Nginx é instalado e gerenciado diretamente pelo Puppet.
# - LiteSpeed/LSPHP são representados como componentes configuráveis.
# - Em produção, os pacotes seriam obtidos de repositório oficial
#   e a licença seria gerenciada por mecanismo seguro.
class hosting::stack (
  String $nginx_package       = 'nginx',
  String $nginx_service       = 'nginx',
  String $litespeed_package   = 'openlitespeed',
  String $litespeed_service   = 'lsws',
  String $lsphp_package       = 'lsphp81',
  Boolean $manage_litespeed   = false,
) {

  package { [
    $nginx_package,
    'curl',
    'tar',
    'unzip',
  ]:
  ensure => installed,
}

  service { $nginx_service:
    ensure  => running,
    enable  => true,
    require => Package[$nginx_package],
  }

  if $manage_litespeed {
    package { $litespeed_package:
      ensure => installed,
    }

    package { $lsphp_package:
      ensure  => installed,
      require => Package[$litespeed_package],
    }

    service { $litespeed_service:
      ensure  => running,
      enable  => true,
      require => [
        Package[$litespeed_package],
        Package[$lsphp_package],
      ],
    }
  }

  file { '/etc/nginx/sites-available':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/nginx/sites-enabled':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/var/www/hosting':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
}

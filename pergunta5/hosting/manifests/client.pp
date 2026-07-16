# Provisiona completamente um cliente de hospedagem compartilhada.
define hosting::client (
  String               $domain,
  String               $system_user,
  Integer[1024, 65535] $backend_port,

  String $db_name,
  String $db_user,
  String $db_password,
  String $db_host = 'localhost',

  String  $base_dir = "/var/www/hosting/${system_user}",
  String  $wordpress_version = 'latest',
  Boolean $manage_litespeed = false,
) {

  contain hosting::stack

  hosting::user { $title:
    system_user => $system_user,
    base_dir    => $base_dir,
  }

  hosting::wordpress { $title:
    domain            => $domain,
    system_user       => $system_user,
    base_dir          => $base_dir,
    db_name           => $db_name,
    db_user           => $db_user,
    db_password       => $db_password,
    db_host           => $db_host,
    wordpress_version => $wordpress_version,
  }

  hosting::vhost { $title:
    domain           => $domain,
    system_user      => $system_user,
    backend_port     => $backend_port,
    base_dir         => $base_dir,
    manage_litespeed => $manage_litespeed,
  }

  Class['hosting::stack']
    -> Hosting::Wordpress[$title]
    -> Hosting::Vhost[$title]
}

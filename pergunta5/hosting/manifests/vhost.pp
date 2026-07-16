# Cria os virtual hosts Nginx e LiteSpeed de um cliente.
define hosting::vhost (
  String                     $domain,
  String                     $system_user,
  Integer[1024, 65535]       $backend_port,
  String                     $base_dir,
  Boolean                    $manage_litespeed = false,
  String                     $litespeed_service = 'lsws',
) {

  $document_root = "${base_dir}/public_html"
  $access_log    = "${base_dir}/logs/access.log"
  $error_log     = "${base_dir}/logs/error.log"

  $nginx_available = "/etc/nginx/sites-available/${domain}.conf"
  $nginx_enabled   = "/etc/nginx/sites-enabled/${domain}.conf"

  file { $nginx_available:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp(
      'hosting/nginx-vhost.conf.epp',
      {
        'domain'       => $domain,
        'backend_port' => $backend_port,
        'access_log'   => $access_log,
        'error_log'    => $error_log,
      }
    ),
    require => [
      File['/etc/nginx/sites-available'],
      File["${base_dir}/logs"],
    ],
  }

  file { $nginx_enabled:
    ensure  => link,
    target  => $nginx_available,
    require => [
      File['/etc/nginx/sites-enabled'],
      File[$nginx_available],
    ],
  }

  exec { "validate-nginx-${domain}":
    command     => '/usr/sbin/nginx -t',
    path        => ['/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    refreshonly => true,
    subscribe   => [
      File[$nginx_available],
      File[$nginx_enabled],
    ],
  }

  if $manage_litespeed {
    $litespeed_vhost_dir = "/usr/local/lsws/conf/vhosts/${domain}"
    $cache_dir           = "/var/cache/litespeed/${system_user}"

    file { '/var/cache/litespeed':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }

    file { $cache_dir:
      ensure  => directory,
      owner   => $system_user,
      group   => $system_user,
      mode    => '0750',
      require => [
        File['/var/cache/litespeed'],
        User[$system_user],
      ],
    }

    file { $litespeed_vhost_dir:
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => Package['openlitespeed'],
    }

    file { "${litespeed_vhost_dir}/vhconf.conf":
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => epp(
        'hosting/litespeed-vhost.conf.epp',
        {
          'domain'        => $domain,
          'document_root' => $document_root,
          'system_user'   => $system_user,
          'backend_port'  => $backend_port,
          'access_log'    => $access_log,
          'error_log'     => $error_log,
        }
      ),
      require => [
        File[$litespeed_vhost_dir],
        File[$cache_dir],
      ],
      notify  => Service[$litespeed_service],
    }
  }
}

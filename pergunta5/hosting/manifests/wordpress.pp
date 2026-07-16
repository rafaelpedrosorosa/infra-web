# Instala o WordPress e o plugin LiteSpeed Cache no ambiente do cliente.
define hosting::wordpress (
  String $domain,
  String $system_user,
  String $base_dir,
  String $db_name,
  String $db_user,
  String $db_password,
  String $db_host = 'localhost',
  String $wordpress_version = 'latest',
) {

  $document_root = "${base_dir}/public_html"
  $wordpress_url = $wordpress_version ? {
    'latest' => 'https://wordpress.org/latest.tar.gz',
    default  => "https://wordpress.org/wordpress-${wordpress_version}.tar.gz",
  }

  exec { "download-wordpress-${domain}":
    command => "/usr/bin/curl --fail --location --silent --show-error \
      '${wordpress_url}' --output /tmp/wordpress-${system_user}.tar.gz",
    creates => "/tmp/wordpress-${system_user}.tar.gz",
    require => Package['curl'],
  }

  exec { "extract-wordpress-${domain}":
    command => "/bin/tar --extract --gzip \
      --file=/tmp/wordpress-${system_user}.tar.gz \
      --strip-components=1 \
      --directory=${document_root}",
    creates => "${document_root}/wp-settings.php",
    require => [
      Exec["download-wordpress-${domain}"],
      Package['tar'],
      File[$document_root],
    ],
  }

  file { "${document_root}/wp-config.php":
    ensure    => file,
    owner     => $system_user,
    group     => $system_user,
    mode      => '0640',
    show_diff => false,
    content   => epp(
      'hosting/wp-config.php.epp',
      {
        'db_name'     => $db_name,
        'db_user'     => $db_user,
        'db_password' => $db_password,
        'db_host'     => $db_host,
        'domain'      => $domain,
      }
    ),
    require => Exec["extract-wordpress-${domain}"],
  }

  exec { "download-lscache-${domain}":
    command => "/usr/bin/curl --fail --location --silent --show-error \
      'https://downloads.wordpress.org/plugin/litespeed-cache.latest-stable.zip' \
      --output /tmp/litespeed-cache-${system_user}.zip",
    creates => "/tmp/litespeed-cache-${system_user}.zip",
    require => Package['curl'],
  }

  exec { "install-lscache-${domain}":
    command => "/usr/bin/unzip -q \
      /tmp/litespeed-cache-${system_user}.zip \
      -d ${document_root}/wp-content/plugins",
    creates => "${document_root}/wp-content/plugins/litespeed-cache/litespeed-cache.php",
    require => [
      Exec["extract-wordpress-${domain}"],
      Exec["download-lscache-${domain}"],
      Package['unzip'],
    ],
  }

 exec { "set-wordpress-ownership-${domain}":
   command     => "/bin/chown -R ${system_user}:${system_user} ${document_root}",
   path        => ['/usr/bin', '/bin'],
   refreshonly => true,
   subscribe   => [
     Exec["extract-wordpress-${domain}"],
     Exec["install-lscache-${domain}"],
   ],
 }
}

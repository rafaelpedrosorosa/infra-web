class { 'hosting::stack':
  manage_litespeed => false,
}

hosting::client { 'cliente1':
  domain           => 'cliente1.test',
  system_user      => 'cliente1',
  backend_port     => 8101,
  db_name          => 'cliente1_wp',
  db_user          => 'cliente1_wp',
  db_password      => 'senha_cliente1_laboratorio',
  db_host          => 'localhost',
  wordpress_version => 'latest',
  manage_litespeed => false,
}

hosting::client { 'cliente2':
  domain            => 'cliente2.test',
  system_user       => 'cliente2',
  backend_port      => 8102,
  db_name           => 'cliente2_wp',
  db_user           => 'cliente2_wp',
  db_password       => 'senha_laboratorio',
  manage_litespeed  => false,
}

hosting::client { 'cliente3':
  domain            => 'cliente3.test',
  system_user       => 'cliente3',
  backend_port      => 8103,
  db_name           => 'cliente3_wp',
  db_user           => 'cliente3_wp',
  db_password       => 'senha_cliente3_laboratorio',
  db_host           => 'localhost',
  wordpress_version => 'latest',
  manage_litespeed  => false,
}

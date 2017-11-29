<?php

use Dotenv\Dotenv;

$dotenv = new Dotenv(__DIR__ . '/..');
$dotenv->load();

$version = env('APP_VERSION');
$hash = env('HASH');

$database = [];

$config_directories = [
  CONFIG_SYNC_DIRECTORY => "{$app_root}/sync",
];

$settings = [
  'hash_salt' => $hash,
  'deployment_identifier' => $version,
  'file_scan_ignore_directories' => [
    'node_modules',
    'bower_components',
    'vendor',
    'tests',
  ],
  'container_yamls' => [
    "{$app_root}/sites/{$version}/services.yml",
  ],
  'file_public_path' => "{$app_root}/html/files/{$version}/public",
  'file_private_path' => "{$app_root}/html/files/{$version}/private",
  'install_profile' => 'ib3_dist',
];

if (file_exists("{$app_root}/sites/{$version}/settings.php")) {
  include "{$app_root}/sites/{$version}/settings.php";
}

<?php

namespace Tests\Modules;

require __DIR__ . '/../../vendor/autoload.php';

use duncan3dc\Laravel\Dusk;
use PHPUnit\Framework\TestCase;
use GuzzleHttp\Client;

class Module_Example extends TestCase {

  protected $browser;
  protected $client;
  protected $url;
  protected $options;


  protected function setUp()
  {
    parent::setUp();
    $this->browser = new Dusk;
    $this->client = new Client;
    $this->url = $_SERVER['domain'];
    $this->options = [
      'verify' => false,
    ];
  }

  /**
   * @test
   */
  public function Exists()
  {
    $this->browser
      ->visit($this->url)
      ->assertVisible('#ib3-module--ib3-module-example');
  }
}

<?php

namespace Tests\Pages;

require __DIR__ . '/../../vendor/autoload.php';

use duncan3dc\Laravel\Dusk;
use PHPUnit\Framework\TestCase;
use GuzzleHttp\Client;

class Page_Example extends TestCase {

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
  public function Returns_Status_Code_200()
  {
    $response = $this->client
      ->request('GET', $this->url, $this->options);
    $this->assertEquals(200, $response->getStatusCode());
  }

  /**
   * @test
   */
  public function Contains_H1_Tag()
  {
    $this->browser
      ->visit($this->url)
      ->assertVisible('h1');
  }
}

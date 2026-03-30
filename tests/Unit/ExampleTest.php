<?php

namespace Tests\Unit;

use Tests\TestCase;

class ExampleTest extends TestCase
{
    /**
     * A basic test example.
     */
    public function test_application_name_is_string(): void
    {
        $value = $this->app->make('config')->get('app.name');

        $this->assertIsString($value);
    }

    protected function setUp(): void
    {
        parent::setUp();
    }
}

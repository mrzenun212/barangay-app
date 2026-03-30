<?php

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;

class ExampleTest extends TestCase
{
    /**
     * A basic test example.
     */
    public function test_application_name_is_string(): void
    {
        $value = config('app.name');

        $this->assertIsString($value);
    }
}

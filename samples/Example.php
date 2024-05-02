<?php

interface ExampleConstract
{
    public function all(): array

    public function getSingle(int|string $id): Object

    public function setProperty(int|string|array|Object $any): void
}
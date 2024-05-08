<?php

class Test implements ExampleConstract
{
    protected int|string|array|object $any;

    public function __construct(
        protected string $name = 'World',
    ) {
    }

    protected function all(): array
    {
        return [
            'name' => $this->name,
        ];
    }

    protected function getSingle(int|string $id): object
    {
        return (object) [
            'id' => $id,
            'name' => $this->name,
        ];
    }

    protected function setProperty(int|string|array|object $any): void
    {
        $this->any = $any;
    }

    public function setName(string $name): void
    {
        $this->name = $name;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function sayHello(): string
    {
        return "Hello! {$this->name}!";
    }

    public function sayGoodbye(): string
    {
        return "Goodbye! {$this->name}!";
    }
}

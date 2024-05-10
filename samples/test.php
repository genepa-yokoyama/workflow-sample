<?php

# Test
class Test
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

    public function setName(string $name): void
    {
        $this->name = $name;
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function getAny(): int|string|array|object
    {
        return $this->any;
    }

    public function setAny(int|string|array|object $any): void
    {
        $this->any = $any;
    }
}

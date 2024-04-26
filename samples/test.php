<?php


class Test
{
    public function __construct(
        protected string $name = 'World',
    )
    {
    }

    public function setName(string $name): void
    {
        $this->name = $name;
    }

    public function getName(): string
    {
        return $this->name;
    }

}

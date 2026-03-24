<?php

namespace Database\Factories;

use App\Models\Variation;
use App\Models\VariationOption;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\VariationOption>
 */
class VariationOptionFactory extends Factory
{
    protected $model = VariationOption::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'variation_id' => Variation::factory(),
            'value' => $this->faker->word(),
        ];
    }
}

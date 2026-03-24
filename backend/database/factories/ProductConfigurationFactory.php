<?php

namespace Database\Factories;

use App\Models\ProductConfiguration;
use App\Models\ProductItem;
use App\Models\VariationOption;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\ProductConfiguration>
 */
class ProductConfigurationFactory extends Factory
{
    protected $model = ProductConfiguration::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'product_item_id' => ProductItem::factory(),
            'variation_option_id' => VariationOption::all()->random()->id ?? VariationOption::factory(),
        ];
    }
}

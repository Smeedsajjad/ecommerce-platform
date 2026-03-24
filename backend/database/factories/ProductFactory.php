<?php

namespace Database\Factories;

use App\Models\Category;
use App\Models\Product;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Product>
 */
class ProductFactory extends Factory
{
    protected $model = Product::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $name = $this->faker->words(3, true);
        return [
            'category_id' => Category::inRandomOrder()->first()->id,
            'name' => ucfirst($name),
            'slug' => Str::slug($name),
            'description' => $this->faker->paragraph(),
        ];
    }

    public function configure()
    {
        return $this->afterCreating(function (Product $product) {
            $categoryName = strtolower(str_replace(' ', '_', $product->category->name));
           
            // Look for files matching the category prefix (e.g., accessories_*.jpg)
            $images = glob(database_path("seeders/images/products/{$categoryName}_*.jpg"));

           if (!empty($images)) {
                // Randomly select 2-4 images for the gallery
                $count = min(count($images), rand(2, 4));
                $selected = (array) array_rand($images, $count);
                
                foreach ($selected as $index) {
                    $product->addMedia($images[$index])
                        ->preservingOriginal()
                        ->toMediaCollection('product_images');
                }
           } else {
                // Fallback to placeholder
                $product
                    ->addMediaFromUrl("https://placehold.co/600x400?text=" . urlencode($product->name))
                    ->toMediaCollection('product_images');
            }
        });
    }
}

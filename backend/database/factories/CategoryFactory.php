<?php

namespace Database\Factories;

use App\Models\Category;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Category>
 */
class CategoryFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */

    protected $model = Category::class;



    public function definition(): array
    {
        return [
            'name' => $this->faker->unique()->word(),
            'slug' => fn (array $attributes) => Str::slug($attributes['name']),
            'is_active' => true,
        ];
    }

    public function configure()
    {
        return $this->afterCreating(function (Category $category) {
            $images = File::files(database_path('seeders/images/categories'));

            if (!empty($images)) {

                $randomImage = $images[array_rand($images)];

                $category
                    ->addMedia($randomImage->getPathname())
                    ->preservingOriginal()
                    ->toMediaCollection('category_images');
            } else {
                // Fallback to a placeholder if no local images found
                $category
                    ->addMediaFromUrl("https://placehold.co/600x400?text=" . urlencode($category->name))
                    ->toMediaCollection('category_images');
            }
        });
    }

}

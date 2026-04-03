<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        
        $this->command->alert("Start Seeding Users!");

        User::factory()->create([
            'name' => "Admin",
            'email' => "admin@example.com",
            'password' => "password",
            'is_admin' => true,
        ]);

        User::factory(10)->create();
        $this->command->info("Users Seed Successfully!");

        $this->command->alert("Start Seeding Variations, Products, and Items!");
        // Create Categories
        $categories = [
            'Accessories',
            'Baby Care',
            'Bag Luggage',
            'Beauty',
            'Bed',
            'Books Stationery',
            'Electronics',
            'Fashion',
            'Furniture',
            'Home Decore',
            'Kitchen',
            'Laptop',
            'Lighting',
            'Mens Clothing',
            'Mobile Phones',
            'Pet Supplies',
            'Shoes',
            'Sports',
            'Table',
            'Toys Games',
            'TV',
            'Womens Clothing',
        ];

        foreach ($categories as $categoryName) {
            $category = Category::factory()->create([
                'name' => $categoryName,
            ]);

            // Create Variations for this category (e.g. Size, Color)
            $sizeVar = \App\Models\Variation::factory()->create([
                'category_id' => $category->id,
                'name' => 'Size'
            ]);
            $colorVar = \App\Models\Variation::factory()->create([
                'category_id' => $category->id,
                'name' => 'Color'
            ]);

            // Create VariationOptions
            $sizes = ['S', 'M', 'L', 'XL'];
            $colors = ['Red', 'Blue', 'Black', 'White'];

            $sizeOptions = [];
            foreach ($sizes as $s) {
                $sizeOptions[] = \App\Models\VariationOption::factory()->create([
                    'variation_id' => $sizeVar->id,
                    'value' => $s
                ]);
            }

            $colorOptions = [];
            foreach ($colors as $c) {
                $colorOptions[] = \App\Models\VariationOption::factory()->create([
                    'variation_id' => $colorVar->id,
                    'value' => $c
                ]);
            }

            // Create 10 Products for each category
            \App\Models\Product::factory(10)->create([
                'category_id' => $category->id
            ])->each(function ($product) use ($sizeOptions, $colorOptions) {
                // Create 3 Items (variants) for each product
                \App\Models\ProductItem::factory(3)->create([
                    'product_id' => $product->id
                ])->each(function ($item) use ($sizeOptions, $colorOptions) {
                    // Each item links to 1 size and 1 color
                    \App\Models\ProductConfiguration::factory()->create([
                        'product_item_id' => $item->id,
                        'variation_option_id' => $sizeOptions[array_rand($sizeOptions)]->id
                    ]);
                    \App\Models\ProductConfiguration::factory()->create([
                        'product_item_id' => $item->id,
                        'variation_option_id' => $colorOptions[array_rand($colorOptions)]->id
                    ]);
                });
            });
        }

        $this->command->info("Categories, Variations, Products, and Items Seeded Successfully!");
        $this->command->alert("Start Seeding Carts and Cart Items!");

        $users = User::all();
        $productItems = \App\Models\ProductItem::all();

        foreach ($users as $user) {
            $cart = \App\Models\Cart::factory()->create([
                'user_id' => $user->id
            ]);

            // Add 1-5 random items to each cart
            \App\Models\CartItem::factory(rand(1, 5))->create([
                'cart_id' => $cart->id,
                'product_item_id' => function () use ($productItems) {
                    return $productItems->random()->id;
                }
            ]);
        }

        $this->command->info("Carts and Cart Items Seeded Successfully for all users!");
    }
}

<?php

namespace Database\Seeders;

use App\Models\Cart;
use App\Models\Category;
use App\Models\Product;
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
        // Create Admin User
        $admin = User::create([
            'name' => 'Admin User',
            'email' => 'admin@gmail.com',
            'is_admin' => true,
            'password' => bcrypt('password'),
        ]);

        // Create Categories
        $categories = Category::factory(5)->create();

        // Create Products for each category
        foreach ($categories as $category) {
            Product::factory(10)->create([
                'category_id' => $category->id,
            ]);
        }

        // Create random users
        $users = User::factory(50)->create();

        // Create carts and cart items for each random user
        $users->each(function ($user) {
            $cart = Cart::factory()->create(['user_id' => $user->id]);

            $products = Product::inRandomOrder()->limit(rand(1, 5))->get();
            foreach ($products as $product) {
                \App\Models\CartItem::factory()->create([
                    'cart_id' => $cart->id,
                    'product_id' => $product->id,
                ]);
            }
        });

        $this->call(OrderSeeder::class);

        $this->command->info('Database seeded successfully!');
        $this->command->info('Admin login: admin@gmail.com / password');
    }
}

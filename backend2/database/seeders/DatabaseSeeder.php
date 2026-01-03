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
        $users = User::factory(10)->create();

        // Create a cart for admin with some products
        $cart = Cart::create(['user_id' => $users->first()->id]);

        $randomProducts = Product::inRandomOrder()->limit(3)->get();
        foreach ($randomProducts as $product) {
            \App\Models\CartItem::create([
                'cart_id' => $cart->id,
                'product_id' => $product->id,
                'quantity' => rand(1, 3),
            ]);
        }

        $this->call(OrderSeeder::class);

        $this->command->info('Database seeded successfully!');
        $this->command->info('Admin login: admin@gmail.com / password');
    }
}

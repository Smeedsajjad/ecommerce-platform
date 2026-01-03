<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class OrderSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = \App\Models\User::where('is_admin', false)->get();
        $products = \App\Models\Product::all();

        if ($users->isEmpty() || $products->isEmpty()) {
            return;
        }

        foreach ($users as $user) {
            // Create 2 orders for each user
            \App\Models\Order::factory(2)->create([
                'user_id' => $user->id,
            ])->each(function ($order) use ($products) {
                $totalAmount = 0;
                // Create 1-3 items for each order
                $itemsCount = rand(1, 3);
                $randomProducts = $products->random($itemsCount);

                foreach ($randomProducts as $product) {
                    $quantity = rand(1, 3);
                    $price = $product->price;

                    \App\Models\OrderItem::factory()->create([
                        'order_id' => $order->id,
                        'product_id' => $product->id,
                        'price' => $price,
                        'quantity' => $quantity,
                    ]);

                    $totalAmount += $price * $quantity;
                }

                $order->update(['total_amount' => $totalAmount]);
            });
        }
    }
}

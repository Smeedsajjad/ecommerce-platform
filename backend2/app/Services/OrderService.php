<?php

namespace App\Services;

use Exception;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\User;
use Illuminate\Support\Facades\DB;

class OrderService
{
    /**
     * @throws Exception
     */
    public function placeOrder(User $user): Order
    {
        return DB::transaction(function () use ($user) {
            $cart = $user->cart;

            if (!$cart) {
                throw new Exception('Cart is empty', 400);
            }

            $cartItems = $cart->items()->with('product')->get();

            if ($cartItems->isEmpty()) {
                throw new Exception('Cart is empty', 400);
            }

            $totalAmount = 0;

            foreach ($cartItems as $cartItem) {
                if (!$cartItem->product->is_active) {
                    throw new Exception("Product {$cartItem->product->name} is not active", 400);
                }

                if ($cartItem->product->stock < $cartItem->quantity) {
                    throw new Exception("Product {$cartItem->product->name} stock is not enough", 400);
                }

                $totalAmount += $cartItem->product->price * $cartItem->quantity;
            }

            $order = Order::create([
                'user_id' => $user->id,
                'total_amount' => $totalAmount,
                'status' => 'pending',
            ]);

            foreach ($cartItems as $cartItem) {
                OrderItem::create([
                    'order_id' => $order->id,
                    'product_id' => $cartItem->product_id,
                    'price' => $cartItem->product->price,
                    'quantity' => $cartItem->quantity,
                ]);

                $cartItem->product->decrementStock($cartItem->quantity);
            }

            $cart->items()->delete();

            return $order;
        });
    }

    public function getUserOrders(User $user)
    {
        return Order::where('user_id', $user->id)
            ->with('items.product')
            ->orderBy('created_at', 'desc')
            ->get();
    }

    public function getOrderDetails(int $orderId, User $user)
    {
        $order = Order::where('id', $orderId)
            ->where('user_id', $user->id)
            ->with('items.product')
            ->first();

        if (!$order) {
            throw new Exception('Order not found', 404);
        }

        return $order;
    }
}

<?php

namespace App\Http\Controllers\Api;

use App\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Resources\CartResource;
use Illuminate\Http\Request;

class CartController extends Controller
{
    use ApiResponse;

    /**
     * Get the authenticated user for the API guard.
     */
    protected function getUser()
    {
        return auth('api')->user();
    }

    public function index()
    {
        $user = $this->getUser();
        if (!$user) {
            return $this->unauthorized('User not authenticated');
        }

        $cart = $user->cart()->firstOrCreate(['user_id' => $user->id]);
        return $this->success(new CartResource($cart->load('items.product')));
    }

    public function store(Request $request)
    {
        $request->validate([
            'product_id' => 'required|exists:products,id',
            'quantity' => 'required|integer|min:1',
        ]);

        $user = $this->getUser();
        if (!$user) {
            return $this->unauthorized('User not authenticated');
        }

        $cart = $user->cart()->firstOrCreate(['user_id' => $user->id]);

        $cartItem = $cart->items()->where('product_id', $request->product_id)->first();

        if ($cartItem) {
            $cartItem->update([
                'quantity' => $cartItem->quantity + $request->quantity,
            ]);
        } else {
            $cartItem = $cart->items()->create([
                'product_id' => $request->product_id,
                'quantity' => $request->quantity,
            ]);
        }

        return $this->success(new CartResource($cart->load('items.product')), 'Item added to cart');
    }

    public function update(Request $request, $itemId)
    {
        $request->validate([
            'quantity' => 'required|integer|min:1',
        ]);

        $user = $this->getUser();
        if (!$user) {
            return $this->unauthorized('User not authenticated');
        }

        // Fetch the item specifically from the user's cart to ensure ownership
        $cart = $user->cart;
        if (!$cart) {
            return $this->error('Cart not found', 404);
        }

        $cartItem = $cart->items()->find($itemId);

        if (!$cartItem) {
            return $this->error('Item not found in your cart', 404);
        }

        $cartItem->update([
            'quantity' => $request->quantity,
        ]);

        return $this->success(new CartResource($cart->load('items.product')), 'Cart updated');
    }

    public function destroy($itemId)
    {
        $user = $this->getUser();
        if (!$user) {
            return $this->unauthorized('User not authenticated');
        }

        $cart = $user->cart;
        if (!$cart) {
            return $this->error('Cart not found', 404);
        }

        $cartItem = $cart->items()->find($itemId);

        if (!$cartItem) {
            return $this->error('Item not found in your cart', 404);
        }

        $cartItem->delete();

        return $this->success(new CartResource($cart->load('items.product')), 'Item removed from cart');
    }

    public function clear()
    {
        $user = $this->getUser();
        if (!$user) {
            return $this->unauthorized('User not authenticated');
        }

        $cart = $user->cart;

        if ($cart) {
            $cart->items()->delete();
        }

        return $this->success(null, 'Cart cleared');
    }
}

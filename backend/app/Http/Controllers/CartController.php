<?php

namespace App\Http\Controllers;

use App\Http\Resources\CartResource;
use App\Models\Cart;
use App\Models\CartItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CartController extends Controller
{
    /**
     * Get the authenticated user for the API guard.
     */
    protected function getAuthenticatedUser()
    {
        return Auth::user();
    }
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $user = $this->getAuthenticatedUser();

        // We load "items" and all the product info beneath it
        $cart = Cart::with(['items.productItem.product', 'items.productItem.configurations.variationOption.variation'])
            ->firstOrCreate(['user_id' => $user->id]);
        return $this->success(new CartResource($cart));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'product_item_id' => 'required|exists:product_items,id',
            'quantity' => 'required|integer|min:1',
        ]);

        $user = $this->getAuthenticatedUser();
        
        $cart = Cart::firstOrCreate(['user_id' => $user->id]);

        $cartItem = CartItem::where('cart_id', $cart->id)
            ->where('product_item_id', $request->product_item_id)
            ->first();

        if ($cartItem) {
            $cartItem->quantity += $request->quantity;
            $cartItem->save();
        } else {
            CartItem::create([
                'cart_id' => $cart->id,
                'product_item_id' => $request->product_item_id,
                'quantity' => $request->quantity,
            ]);
        }

        $cart->load(['items.productItem.product', 'items.productItem.configurations.variationOption.variation']);
        
        return $this->success(new CartResource($cart));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $request->validate([
            'quantity' => 'required|integer|min:1',
        ]);

        $user = $this->getAuthenticatedUser();
        $cart = Cart::where('user_id', $user->id)->first();
        
        if (!$cart) {
            return $this->error('Cart not found', 404);
        }

        $cartItem = CartItem::where('id', $id)->where('cart_id', $cart->id)->first();

        if (!$cartItem) {
            return $this->error('Cart item not found', 404);
        }

        $cartItem->quantity = $request->quantity;
        $cartItem->save();

        $cart->load(['items.productItem.product', 'items.productItem.configurations.variationOption.variation']);

        return $this->success(new CartResource($cart));
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $user = $this->getAuthenticatedUser();
        $cart = Cart::where('user_id', $user->id)->first();

        if (!$cart) {
            return $this->error('Cart not found', 404);
        }

        $cartItem = CartItem::where('id', $id)->where('cart_id', $cart->id)->first();

        if (!$cartItem) {
            return $this->error('Cart item not found', 404);
        }

        $cartItem->delete();

        $cart->load(['items.productItem.product', 'items.productItem.configurations.variationOption.variation']);

        return $this->success(new CartResource($cart));
    }
}

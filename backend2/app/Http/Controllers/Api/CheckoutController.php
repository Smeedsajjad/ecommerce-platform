<?php

namespace App\Http\Controllers\Api;

use App\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Resources\CartItemResource;
use App\Models\CartItem;
use Illuminate\Http\Request;

class CheckoutController extends Controller
{
    use ApiResponse;

    /**
     * Get a validated checkout summary.
     * - Validates cart is non-empty
     * - Checks each product is active and has sufficient stock
     * - Recalculates totals server-side (never trust client)
     * - Returns clean summary with subtotal, shipping (0), discount (0), total
     */
    public function summary(Request $request)
    {
        $user = auth('api')->user();

        if (!$user) {
            return $this->unauthorized('User not authenticated');
        }

        $cart = $user->cart()->with('items.product.media')->first();

        if (!$cart || $cart->items->isEmpty()) {
            return $this->error('Your cart is empty. Please add items before checkout.', 400);
        }

        $validationErrors = [];
        $subtotal = 0;

        $items = $cart->items->map(function (CartItem $item) use (&$subtotal, &$validationErrors) {
            $product = $item->product;

            if (!$product->is_active) {
                $validationErrors[] = "'{$product->name}' is no longer available.";
                return null;
            }

            if ($product->stock < $item->quantity) {
                $validationErrors[] = "'{$product->name}' only has {$product->stock} unit(s) in stock.";
                return null;
            }

            $lineTotal = $product->price * $item->quantity;
            $subtotal += $lineTotal;

            return [
                'id'           => $item->id,
                'product_id'   => $product->id,
                'product_name' => $product->name,
                'image'        => $product->hasMedia('products')
                    ? url($product->getFirstMediaUrl('products', 'thumb'))
                    : 'https://placehold.co/150x150',
                'price'        => (float) $product->price,
                'quantity'     => (int) $item->quantity,
                'subtotal'     => (float) $lineTotal,
            ];
        })->filter()->values();

        if (!empty($validationErrors)) {
            return $this->error(implode(' ', $validationErrors), 422);
        }

        $shipping = 0;
        $discount = 0;
        $total    = $subtotal + $shipping - $discount;

        return $this->success([
            'items'    => $items,
            'subtotal' => (float) $subtotal,
            'shipping' => (float) $shipping,
            'discount' => (float) $discount,
            'total'    => (float) $total,
        ], 'Checkout summary ready');
    }
}

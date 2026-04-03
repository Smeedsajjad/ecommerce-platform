<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CartResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $totalItemsPrice = 0;

        $items = $this->items->map(function ($item) use (&$totalItemsPrice) {
            $productItem = $item->productItem;
            $product = $productItem->product;
            $subtotal = $productItem->price * $item->quantity;
            $totalItemsPrice += $subtotal;

            return [
                'id' => $item->id,
                'quantity' => $item->quantity,
                'subtotal' => $subtotal,
                'product_info' => [
                    'id' => $product->id,
                    'product_item_id' => $productItem->id,
                    'name' => $product->name,
                    'image' => $product->image_url,
                    'unit_price' => $productItem->price,
                    'sku' => $productItem->sku ?? null,
                    'variations' => $productItem->configurations->map(function ($config) {
                        return [
                            'variation' => $config->variationOption->variation->name,
                            'value' => $config->variationOption->value,
                        ];
                    }),
                ]
            ];
        });

        return [
            'id' => $this->id,
            'total_items_count' => $this->items->sum('quantity'),
            'total_price' => $totalItemsPrice,
            'items' => $items,
        ];
    }
}

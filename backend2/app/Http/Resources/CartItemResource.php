<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CartItemResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'product_id' => $this->product_id,
            'product_name' => $this->product->name,
            'image' => $this->product->hasMedia('products')
                ? url($this->product->getFirstMediaUrl('products', 'thumb'))
                : 'https://placehold.co/150x150',
            'price' => (float) $this->product->price,
            'quantity' => (int) $this->quantity,
            'subtotal' => (float) ($this->product->price * $this->quantity),
        ];
    }
}

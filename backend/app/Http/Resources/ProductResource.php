<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProductResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            "id" => $this->id,
            "name"=> $this->name,
            "slug"=> $this->slug,
            "description"=> $this->description,
            "category"=> $this->category->name,
            "first_image"=>$this->getFirstMediaUrl('product_images'),
            "all_images"=>$this->getMedia('product_images')->map(function ($media) {
                return $media->getFullUrl();
            }),
            "items" => $this->items->map(function ($item) {
                return [
                    "id" => $item->id,
                    "sku" => $item->sku,
                    "stock" => $item->stock,
                    "price" => $item->price,
                    "variations" => $item->configurations->map(function ($config) {
                        return [
                            "attribute" => $config->variationOption->variation->name,
                            "value" => $config->variationOption->value,
                        ];
                    }),
                ];
            }),
        ];
    }
}

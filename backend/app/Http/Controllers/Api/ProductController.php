<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ProductResource;
use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index()
    {
        $products = Product::with([
            'category',
            'media',
            'items.configurations.variationOption.variation.category'
        ])->latest()->paginate(20);

        return ProductResource::collection($products);
    }

    public function show($id)
    {
        $product = Product::with([
            'category',
            'media',
            'items.configurations.variationOption.variation.category'
        ])->findOrFail($id);

        return new ProductResource($product);
    }
}

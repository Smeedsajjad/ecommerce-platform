<?php

namespace App\Http\Controllers\Api;

use App\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Resources\ProductResource;
use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    use ApiResponse;

    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Product::with('category')->where('is_active', true);

        // Filter by category_id if provided
        if ($request->has('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        // Filter by category_slug if provided
        if ($request->has('category_slug')) {
            $query->whereHas('category', function ($q) use ($request) {
                $q->where('slug', $request->category_slug);
            });
        }

        // Search by name
        if ($request->has('search')) {
            $query->where('name', 'like', '%' . $request->search . '%');
        }

        // Sorting
        $sort = $request->query('sort', 'latest');
        if ($sort === 'price_low') {
            $query->orderBy('price', 'asc');
        } elseif ($sort === 'price_high') {
            $query->orderBy('price', 'desc');
        } else {
            $query->latest();
        }

        $products = $query->paginate($request->query('per_page', 15));

        return ProductResource::collection($products)->additional([
            'success' => true,
            'code' => 200,
            'message' => 'Products retrieved successfully'
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(Product $product)
    {
        if (!$product->is_active) {
            return $this->notFound('Product not found or inactive.');
        }

        return $this->success(new ProductResource($product->load('category')), 'Product retrieved successfully');
    }
}

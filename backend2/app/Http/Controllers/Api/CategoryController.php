<?php

namespace App\Http\Controllers\Api;

use App\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Resources\CategoryResource;
use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    use ApiResponse;

    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $categories = Category::where('is_active', true)
            ->latest()
            ->paginate($request->query('per_page', 15));

        return CategoryResource::collection($categories)->additional([
            'success' => true,
            'code' => 200,
            'message' => 'Categories retrieved successfully'
        ]);
    }

    /**
     * Display the specified resource.
     */
    public function show(Category $category)
    {
        if (!$category->is_active) {
            return $this->notFound('Category not found or inactive.');
        }

        return $this->success(new CategoryResource($category), 'Category retrieved successfully');
    }
}

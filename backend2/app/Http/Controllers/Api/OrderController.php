<?php

namespace App\Http\Controllers\Api;

use App\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Resources\OrderResource;
use App\Services\OrderService;
use Exception;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    use ApiResponse;

    protected $orderService;

    public function __construct(OrderService $orderService)
    {
        $this->orderService = $orderService;
    }

    public function index(Request $request)
    {
        $orders = $this->orderService->getUserOrders($request->user());
        return $this->success(OrderResource::collection($orders));
    }

    public function store(Request $request)
    {
        try {
            $order = $this->orderService->placeOrder($request->user());
            $order->load('items.product');
            return $this->created(new OrderResource($order), 'Order placed successfully');
        } catch (Exception $e) {
            return $this->error($e->getMessage(), $e->getCode() ?: 400);
        }
    }

    public function show($id, Request $request)
    {
        try {
            $order = $this->orderService->getOrderDetails($id, $request->user());
            return $this->success(new OrderResource($order));
        } catch (Exception $e) {
            return $this->error($e->getMessage(), $e->getCode() ?: 404);
        }
    }
}

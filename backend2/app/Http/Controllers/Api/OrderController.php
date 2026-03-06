<?php

namespace App\Http\Controllers\Api;

use App\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Resources\OrderResource;
use App\Services\OrderService;
use App\Models\Payment;
use Exception;
use Illuminate\Http\Request;
use Stripe\Stripe;
use Stripe\PaymentIntent;

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

    /**
     * Place an order and immediately create a Stripe PaymentIntent.
     * Returns the order details + client_secret for the Flutter app to open PaymentSheet.
     */
    public function store(Request $request)
    {
        try {
            $order = $this->orderService->placeOrder($request->user());
            $order->load('items.product');

            // Create Stripe PaymentIntent
            Stripe::setApiKey(config('services.stripe.secret'));

            $paymentIntent = PaymentIntent::create([
                'amount'   => (int) round($order->total_amount * 100),
                'currency' => 'usd',
                'metadata' => [
                    'order_id' => $order->id,
                    'user_id'  => $request->user()->id,
                ],
                'automatic_payment_methods' => [
                    'enabled' => true,
                ],
            ]);

            Payment::create([
                'order_id'       => $order->id,
                'transaction_id' => $paymentIntent->id,
                'payment_method' => 'stripe',
                'amount'         => $order->total_amount,
                'status'         => 'pending',
            ]);

            $order->load(['items.product', 'payment']);

            return $this->created([
                'order'         => new OrderResource($order),
                'client_secret' => $paymentIntent->client_secret,
                'payment_intent_id' => $paymentIntent->id,
            ], 'Order placed successfully');
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

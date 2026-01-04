<?php

namespace App\Http\Controllers\Api;

use App\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Resources\PaymentResource;
use App\Models\Order;
use App\Models\Payment;
use App\Services\PaymentService;
use Exception;
use Illuminate\Http\Request;

class PaymentController extends Controller
{
    use ApiResponse;

    protected $paymentService;

    public function __construct(PaymentService $paymentService)
    {
        $this->paymentService = $paymentService;
    }

    public function index(Request $request)
    {
        // Get all payments for the user's orders
        $payments = Payment::whereHas('order', function ($query) use ($request) {
            $query->where('user_id', $request->user()->id);
        })->orderBy('created_at', 'desc')->get();

        return $this->success(PaymentResource::collection($payments));
    }

    public function store(Request $request)
    {
        $request->validate([
            'order_id' => 'required|exists:orders,id',
            'payment_method' => 'required|string',
        ]);

        try {
            $user = $request->user();
            $order = Order::where('id', $request->order_id)
                ->where('user_id', $user->id)
                ->first();

            if (!$order) {
                return $this->notFound('Order not found');
            }

            $payment = $this->paymentService->processPayment($order, $request->payment_method);

            return $this->success(new PaymentResource($payment), 'Payment processed successfully');
        } catch (Exception $e) {
            $status = (int) $e->getCode();
            if ($status < 100 || $status > 599) {
                $status = 400;
            }
            return $this->error($e->getMessage(), $status);
        }
    }

    public function show($id, Request $request)
    {
        // Ensure user owns the payment's order
        $payment = Payment::where('id', $id)
            ->whereHas('order', function ($query) use ($request) {
                $query->where('user_id', $request->user()->id);
            })->first();

        if (!$payment) {
            return $this->notFound('Payment not found');
        }

        return $this->success(new PaymentResource($payment));
    }
}

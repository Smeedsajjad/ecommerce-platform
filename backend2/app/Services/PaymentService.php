<?php

namespace App\Services;

use App\Models\Order;
use App\Models\Payment;
use Exception;
use Illuminate\Support\Facades\DB;

class PaymentService
{
    /**
     * @throws Exception
     */
    public function processPayment(Order $order, string $paymentMethod)
    {
        if ($order->status === 'paid') {
            throw new Exception('Order is already paid', 400);
        }

        return DB::transaction(function () use ($order, $paymentMethod) {
            // Create Payment Record
            $payment = Payment::create([
                'order_id' => $order->id,
                'payment_method' => $paymentMethod,
                'amount' => $order->total_amount,
                'status' => 'pending',
                'transaction_id' => 'TXN_' . strtoupper(uniqid()),
            ]);

            // Mock Payment Gateway Logic
            $success = true; // Simulating successful payment

            if ($success) {
                $payment->update(['status' => 'completed']);
                $order->update(['status' => 'paid']);
            } else {
                $payment->update(['status' => 'failed']);
                throw new Exception('Payment failed', 400);
            }

            return $payment;
        });
    }
}

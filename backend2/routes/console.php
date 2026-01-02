<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

Artisan::command('debug:cart', function () {
    $user = \App\Models\User::find(5);
    $cart = \App\Models\Cart::find(3);
    $item = \App\Models\CartItem::find(6);

    $this->info("User 5 Matches: " . ($user ? $user->id : 'Not Found'));
    $this->info("Cart 3 Owner: " . ($cart ? $cart->user_id : 'Not Found'));
    $this->info("Item 6 Cart ID: " . ($item ? $item->cart_id : 'Not Found'));

    if ($cart && $user) {
        $this->info("Owner Check: " . ($cart->user_id == $user->id ? 'MATCH' : 'MISMATCH'));
    }
});

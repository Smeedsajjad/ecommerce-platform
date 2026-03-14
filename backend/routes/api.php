<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ForgotPasswordController;
use App\Http\Controllers\Api\GoogleAuthController;
use Illuminate\Support\Facades\Route;

Route::prefix("auth")->group(function () {
    Route::post("register", [AuthController::class, "register"]);
    Route::post("login", [AuthController::class, "login"]);

    Route::post('submit-forgot-password', [ForgotPasswordController::class, 'submitForgotPasswordByOtp']);
    Route::post('verify-forgot-password', [ForgotPasswordController::class, 'VerifyForgotPasswordOtp']);
    Route::post('reset-password', [ForgotPasswordController::class, 'ResetPasswordByOtp']);

    Route::post('google-login', [GoogleAuthController::class, 'redirect']);
    Route::get('google-callback', [GoogleAuthController::class, 'callback']);
    Route::post('google-mobile-login', [GoogleAuthController::class, 'handleMobileLogin']);

    Route::middleware('auth:api')->group(function () {
        Route::get('me', [AuthController::class, 'me']);
        Route::post('logout', [AuthController::class, 'logout']);
        Route::post('refresh', [AuthController::class, 'refresh']);
    });
});

// Example of Admin-only APIs
Route::middleware(['auth:api', 'admin'])->prefix('admin')->group(function () {
    // Route::apiResource('products', ProductController::class);
    // Route::delete('products/{product}', [ProductController::class, 'destroy']);
});
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ForgotPasswordOtp extends Model
{
    protected $fillable = [
        'email',
        'token',
        'otp',
        'expires_at',
    ];
}

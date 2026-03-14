<?php

namespace App\Http\Controllers\api;

use App\ApiResponse;
use App\Http\Controllers\Controller;
use App\Models\ForgotPasswordOtp;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;

class ForgotPasswordController extends Controller
{
    use ApiResponse;

    public function submitForgotPasswordByOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:users,email',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        try {
            $token = Str::random(64);
            $otp = rand(100000, 999999);
            
            // Delete old OTPs for this email to prevent spam and confusion
            ForgotPasswordOtp::where('email', $request->email)->delete();

            $forgotPasswordOtp = ForgotPasswordOtp::create([
                'email' => $request->email,
                'otp' => $otp,
                'token' => $token,
                'expires_at' => now()->addMinutes(10), // Set explicit expiration timestamp
            ]);

            // Send the beautiful formatted email
            Mail::to($request->email)->send(new \App\Mail\SendForgotPasswordOtpMail($otp));

            return $this->success([
                'token' => $token, // Send back token to client so they can send it in next steps
            ], 'OTP sent successfully to your email');

        } catch (\Throwable $th) {
            return $this->error('Failed to send OTP. Please check email setup.', 500, $th->getMessage());
        }
    }

    public function VerifyForgotPasswordOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:users,email',
            'token' => 'required|string',
            'otp' => 'required|numeric|digits:6',
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        try {
            $forgotOtp = ForgotPasswordOtp::where('email', $request->email)
                ->where('token', $request->token)
                ->first();

            if (!$forgotOtp) {
                return $this->notFound('Invalid request session. Please request a new OTP.');
            }

            // Check expiration using the saved timestamp
            if (now()->greaterThan($forgotOtp->expires_at)) {
                $forgotOtp->delete();
                return $this->error('OTP has expired. Please request a new one.', 400);
            }

            if ($forgotOtp->otp !== $request->otp) {
                return $this->error('Invalid OTP code.', 400);
            }

            return $this->success(null, 'OTP verified successfully. You can now reset your password.');

        } catch (\Throwable $th) {
            return $this->error('Failed to verify OTP', 500, $th->getMessage());
        }
    }

    public function ResetPasswordByOtp(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email' => 'required|email|exists:users,email',
            'token' => 'required|string',
            'new_password' => 'required|string|min:6|confirmed', // 'confirmed' expects 'new_password_confirmation' field
        ]);

        if ($validator->fails()) {
            return $this->validationError($validator->errors());
        }

        try {
            $forgotOtp = ForgotPasswordOtp::where('email', $request->email)
                ->where('token', $request->token)
                ->first();

            if (!$forgotOtp) {
                return $this->error('Invalid or expired request session.', 400);
            }

            // Update user password. Hash happens automatically due to User model casts
            $user = User::where('email', $request->email)->first();
            $user->password = $request->new_password; 
            $user->save();

            // Clean up old otps to prevent reuse
            ForgotPasswordOtp::where('email', $request->email)->delete();

            return $this->success(null, 'Your password has been changed successfully! You can now login.');

        } catch (\Throwable $th) {
            return $this->error('Failed to update password', 500, $th->getMessage());
        }
    }
}

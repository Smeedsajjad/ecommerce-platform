<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Exception;
use Illuminate\Http\Request;
use Laravel\Socialite\Facades\Socialite;

class GoogleAuthController extends Controller
{
    /**
     * Standard Web Redirect flow
     */
    public function redirect()
    {
        return Socialite::driver('google')->stateless()->redirect();
    }

    /**
     * Standard Web Callback flow
     */
    public function callback()
    {
        try {
            $socialUser = Socialite::driver('google')->stateless()->user();
            return $this->handleSocialUser('google', $socialUser);
        } catch (Exception $e) {
            return $this->error('Google authentication failed', 400, $e->getMessage());
        }
    }

    /**
     * Mobile specialized flow (Flutter sends the Google access_token directly)
     */
    public function handleMobileLogin(Request $request)
    {
        $request->validate(['access_token' => 'required|string']);

        try {
            $socialUser = Socialite::driver('google')->userFromToken($request->access_token);
            return $this->handleSocialUser('google', $socialUser);
        } catch (Exception $e) {
            return $this->error('Invalid Google token provided', 401, $e->getMessage());
        }
    }

    /**
     * Shared logic to create/update user and return JWT
     */
    protected function handleSocialUser($provider, $socialUser)
    {
        $user = User::updateOrCreate([
            'provider' => $provider,
            'provider_id' => $socialUser->getId(),
        ], [
            'name' => $socialUser->getName(),
            'email' => $socialUser->getEmail(),
            'provider_token' => $socialUser->token,
            'provider_refresh_token' => $socialUser->refreshToken ?? null,
            'email_verified_at' => now(), // Assume social emails are verified
        ]);

        // Generate JWT token for our Flutter app
        $token = auth('api')->login($user);

        return $this->respondWithToken($token, 'Successfully logged in with ' . ucfirst($provider));
    }
}

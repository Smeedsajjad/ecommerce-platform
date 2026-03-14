<?php

namespace App;

use Illuminate\Http\Resources\Json\JsonResource;
use Symfony\Component\HttpFoundation\JsonResponse;

trait ApiResponse
{
    /**
     * Return a success JSON response.
     *
     * @param  mixed  $data
     * @param  string  $message
     * @param  int  $status
     * @return JsonResponse
     */
    /**
     * Return a success JSON response.
     *
     * @param  mixed  $data
     * @param  string  $message
     * @param  int  $status
     * @return JsonResponse
     */
    protected function success($data = null, string $message = 'Success', int $status = 200): JsonResponse
    {
        $response = [
            'success' => true,
            'message' => $message,
        ];

        if ($data instanceof JsonResource) {
            // Handle pagination and resources
            $resourceData = $data->toResponse(request())->getData(true);

            if (isset($resourceData['data'])) {
                $response['data'] = $resourceData['data'];
                if (isset($resourceData['links']))
                    $response['links'] = $resourceData['links'];
                if (isset($resourceData['meta']))
                    $response['meta'] = $resourceData['meta'];
            } else {
                $response['data'] = $resourceData;
            }
        } else {
            $response['data'] = $data;
        }

        return response()->json($response, $status);
    }

    /**
     * Return a consistency-formatted token response.
     *
     * @param string $token
     * @param string $message
     * @return JsonResponse
     */
    protected function respondWithToken(string $token, string $message = 'Login successful'): JsonResponse
    {
        return $this->success([
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => auth('api')->factory()->getTTL() * 60,
            'user' => auth('api')->user(),
        ], $message);
    }

    /**
     * Return an error JSON response.
     *
     * @param  string  $message
     * @param  int  $status
     * @param  mixed  $errors
     * @return JsonResponse
     */
    protected function error(string $message = 'Error', int $status = 400, $errors = null): JsonResponse
    {
        return response()->json([
            'success' => false,
            'message' => $message,
            'errors' => $errors,
        ], $status);
    }

    /**
     * Return a validation error JSON response.
     *
     * @param  mixed  $errors
     * @param  string  $message
     * @return JsonResponse
     */
    protected function validationError($errors, string $message = 'Validation Error'): JsonResponse
    {
        return $this->error($message, 422, $errors);
    }

    protected function created($data = null, string $message = 'Resource created'): JsonResponse
    {
        return $this->success($data, $message, 201);
    }

    protected function notFound(string $message = 'Resource not found'): JsonResponse
    {
        return $this->error($message, 404);
    }

    protected function unauthorized(string $message = 'Unauthorized'): JsonResponse
    {
        return $this->error($message, 401);
    }

    protected function forbidden(string $message = 'Forbidden'): JsonResponse
    {
        return $this->error($message, 403);
    }
}

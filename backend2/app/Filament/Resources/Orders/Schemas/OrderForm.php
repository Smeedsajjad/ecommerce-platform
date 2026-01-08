<?php

namespace App\Filament\Resources\Orders\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;

class OrderForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Select::make('user_id')
                    ->relationship('user', 'name')
                    ->searchable()
                    ->preload()
                    ->required(),
                TextInput::make('total_amount')
                    ->required()
                    ->numeric()
                    ->prefix('$'),
                Select::make('status')
                    ->options([
                        'pending' => 'Pending',
                        'shipping' => 'Shipping',
                        'delivered' => 'Delivered',
                        'cancelled' => 'Cancelled',
                    ])
                    ->default('pending')
                    ->native(false)
                    ->required(),
            ]);
    }
}

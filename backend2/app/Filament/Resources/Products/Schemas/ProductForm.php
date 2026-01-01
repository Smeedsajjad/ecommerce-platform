<?php

namespace App\Filament\Resources\Products\Schemas;

use App\Models\Category;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\SpatieMediaLibraryFileUpload;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Components\Utilities\Set;
use Filament\Schemas\Schema;
use Illuminate\Support\Str;

class ProductForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('name')
                    ->required()
                    ->live(onBlur: true)
                    ->afterStateUpdated(function ($state, Set $set) {
                        $set('slug', Str::slug($state));
                    }),
                TextInput::make('slug')
                    ->disabled()
                    ->dehydrated()
                    ->unique(ignoreRecord: true),

                TextInput::make('price')
                    ->required()
                    ->numeric()
                    ->prefix('$'),

                Select::make('category_id')
                    ->label('Category')
                    ->relationship(
                        name: 'category',
                        titleAttribute: 'name',
                    )
                    ->native(false)
                    ->required(),

                SpatieMediaLibraryFileUpload::make('image')
                    ->label('Image')
                    ->image()
                    ->collection('products')
                    ->columnSpanFull()
                    ->multiple()
                    ->reorderable()
                    ->required(),

                Textarea::make('description')
                    ->columnSpanFull(),

                TextInput::make('stock')
                    ->required()
                    ->numeric(),
                Toggle::make('is_active')
                    ->required()
                    ->default(true),
            ]);
    }
}

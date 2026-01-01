<?php

namespace App\Filament\Resources\Categories\Schemas;

use Filament\Forms\Components\SpatieMediaLibraryFileUpload;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\ToggleButtons;
use Filament\Schemas\Components\Section;
use Filament\Schemas\Components\Utilities\Set;
use Filament\Schemas\Schema;
use Illuminate\Support\Str;

class CategoryForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make()
                    ->columnSpanFull()
                    ->schema([
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

                        SpatieMediaLibraryFileUpload::make('image')
                            ->label('Image')
                            ->image()
                            ->collection('categories')
                            ->required(),

                        ToggleButtons::make('is_active')
                            ->label('Status')
                            ->boolean()
                            ->grouped()
                            ->default(true),
                    ])->columnSpanFull(),

            ]);
    }
}

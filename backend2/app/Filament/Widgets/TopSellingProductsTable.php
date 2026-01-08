<?php

namespace App\Filament\Widgets;

use App\Models\Product;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;
use Filament\Widgets\TableWidget as BaseWidget;

class TopSellingProductsTable extends BaseWidget
{
    protected static ?int $sort = 5;

    protected int | string | array $columnSpan = 1;

    public function table(Table $table): Table
    {
        return $table
            ->query(
                Product::query()
                    ->select('products.*')
                    ->selectRaw('COALESCE(SUM(order_items.quantity), 0) as total_quantity')
                    ->selectRaw('COALESCE(SUM(order_items.quantity * order_items.price), 0) as total_revenue')
                    ->leftJoin('order_items', 'products.id', '=', 'order_items.product_id')
                    ->with('category')
                    ->groupBy('products.id')
                    ->orderByDesc('total_revenue')
                    ->limit(10)
            )
            ->heading('Top Selling Products')
            ->columns([
                TextColumn::make('name')
                    ->label('Product')
                    ->searchable()
                    ->sortable()
                    ->limit(30),

                TextColumn::make('category.name')
                    ->label('Category')
                    ->sortable()
                    ->searchable()
                    ->default('N/A'),

                TextColumn::make('total_quantity')
                    ->label('Qty Sold')
                    ->sortable()
                    ->alignCenter()
                    ->formatStateUsing(fn($state) => number_format($state)),

                TextColumn::make('total_revenue')
                    ->label('Revenue')
                    ->money('usd')
                    ->sortable()
                    ->alignEnd(),

                TextColumn::make('stock')
                    ->label('Stock')
                    ->sortable()
                    ->alignCenter()
                    ->badge()
                    ->color(fn(int $state): string => match (true) {
                        $state === 0 => 'danger',
                        $state < 10 => 'warning',
                        default => 'success',
                    }),
            ])
            ->defaultSort('total_revenue', 'desc');
    }
}

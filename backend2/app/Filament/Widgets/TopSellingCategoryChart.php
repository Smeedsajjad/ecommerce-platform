<?php

namespace App\Filament\Widgets;

use App\Models\OrderItem;
use Filament\Widgets\ChartWidget;
use Illuminate\Support\Facades\DB;

class TopSellingCategoryChart extends ChartWidget
{
    protected ?string $heading = 'Top Selling Categories';

    protected static ?int $sort = 3;

    protected int | string | array $columnSpan = 1;

    protected function getData(): array
    {
        $data = $this->getTopCategories();

        return [
            'datasets' => [
                [
                    'label' => 'Sales',
                    'data' => $data['sales'],
                    'backgroundColor' => [
                        'rgb(255, 99, 132)',
                        'rgb(54, 162, 235)',
                        'rgb(255, 205, 86)',
                        'rgb(75, 192, 192)',
                        'rgb(153, 102, 255)',
                    ],
                ],
            ],
            'labels' => $data['labels'],
        ];
    }

    protected function getType(): string
    {
        return 'pie';
    }

    private function getTopCategories(): array
    {
        $topCategories = OrderItem::join('products', 'order_items.product_id', '=', 'products.id')
            ->join('categories', 'products.category_id', '=', 'categories.id')
            ->select('categories.name', DB::raw('SUM(order_items.quantity * order_items.price) as total_sales'))
            ->groupBy('categories.id', 'categories.name')
            ->orderByDesc('total_sales')
            ->limit(5)
            ->get();

        return [
            'labels' => $topCategories->pluck('name')->toArray(),
            'sales' => $topCategories->pluck('total_sales')->map(fn($value) => round($value, 2))->toArray(),
        ];
    }
}

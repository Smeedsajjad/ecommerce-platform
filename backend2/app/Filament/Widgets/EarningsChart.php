<?php

namespace App\Filament\Widgets;

use App\Models\Order;
use Filament\Widgets\ChartWidget;

class EarningsChart extends ChartWidget
{
    protected ?string $heading = 'Monthly Earnings';

    protected static ?int $sort = 2;

    protected int | string | array $columnSpan = [
        'md' => 1,
        'xl' => 1,
    ];

    protected function getData(): array
    {
        $data = $this->getMonthlyEarnings();

        return [
            'datasets' => [
                [
                    'label' => 'Revenue',
                    'data' => $data['revenue'],
                    'borderColor' => 'rgb(59, 130, 246)',
                    'backgroundColor' => 'rgba(59, 130, 246, 0.1)',
                    'fill' => true,
                    'tension' => 0.4,
                ],
            ],
            'labels' => $data['labels'],
        ];
    }

    protected function getType(): string
    {
        return 'line';
    }

    protected function getOptions(): array
    {
        return [
            'plugins' => [
                'legend' => [
                    'display' => true,
                ],
            ],
            'scales' => [
                'y' => [
                    'beginAtZero' => true,
                    'ticks' => [
                        'callback' => 'function(value) { return "$" + value.toLocaleString(); }',
                    ],
                ],
            ],
        ];
    }

    private function getMonthlyEarnings(): array
    {
        $months = collect();
        $revenue = collect();

        for ($i = 11; $i >= 0; $i--) {
            $date = now()->subMonths($i);

            $monthRevenue = Order::whereMonth('created_at', $date->month)
                ->whereYear('created_at', $date->year)
                ->where('status', 'completed')
                ->sum('total_amount');

            $months->push($date->format('M Y'));
            $revenue->push(round($monthRevenue, 2));
        }

        return [
            'labels' => $months->toArray(),
            'revenue' => $revenue->toArray(),
        ];
    }
}

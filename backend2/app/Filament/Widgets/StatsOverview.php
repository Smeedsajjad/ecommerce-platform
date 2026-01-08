<?php

namespace App\Filament\Widgets;

use App\Models\Order;
use App\Models\User;
use Filament\Widgets\StatsOverviewWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class StatsOverview extends StatsOverviewWidget
{
    protected static ?int $sort = 1;

    protected int | string | array $columnSpan = 'full';

    protected function getStats(): array
    {
        return [
            // Total Customers Card
            Stat::make('Total Customers', $this->getTotalCustomers())
                ->description($this->getCustomerGrowth())
                ->descriptionIcon($this->getCustomerGrowthPercentage() >= 0 ? 'heroicon-m-arrow-trending-up' : 'heroicon-m-arrow-trending-down')
                ->chart($this->getCustomerChartData())
                ->color($this->getCustomerGrowthPercentage() >= 0 ? 'success' : 'danger'),

            // Total Revenue Card
            Stat::make('Total Revenue', '$' . number_format($this->getTotalRevenue(), 2))
                ->description($this->getRevenueGrowth())
                ->descriptionIcon($this->getRevenueGrowthPercentage() >= 0 ? 'heroicon-m-arrow-trending-up' : 'heroicon-m-arrow-trending-down')
                ->chart($this->getRevenueChartData())
                ->color($this->getRevenueGrowthPercentage() >= 0 ? 'success' : 'danger'),

            // Total Orders Card
            Stat::make('Total Orders', $this->getTotalOrders())
                ->description($this->getOrdersGrowth())
                ->descriptionIcon($this->getOrdersGrowthPercentage() >= 0 ? 'heroicon-m-arrow-trending-up' : 'heroicon-m-arrow-trending-down')
                ->chart($this->getOrdersChartData())
                ->color($this->getOrdersGrowthPercentage() >= 0 ? 'success' : 'danger'),

            // Average Order Value Card
            Stat::make('Average Order Value', '$' . number_format($this->getAverageOrderValue(), 2))
                ->description($this->getAvgOrderValueGrowth())
                ->descriptionIcon($this->getAvgOrderValueGrowthPercentage() >= 0 ? 'heroicon-m-arrow-trending-up' : 'heroicon-m-arrow-trending-down')
                ->chart($this->getAvgOrderValueChartData())
                ->color($this->getAvgOrderValueGrowthPercentage() >= 0 ? 'success' : 'danger'),
        ];
    }

    // Total Customers Methods
    private function getTotalCustomers(): int
    {
        return User::where('is_admin', false)
            ->whereMonth('created_at', now()->month)
            ->whereYear('created_at', now()->year)
            ->count();
    }

    private function getCustomerGrowthPercentage(): float
    {
        $currentMonth = User::where('is_admin', false)
            ->whereMonth('created_at', now()->month)
            ->whereYear('created_at', now()->year)
            ->count();

        $previousMonth = User::where('is_admin', false)
            ->whereMonth('created_at', now()->subMonth()->month)
            ->whereYear('created_at', now()->subMonth()->year)
            ->count();

        if ($previousMonth == 0) {
            return $currentMonth > 0 ? 100 : 0;
        }

        return (($currentMonth - $previousMonth) / $previousMonth) * 100;
    }

    private function getCustomerGrowth(): string
    {
        $percentage = $this->getCustomerGrowthPercentage();
        return ($percentage >= 0 ? '+' : '') . number_format($percentage, 1) . '% from last month';
    }

    private function getCustomerChartData(): array
    {
        return User::where('is_admin', false)
            ->selectRaw('DATE(created_at) as date, COUNT(*) as count')
            ->whereBetween('created_at', [now()->subDays(7), now()])
            ->groupBy('date')
            ->orderBy('date')
            ->pluck('count')
            ->toArray();
    }

    // Total Revenue Methods
    private function getTotalRevenue(): float
    {
        return Order::whereMonth('created_at', now()->month)
            ->whereYear('created_at', now()->year)
            ->where('status', 'completed')
            ->sum('total_amount');
    }

    private function getRevenueGrowthPercentage(): float
    {
        $currentMonth = Order::whereMonth('created_at', now()->month)
            ->whereYear('created_at', now()->year)
            ->where('status', 'completed')
            ->sum('total_amount');

        $previousMonth = Order::whereMonth('created_at', now()->subMonth()->month)
            ->whereYear('created_at', now()->subMonth()->year)
            ->where('status', 'completed')
            ->sum('total_amount');

        if ($previousMonth == 0) {
            return $currentMonth > 0 ? 100 : 0;
        }

        return (($currentMonth - $previousMonth) / $previousMonth) * 100;
    }

    private function getRevenueGrowth(): string
    {
        $percentage = $this->getRevenueGrowthPercentage();
        return ($percentage >= 0 ? '+' : '') . number_format($percentage, 1) . '% from last month';
    }

    private function getRevenueChartData(): array
    {
        return Order::where('status', 'completed')
            ->selectRaw('DATE(created_at) as date, SUM(total_amount) as total')
            ->whereBetween('created_at', [now()->subDays(7), now()])
            ->groupBy('date')
            ->orderBy('date')
            ->pluck('total')
            ->toArray();
    }

    // Total Orders Methods
    private function getTotalOrders(): int
    {
        return Order::whereMonth('created_at', now()->month)
            ->whereYear('created_at', now()->year)
            ->count();
    }

    private function getOrdersGrowthPercentage(): float
    {
        $currentMonth = Order::whereMonth('created_at', now()->month)
            ->whereYear('created_at', now()->year)
            ->count();

        $previousMonth = Order::whereMonth('created_at', now()->subMonth()->month)
            ->whereYear('created_at', now()->subMonth()->year)
            ->count();

        if ($previousMonth == 0) {
            return $currentMonth > 0 ? 100 : 0;
        }

        return (($currentMonth - $previousMonth) / $previousMonth) * 100;
    }

    private function getOrdersGrowth(): string
    {
        $percentage = $this->getOrdersGrowthPercentage();
        return ($percentage >= 0 ? '+' : '') . number_format($percentage, 1) . '% from last month';
    }

    private function getOrdersChartData(): array
    {
        return Order::selectRaw('DATE(created_at) as date, COUNT(*) as count')
            ->whereBetween('created_at', [now()->subDays(7), now()])
            ->groupBy('date')
            ->orderBy('date')
            ->pluck('count')
            ->toArray();
    }

    // Average Order Value Methods
    private function getAverageOrderValue(): float
    {
        $total = Order::whereMonth('created_at', now()->month)
            ->whereYear('created_at', now()->year)
            ->where('status', 'completed')
            ->sum('total_amount');

        $count = Order::whereMonth('created_at', now()->month)
            ->whereYear('created_at', now()->year)
            ->where('status', 'completed')
            ->count();

        return $count > 0 ? $total / $count : 0;
    }

    private function getAvgOrderValueGrowthPercentage(): float
    {
        $currentMonth = $this->getAverageOrderValue();

        $prevTotal = Order::whereMonth('created_at', now()->subMonth()->month)
            ->whereYear('created_at', now()->subMonth()->year)
            ->where('status', 'completed')
            ->sum('total_amount');

        $prevCount = Order::whereMonth('created_at', now()->subMonth()->month)
            ->whereYear('created_at', now()->subMonth()->year)
            ->where('status', 'completed')
            ->count();

        $previousMonth = $prevCount > 0 ? $prevTotal / $prevCount : 0;

        if ($previousMonth == 0) {
            return $currentMonth > 0 ? 100 : 0;
        }

        return (($currentMonth - $previousMonth) / $previousMonth) * 100;
    }

    private function getAvgOrderValueGrowth(): string
    {
        $percentage = $this->getAvgOrderValueGrowthPercentage();
        return ($percentage >= 0 ? '+' : '') . number_format($percentage, 1) . '% from last month';
    }

    private function getAvgOrderValueChartData(): array
    {
        $data = Order::where('status', 'completed')
            ->selectRaw('DATE(created_at) as date, AVG(total_amount) as avg')
            ->whereBetween('created_at', [now()->subDays(7), now()])
            ->groupBy('date')
            ->orderBy('date')
            ->pluck('avg')
            ->toArray();

        return array_map(fn($value) => round($value, 2), $data);
    }
}

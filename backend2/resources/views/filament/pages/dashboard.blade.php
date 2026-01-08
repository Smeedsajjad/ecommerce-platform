<x-filament-panels::page>
    <div class="grid grid-cols-1 gap-6">
        {{-- Top Stats Cards - 4 columns --}}
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            <x-filament-widgets::widget :widget="\App\Filament\Widgets\StatsOverview::class" />
        </div>

        {{-- Earnings Chart and Top Categories - 2 columns --}}
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <div class="lg:col-span-2">
                <x-filament-widgets::widget :widget="\App\Filament\Widgets\EarningsChart::class" />
            </div>
            <div class="lg:col-span-1">
                <x-filament-widgets::widget :widget="\App\Filament\Widgets\TopSellingCategoryChart::class" />
            </div>
        </div>

        {{-- Recent Orders and Top Products - 2 columns --}}
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <div>
                <x-filament-widgets::widget :widget="\App\Filament\Widgets\RecentOrdersTable::class" />
            </div>
            <div>
                <x-filament-widgets::widget :widget="\App\Filament\Widgets\TopSellingProductsTable::class" />
            </div>
        </div>
    </div>
</x-filament-panels::page>

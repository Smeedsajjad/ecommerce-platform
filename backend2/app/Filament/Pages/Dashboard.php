<?php

namespace App\Filament\Pages;

use Filament\Support\Icons\Heroicon;
use Filament\Pages\Dashboard as BaseDashboard;
use BackedEnum;

class Dashboard extends BaseDashboard
{
    protected static string|BackedEnum|null $navigationIcon = Heroicon::Home;
}

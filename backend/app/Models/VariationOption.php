<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

#[Fillable([
    'variation_id',
    'value',
])]
class VariationOption extends Model
{
    use HasFactory;

    public function variation()
    {
        return $this->belongsTo(Variation::class);
    }

    public function productConfigurations()
    {
        return $this->hasMany(ProductConfiguration::class);
    }
}

<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

#[Fillable([
    "product_item_id",
    "variation_option_id",
])]
class ProductConfiguration extends Model
{
    use HasFactory;

    public function productItem()
    {
        return $this->belongsTo(ProductItem::class);
    }
    
    public function variationOption()
    {
        return $this->belongsTo(VariationOption::class);
    }
}

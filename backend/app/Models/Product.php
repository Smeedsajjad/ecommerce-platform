<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;

class Product extends Model implements HasMedia
{
    /** @use HasFactory<\Database\Factories\ProductFactory> */
    use HasFactory;
    use InteractsWithMedia;

    protected $fillable = [
        'category_id',
        'name',
        'slug',
        'description',
    ];

    protected $appends = ['image_url', 'gallery'];

    protected $hidden = ['media'];

    public function getImageUrlAttribute()
    {
        $media = $this->getFirstMedia('product_images');
        return $media ? $media->getFullUrl() : null;
    }

    public function getGalleryAttribute()
    {
        return $this->getMedia('product_images')->map(function ($media) {
            return $media->getFullUrl();
        });
    }

    public function registerMediaCollections(): void
    {
        $this->addMediaCollection('product_images');
    }

    public function category()
    {
        return $this->belongsTo(Category::class);
    }

    public function items()
    {
        return $this->hasMany(ProductItem::class);
    }

}

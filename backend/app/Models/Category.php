<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Spatie\MediaLibrary\HasMedia;
use Spatie\MediaLibrary\InteractsWithMedia;

class Category extends Model implements HasMedia
{
    /** @use HasFactory<\Database\Factories\CategoryFactory> */
    use HasFactory;
    use InteractsWithMedia;

    protected $fillable = [
        'name',
        'slug',
        'is_active',
    ];

    protected $appends = ['image_url'];

    protected $hidden = ['media'];

    public function getImageUrlAttribute()
    {
        $media = $this->getFirstMedia('category_images');
        return $media ? $media->getFullUrl() : null;
    }

    public function registerMediaCollections(): void
    {
        $this->addMediaCollection('category_images')
            ->singleFile();
    }

    public function products()
    {
        return $this->hasMany(Product::class);
    }
}

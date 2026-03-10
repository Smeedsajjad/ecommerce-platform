# 🛒 Modern E-Commerce Platform

[![Laravel](https://img.shields.io/badge/Laravel-12.x-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)](https://laravel.com)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

A robust, full-stack e-commerce solution featuring a powerful **Laravel API & Admin Dashboard** and a sleek **Flutter Mobile Application**. This project is built as a comprehensive practice platform to master modern web and mobile development workflows.

---

## 🌟 Project Overview

This project serves as a complete blueprint for a modern e-commerce ecosystem. It handles everything from inventory management and order processing via the web dashboard to a seamless shopping experience on mobile devices.

### 🏗️ Architecture

- **Backend**: Laravel RESTful API serving as the central data hub.
- **Admin Panel**: Built with Laravel (Filament/Blade) for managing products, categories, orders, and users.
- **Mobile App**: Cross-platform Flutter application for iOS and Android.

---

## 🚀 Teck Stack

### **Backend (API & Admin)**

- **Framework**: [Laravel 12.x](https://laravel.com)
- **Database**: MySQL
- **Authentication**: [php-open-source-saver/jwt-auth](https://github.com/php-open-source-saver/jwt-auth)
- **Admin UI**: FilamentPHP
- **Storage**: Local Storage

### **Mobile Application**

- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: Riverpod
- **Networking**: Dio
- **Local Storage**: Secure Storage & Shared Preferences

---

## ✨ Features

### **Admin Dashboard (Laravel)**

- 📊 **Analytics Overview**: Sales, revenue, and user growth charts.
- 📦 **Product Management**: CRUD operations with multi-image support.
- 📂 **Category Management**: categories.
- 🛍️ **Order Management**: Track status (Pending, Shipping, Delivered).
- 👥 **User Management**: Role-based access control (Admin, Customer).

### **Mobile App (Flutter)**

- 📱 **Smooth UI/UX**: Modern design.
- 🔍 **Advanced Search**: Filter by categories, price range.
- 🛒 **Shopping Cart**: Real-time updates.
- 💳 **Secure Checkout**: Integration with Stripe.
- 👤 **UserProfile**: Order history, saved addresses, and account settings.

---

## 🛠️ Getting Started

### **Prerequisites**

- PHP >= 8.2 & Composer
- Node.js & NPM
- Flutter SDK
- MySQL
- Android Studio

### **Backend Setup**

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```
2. Install dependencies:
   ```bash
   composer install
   npm install && npm run build
   ```
3. Configure Environment:
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```
4. Run Migrations & Seeders:
   ```bash
   php artisan migrate --seed
   ```
5. Start the server:
   ```bash
   php artisan serve
   ```

### **Mobile Setup**

1. Navigate to the mobile directory:
   ```bash
   cd mobile_app
   ```
2. Get packages:
   ```bash
   flutter pub get
   ```
3. Update API URL in `.env` or config file to point to your local Laravel server.
4. Run the app:
   ```bash
   flutter run
   ```

---

## 📂 Project Structure

```text
.
├── backend/            # Laravel API & Admin Dashboard
│   ├── app/
│   ├── config/
│   ├── database/
│   └── ...
├── mobile/             # Flutter Mobile Application
│   ├── lib/
│   ├── assets/
│   ├── pubspec.yaml
│   └── ...
└── README.md
```

---

## 📸 Screenshots

|                               Customer App                               |                                Admin Dashboard                                |
| :----------------------------------------------------------------------: | :---------------------------------------------------------------------------: |
| ![Mobile Screenshot](https://via.placeholder.com/200x400?text=Mobile+UI) | ![Admin Screenshot](https://via.placeholder.com/400x200?text=Admin+Dashboard) |

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).

---

Developed with ❤️ for practice and learning.

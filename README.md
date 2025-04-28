# 🧩 Profile & Product Search App

This iOS application displays a user profile and integrates a product search feature. It is designed with a modern, responsive UI and allows users to explore products, reviews, followers, ads, and tags.

The project showcases architectural decisions, clean code practices, and real-world feature implementation using `UIKit`, `MVVM`, and protocol-oriented programming.

---

## 🚀 Features Implemented

### ✅ Core Requirements

- **User Profile Screen**
  - Displays user’s profile image and name

- **Profile Tabs**
  - Switch between: `Products`, `Reviews`, and `Followers`

- **Product List**
  - Product image
  - Name
  - Price
  - End date countdown (if available)
  - Special offer label (if available)

- **Search Functionality**
  - Search bar with keyword-based filtering for products

- **Additional Lists**
  - Horizontal list for ads
  - Tag collection view with selectable tags

- **Navigation**
  - `UITabBarController` with 5 main screens

---

## ⭐ Bonus Features

- ✅ Offline caching for products, user data, ads, and tags
- ✅ Dark Mode support
- ✅ Localization (multi-language support)
- ✅ Environment configuration support
- ✅ Unit test support for ViewModels
- ✅ Fully modularized & scalable architecture

---

## 🧱 Architecture & Tech Stack

- **UIKit**
- **MVVM + Protocol-Oriented Programming**
- **RxSwift & RxCocoa**
- **Offline caching** using file storage with generic services
- **SOLID principles** applied
- **Custom state management** for loading/error/success states
- **Clean & reusable components** following best practices

---

## 📦 Dependencies

> ⚠️ Please install the following dependencies before running the app.  
> I had some issues adding them in Xcode directly, so please add them manually if needed:

- [`RxDataSources`](https://github.com/RxSwiftCommunity/RxDataSources)
- [`Kingfisher`](https://github.com/onevcat/Kingfisher)

You can use Swift Package Manager (SPM) to add them manually:
1. Open **Xcode > File > Add Packages...**
2. Add:
   - `https://github.com/RxSwiftCommunity/RxDataSources`
   - `https://github.com/onevcat/Kingfisher`

# 🎮 Game Price Checker

A sleek and simple Flutter web app that helps you find the best deals on PC games across online storefronts. Search for your favorite games and track prices from multiple stores using the [CheapShark API](https://www.cheapshark.com/api). You can also add games to your wishlist for easy access later — all powered by Firebase Firestore.

## ▶️ [View the App](https://game-price-checker.web.app)

---

## ✨ Features

- 🔍 Search games by title
- 💰 View lowest current prices across supported platforms
- ❤️ Add games to a personal wishlist (stored in Firestore)
- 🎁 "Deal of the Moment" surprise offer from a random game
- ⚡ Fast, responsive UI optimized for web
- 🔄 Real-time wishlist updates using Firebase

---

## 🛠️ Tech Stack

- **Flutter Web**
- **CheapShark API** (game data and live deals)
- **Firebase Firestore** (wishlist database)
- **Firebase Hosting** (deployment)

---

## 📱 Best Viewed On

The app is fully responsive and works on both **mobile** and **desktop**, but is optimized for **mobile-first** viewing.

---

## 📂 How to Run Locally

```bash
git clone https://github.com/Nate-Heim/game_price_checker.git
cd game-price-checker
flutter pub get
flutter run -d chrome

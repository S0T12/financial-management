# 💰 Financial Management - مدیریت مالی

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-lightgrey.svg)

**A comprehensive personal finance management Flutter application optimized for Iranian users**

[Features](#-features) • [Quick Start](#-quick-start) • [Architecture](#-architecture) • [Documentation](#-documentation) • [Screenshots](#-screenshots)

</div>

---

## 🌟 Features

### 💳 Multi-Account Management

- Create unlimited accounts (personal, business, family, savings)
- Real-time balance tracking
- Beautiful gradient cards with custom colors
- Transfer money between accounts

### 📊 Smart Transaction Tracking

- Record income and expenses with 12+ categories
- Attach photos of receipts
- Add detailed notes
- Search and filter transactions
- View transaction history

### 📱 Automatic SMS Detection (Iranian Banks)

- **Intelligently parses SMS from 10+ major Iranian banks**
- Automatically extracts amount, account number, and balance
- Supports both Persian (۱۲۳) and English (123) digits
- Ignores small transactions (< 300,000 Rials)
- Prevents duplicate entries
- Works with: بانک ملی, بانک صادرات, بانک ملت, and more!

### 📈 Analytics & Reports

- Expense breakdown by category (pie charts)
- Spending trends over time (line charts)
- Monthly income vs expense reports
- Average daily/weekly spending
- Account balance history

### 🌍 Persian-First Design

- Full RTL (Right-to-Left) support
- Jalali (Solar Hijri) calendar
- Persian number formatting
- Bilingual: Persian (فارسی) + English
- Iranian bank SMS formats

### 🎨 Modern UI/UX

- Material Design 3
- Dark & Light themes
- Smooth animations
- Gradient cards
- Custom Persian font (Vazirmatn)
- Responsive layouts

### 🔒 Privacy & Security

- 100% offline - data never leaves your device
- Optional biometric authentication (planned)
- Local SQLite database
- No cloud sync required

---

## 🚀 Quick Start

### Prerequisites

- Flutter SDK 3.0+
- Dart SDK 3.0+

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/financial-management.git
cd financial-management

# 2. Install dependencies
flutter pub get

# 3. Generate code (database, providers, etc.)
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run the app
flutter run
```

**That's it! 🎉** The app will launch on your connected device or emulator.

---

## 🏗️ Architecture

Built with **Clean Architecture** and **SOLID principles**:

```
┌─────────────────────────────────────┐
│     Presentation Layer (UI)        │
│   • Screens, Widgets, ViewModels   │
│   • Riverpod State Management      │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│     Domain Layer (Business)         │
│   • Entities, Use Cases             │
│   • Repository Interfaces           │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│     Data Layer (Storage)            │
│   • Drift Database, SMS Parser      │
│   • Repository Implementations      │
└─────────────────────────────────────┘
```

### Tech Stack

- **State Management**: Riverpod (Provider + StateNotifier)
- **Database**: Drift (Type-safe SQLite)
- **Dependency Injection**: get_it + Riverpod
- **Charts**: fl_chart
- **Localization**: Custom i18n with JSON
- **Date**: shamsi_date (Jalali calendar)
- **SMS**: telephony plugin

---

## 📚 Documentation

Comprehensive documentation available in the `/docs` folder:

- **[Quick Start Guide](docs/QUICK_START.md)** - Get started in 5 minutes
- **[Features Overview](docs/FEATURES.md)** - Complete feature list
- **[Architecture Guide](docs/ARCHITECTURE.md)** - Deep dive into app structure
- **[Development Guide](docs/DEVELOPMENT_GUIDE.md)** - Contributing and development workflow
- **[SMS Parser Examples](docs/SMS_PARSER_EXAMPLES.md)** - Iranian bank SMS formats

---

## 🎯 Project Structure

```
lib/
├── core/                      # Core utilities
│   ├── constants/            # App constants, enums
│   ├── error/                # Error handling
│   ├── localization/         # i18n support
│   ├── theme/                # App theming
│   ├── usecases/             # Base use case
│   └── utils/                # Helper functions
│
├── data/                      # Data layer
│   ├── datasources/          # Database tables & DAOs
│   ├── repositories/         # Repository implementations
│   └── services/             # SMS parser service
│
├── domain/                    # Business logic
│   ├── entities/             # Core entities
│   ├── repositories/         # Repository interfaces
│   └── usecases/             # Business use cases
│
├── presentation/              # UI layer
│   ├── providers/            # Riverpod providers
│   ├── screens/              # Full-page screens
│   ├── viewmodels/           # State management
│   └── widgets/              # Reusable UI components
│
└── main.dart                 # App entry point
```

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test
flutter test test/data/services/sms_parser_service_test.dart
```

**Test Coverage:**

- ✅ SMS Parser (Iranian bank formats)
- ✅ Date/Time utilities
- ✅ Number formatting
- ✅ Use cases
- ✅ Repositories

---

## 🎨 Screenshots

> Coming soon! Screenshots of dashboard, transactions, reports, and more.

---

## 🛣️ Roadmap

### ✅ Version 1.0 (Current)

- [x] Multi-account management
- [x] Transaction tracking
- [x] SMS auto-detection
- [x] Basic analytics
- [x] Persian localization
- [x] Dark/Light themes

### 🔜 Version 1.1 (Next)

- [ ] Budget planning with limits
- [ ] Recurring transactions
- [ ] Biometric authentication
- [ ] Export to PDF/Excel
- [ ] Home screen widgets

### 💡 Version 2.0 (Future)

- [ ] Multi-currency support
- [ ] AI-powered insights
- [ ] Cloud backup (optional)
- [ ] Multi-user/family accounts
- [ ] Bank API integration

---

## 🤝 Contributing

Contributions are welcome! Please read our [Development Guide](docs/DEVELOPMENT_GUIDE.md) first.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Iranian banks for their SMS formats
- Flutter team for the amazing framework
- Riverpod for excellent state management
- Drift for type-safe database access
- Persian community for localization support

---

## 📧 Contact

For questions, suggestions, or bug reports:

- Open an issue on GitHub
- Check the [documentation](docs/)

---

<div align="center">

**Made with ❤️ for smart financial management**

**ساخته شده با عشق برای مدیریت هوشمند مالی**

[⬆ Back to Top](#-financial-management---مدیریت-مالی)

</div>

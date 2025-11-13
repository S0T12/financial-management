# Features Overview

Complete list of features in the Financial Management application.

## ✅ Core Features

### 1. Account Management

- **Multiple Accounts**: Create unlimited accounts for different purposes
  - Personal accounts
  - Business accounts
  - Family shared accounts
  - Savings accounts
- **Account Types**: Visual distinction with icons and colors
- **Balance Tracking**: Real-time balance updates for each account
- **Account Details**: Add descriptions and custom colors
- **Total Balance**: View combined balance across all accounts

### 2. Transaction Management

- **Income & Expense Tracking**: Record all financial transactions
- **Transaction Categories**:
  - 🍔 Food & Drinks
  - 🚗 Transport
  - 🛍️ Shopping
  - 🎬 Entertainment
  - 🏥 Health
  - 📚 Education
  - 📄 Bills
  - 💰 Salary
  - 💼 Business
  - 📈 Investment
  - 🎁 Gift
  - ⚡ Other
- **Transaction Details**:
  - Amount (in Rials)
  - Type (Income/Expense)
  - Category
  - Date & Time
  - Optional note
  - Optional receipt photo
- **Transaction History**: Browse all past transactions
- **Search & Filter**: Find transactions by:
  - Account
  - Category
  - Date range
  - Type
  - Amount
  - Keywords in notes

### 3. Money Transfers

- **Inter-Account Transfers**: Move money between your accounts
- **Transfer History**: Track all transfers
- **Balance Sync**: Automatic balance updates on both accounts
- **Transfer Notes**: Add purpose/reason for transfer

### 4. Automatic SMS Detection 🎯

- **Smart SMS Parser**: Automatically detects Iranian bank SMS
- **Supported Banks** (10+ major banks):
  - بانک ملی Iran (Bank Melli)
  - بانک صادرات (Bank Saderat)
  - بانک ملت (Bank Mellat)
  - بانک پاسارگاد (Bank Pasargad)
  - بانک تجارت (Bank Tejarat)
  - بانک سپه (Bank Sepah)
  - بانک پارسیان (Bank Parsian)
  - بانک کشاورزی (Bank Keshavarzi)
  - بانک مسکن (Bank Maskan)
  - بانک سامان (Bank Saman)
- **Intelligent Parsing**:
  - Extracts amount
  - Detects transaction type (income/expense)
  - Reads account number
  - Gets remaining balance
  - Parses date and time
- **Duplicate Prevention**: Won't add same SMS twice
- **Minimum Amount Filter**: Ignores transactions < 300,000 Rials
- **Persian & English Digits**: Handles both ۱۲۳ and 123
- **Offline Support**: Manual entry when SMS not available

### 5. Analytics & Reports 📊

- **Dashboard Overview**:
  - Total balance
  - Monthly income
  - Monthly expenses
  - Recent transactions
- **Expense Breakdown**:
  - Pie chart by category
  - Percentage breakdown
  - Transaction count per category
- **Spending Trends**:
  - Line chart over time
  - Daily/weekly/monthly views
  - Compare periods
- **Monthly Reports**:
  - Total income vs expenses
  - Net savings
  - Category breakdown
  - Average daily spending
  - Spending patterns
- **Account Balance History**:
  - Track balance changes over time
  - Visualize growth or decline

### 6. Localization & Internationalization 🌍

- **Bilingual Support**:
  - Persian (فارسی) - Primary
  - English - Secondary
- **RTL Layout**: Full right-to-left support for Persian
- **Jalali Calendar**:
  - Solar Hijri dates
  - Persian date picker
  - Jalali to Gregorian conversion
- **Persian Number Formatting**:
  - Persian digits (۰۱۲۳۴۵۶۷۸۹)
  - Thousand separators (،)
  - Proper currency formatting
- **Cultural Adaptations**:
  - Iranian bank formats
  - Local currency (Rial)
  - Persian typography

### 7. User Interface 🎨

- **Material Design 3**: Modern, clean interface
- **Custom Theme**:
  - Primary: Indigo (#6366F1)
  - Secondary: Purple (#8B5CF6)
  - Accent: Pink (#EC4899)
- **Dark & Light Modes**: System-adaptive or manual toggle
- **Gradient Cards**: Beautiful account and balance cards
- **Icon System**: Intuitive icons for categories and actions
- **Smooth Animations**: Polished transitions and loading states
- **Responsive Layout**: Works on all screen sizes
- **Custom Fonts**: Vazirmatn for Persian text

### 8. Data Management

- **Local Database**: Drift (SQLite) for fast, reliable storage
- **Offline-First**: Works without internet connection
- **Data Persistence**: All data saved locally
- **Foreign Key Constraints**: Data integrity protection
- **Cascade Deletes**: Clean up related data automatically
- **Indexed Queries**: Fast search and filtering

## 🔜 Planned Features (Future Releases)

### Budget Planning

- Set monthly spending limits by category
- Get alerts when approaching limit
- Visual progress bars
- Budget vs actual comparison

### Recurring Transactions

- Auto-add monthly bills
- Subscription tracking
- Recurring income (salary, rent)
- Custom repeat patterns

### Advanced Analytics

- Spending insights (AI-powered)
- Unusual transaction detection
- Savings goals tracking
- Net worth calculation
- Financial health score

### Data Export & Backup

- Export to PDF reports
- Export to Excel/CSV
- Automatic local backups
- Optional cloud backup (encrypted)
- Import from CSV

### Security & Privacy

- Biometric authentication (fingerprint, face ID)
- PIN protection
- Auto-lock timer
- Transaction privacy mode
- Data encryption

### Enhanced UI/UX

- Home screen widgets
- Quick transaction shortcuts
- Swipe actions
- Drag & drop for transfers
- Transaction templates
- Bulk operations

### Multi-Currency Support

- Add foreign currencies
- Exchange rate tracking
- Multi-currency accounts
- Currency conversion

### Attachments & Receipts

- Photo capture
- Image gallery
- PDF attachments
- Cloud storage integration
- OCR for receipt scanning

### Sharing & Collaboration

- Share reports
- Family accounts (multi-user)
- Split expenses
- Shared budgets

### Notifications

- Daily spending summary
- Budget alerts
- Bill reminders
- Savings milestones

### Advanced Reporting

- Custom date ranges
- Comparison reports
- Tax preparation reports
- Year-end summary
- Export templates

### Integration

- Bank API connections (future)
- Calendar integration
- Contact integration for payees

## 🏗️ Technical Features

### Architecture

- ✅ Clean Architecture
- ✅ SOLID Principles
- ✅ MVVM Pattern
- ✅ Repository Pattern
- ✅ Use Case Pattern

### State Management

- ✅ Riverpod (Provider + StateNotifier)
- ✅ Reactive state updates
- ✅ Provider composition
- ✅ Dependency injection

### Testing

- ✅ Unit tests
- ✅ Widget tests
- ✅ Repository tests
- ✅ SMS parser tests
- ✅ Use case tests

### Performance

- ✅ Lazy loading
- ✅ Pagination support
- ✅ Database indexing
- ✅ Efficient queries
- ✅ Minimal rebuilds

### Code Quality

- ✅ Linting rules
- ✅ Code formatting
- ✅ Documentation
- ✅ Type safety
- ✅ Error handling

## 📦 Dependencies

### Core

- Flutter SDK 3.0+
- Dart 3.0+

### State Management

- flutter_riverpod
- riverpod_annotation

### Database

- drift
- sqlite3_flutter_libs

### UI & Design

- Material 3
- fl_chart
- shimmer
- lottie

### Localization

- intl
- shamsi_date
- persian_number_utility
- persian_datetime_picker

### Utilities

- equatable
- uuid
- dartz
- path_provider

### Platform

- telephony (SMS access)
- permission_handler
- image_picker
- local_auth

---

## 🎯 Feature Priorities

### Must Have (Implemented ✅)

- [x] Multiple accounts
- [x] Transaction tracking
- [x] SMS parsing
- [x] Basic analytics
- [x] Persian localization
- [x] Dark/light theme

### Should Have (Next Release 🔜)

- [ ] Budget planning
- [ ] Recurring transactions
- [ ] Biometric auth
- [ ] Export reports
- [ ] Widgets

### Nice to Have (Future 💡)

- [ ] Multi-currency
- [ ] Cloud backup
- [ ] AI insights
- [ ] Multi-user support
- [ ] Bank API integration

---

Made with ❤️ for smart financial management

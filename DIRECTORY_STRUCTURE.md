# Directory Structure

Complete file tree of the Financial Management application.

```
financial-management/
│
├── 📁 assets/
│   ├── 📁 fonts/                      # Persian fonts (Vazirmatn)
│   ├── 📁 images/                     # App images and icons
│   ├── 📁 animations/                 # Lottie animations
│   └── 📁 localization/
│       ├── fa.json                    # Persian translations ✅
│       └── en.json                    # English translations ✅
│
├── 📁 docs/
│   ├── QUICK_START.md                 # 5-minute setup guide ✅
│   ├── FEATURES.md                    # Complete feature list ✅
│   ├── ARCHITECTURE.md                # Architecture deep dive ✅
│   ├── DEVELOPMENT_GUIDE.md           # Developer handbook ✅
│   └── SMS_PARSER_EXAMPLES.md         # Bank SMS examples ✅
│
├── 📁 lib/
│   │
│   ├── 📁 core/                       # Core utilities
│   │   │
│   │   ├── 📁 constants/
│   │   │   ├── app_constants.dart     # App-wide constants ✅
│   │   │   └── category_constants.dart # Categories & account types ✅
│   │   │
│   │   ├── 📁 error/
│   │   │   ├── failures.dart          # Failure classes ✅
│   │   │   └── exceptions.dart        # Exception classes ✅
│   │   │
│   │   ├── 📁 localization/
│   │   │   └── app_localizations.dart # i18n helper ✅
│   │   │
│   │   ├── 📁 theme/
│   │   │   └── app_theme.dart         # Theme configuration ✅
│   │   │
│   │   ├── 📁 usecases/
│   │   │   └── usecase.dart           # Base use case interface ✅
│   │   │
│   │   └── 📁 utils/
│   │       └── date_time_utils.dart   # Date & number utilities ✅
│   │
│   ├── 📁 data/                       # Data layer
│   │   │
│   │   ├── 📁 datasources/
│   │   │   └── 📁 local/
│   │   │       ├── app_database.dart  # Database config ✅
│   │   │       └── 📁 tables/
│   │   │           ├── accounts_table.dart      # Accounts table ✅
│   │   │           ├── transactions_table.dart  # Transactions table ✅
│   │   │           └── transfers_table.dart     # Transfers table ✅
│   │   │
│   │   ├── 📁 repositories/
│   │   │   ├── account_repository_impl.dart     # Account repo impl ✅
│   │   │   └── transaction_repository_impl.dart # Transaction repo impl ✅
│   │   │
│   │   └── 📁 services/
│   │       └── sms_parser_service.dart          # SMS parsing logic ✅
│   │
│   ├── 📁 domain/                     # Business logic layer
│   │   │
│   │   ├── 📁 entities/
│   │   │   ├── account.dart           # Account entity ✅
│   │   │   ├── transaction.dart       # Transaction entity ✅
│   │   │   ├── transfer.dart          # Transfer entity ✅
│   │   │   └── report.dart            # Report entities ✅
│   │   │
│   │   ├── 📁 repositories/
│   │   │   ├── account_repository.dart      # Account repo interface ✅
│   │   │   ├── transaction_repository.dart  # Transaction repo interface ✅
│   │   │   ├── transfer_repository.dart     # Transfer repo interface ✅
│   │   │   └── report_repository.dart       # Report repo interface ✅
│   │   │
│   │   └── 📁 usecases/
│   │       ├── get_all_accounts.dart        # Get accounts use case ✅
│   │       ├── create_account.dart          # Create account use case ✅
│   │       ├── create_transaction.dart      # Create transaction use case ✅
│   │       ├── get_recent_transactions.dart # Get transactions use case ✅
│   │       ├── get_monthly_report.dart      # Get report use case ✅
│   │       └── create_transfer.dart         # Create transfer use case ✅
│   │
│   ├── 📁 presentation/               # UI layer
│   │   │
│   │   ├── 📁 providers/
│   │   │   └── app_providers.dart     # Riverpod providers ✅
│   │   │
│   │   ├── 📁 viewmodels/
│   │   │   └── dashboard_viewmodel.dart     # Dashboard ViewModel ✅
│   │   │
│   │   ├── 📁 screens/
│   │   │   └── dashboard_screen.dart        # Dashboard screen ✅
│   │   │
│   │   └── 📁 widgets/
│   │       ├── account_card.dart            # Account card widget ✅
│   │       ├── balance_card.dart            # Balance card widget ✅
│   │       └── transaction_list_item.dart   # Transaction item widget ✅
│   │
│   └── main.dart                      # App entry point ✅
│
├── 📁 test/                           # Tests
│   ├── 📁 core/
│   │   └── 📁 utils/
│   │       └── date_time_utils_test.dart    # Utility tests ✅
│   │
│   └── 📁 data/
│       └── 📁 services/
│           └── sms_parser_service_test.dart # SMS parser tests ✅
│
├── .gitignore                         # Git ignore rules ✅
├── analysis_options.yaml              # Lint rules ✅
├── pubspec.yaml                       # Dependencies ✅
├── README.md                          # Main documentation ✅
└── PROJECT_SUMMARY.md                 # Project overview ✅
```

---

## 📊 File Count Summary

### Production Code

- **Core Layer:** 8 files
- **Data Layer:** 6 files
- **Domain Layer:** 10 files
- **Presentation Layer:** 6 files
- **Main:** 1 file
- **Total:** **31 production files**

### Configuration & Assets

- **Assets:** 2 files (localization)
- **Configuration:** 3 files (pubspec, analysis, gitignore)
- **Total:** **5 configuration files**

### Documentation

- **Docs:** 5 comprehensive guides
- **README:** 1 main documentation
- **Summary:** 1 project overview
- **Total:** **7 documentation files**

### Tests

- **Unit Tests:** 2 test files
- **Total:** **2 test files**

### Grand Total

**45 files** created for a complete, production-ready application

---

## 🎯 Key Directories Explained

### `/lib/core/`

Contains shared utilities, constants, and base classes used across the application.

- Independent of business logic
- Reusable across features
- No external dependencies

### `/lib/domain/`

Pure business logic layer - no Flutter dependencies.

- Entities: Core data structures
- Repositories: Abstract interfaces
- Use Cases: Business operations
- Platform-independent

### `/lib/data/`

Data access and external concerns.

- Database implementation (Drift)
- SMS parsing service
- Repository implementations
- Converts between data models and entities

### `/lib/presentation/`

UI and user interaction layer.

- Screens: Full-page views
- Widgets: Reusable components
- ViewModels: State management
- Providers: Dependency injection

### `/assets/`

Static resources.

- Fonts: Vazirmatn for Persian
- Images: Icons and graphics
- Localization: Translation files
- Animations: Lottie files

### `/docs/`

Comprehensive documentation.

- Quick start guide
- Feature documentation
- Architecture explanation
- Development guidelines
- SMS examples

### `/test/`

Automated tests.

- Unit tests for business logic
- Widget tests for UI
- Integration tests for flows

---

## 📦 Generated Files (Not in Repo)

These files are generated by `build_runner` and ignored by git:

```
lib/
├── data/
│   └── datasources/
│       └── local/
│           └── app_database.g.dart    # Generated by Drift
│
└── presentation/
    └── providers/
        └── app_providers.g.dart       # Generated by Riverpod
```

To generate these files:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🎨 Code Organization Principles

### 1. **Feature-First Structure**

Files grouped by feature rather than type where beneficial.

### 2. **Clear Separation of Concerns**

Each layer has distinct responsibilities:

- Core: Shared utilities
- Domain: Business rules
- Data: Data access
- Presentation: UI

### 3. **Dependency Rule**

Dependencies point inward:

```
Presentation → Domain → Core
     ↓            ↑
   Data ─────────┘
```

### 4. **Single Responsibility**

Each file has one clear purpose and reason to change.

### 5. **Testability**

Structure enables easy unit testing at every layer.

---

## 🔍 Finding Files Quickly

### By Feature

- **Accounts:** `domain/entities/account.dart`, `domain/repositories/account_repository.dart`, `domain/usecases/*account*.dart`
- **Transactions:** `domain/entities/transaction.dart`, `domain/repositories/transaction_repository.dart`
- **Reports:** `domain/entities/report.dart`, `domain/repositories/report_repository.dart`

### By Layer

- **Business Logic:** `/lib/domain/`
- **Data Access:** `/lib/data/`
- **User Interface:** `/lib/presentation/`
- **Shared Code:** `/lib/core/`

### By Type

- **Entities:** `/lib/domain/entities/`
- **Use Cases:** `/lib/domain/usecases/`
- **Repositories:** `/lib/domain/repositories/` (interfaces), `/lib/data/repositories/` (implementations)
- **UI Screens:** `/lib/presentation/screens/`
- **Widgets:** `/lib/presentation/widgets/`

---

## 🎓 Navigation Tips

1. **Start with Domain Layer** when understanding business logic
2. **Check Use Cases** to see available operations
3. **View Entities** to understand data structures
4. **Explore Presentation** for UI implementation
5. **Read Tests** for usage examples

---

_This structure supports a scalable, maintainable, and testable codebase._

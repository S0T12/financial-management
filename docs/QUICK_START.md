# Quick Start Guide

Get your Financial Management app up and running in minutes!

## ⚡ Quick Setup (5 minutes)

### 1. Install Flutter

```bash
# Verify Flutter installation
flutter doctor
```

### 2. Get Dependencies

```bash
cd financial-management
flutter pub get
```

### 3. Generate Code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Run the App

```bash
flutter run
```

That's it! 🎉

---

## 📱 First Time Using the App

### Step 1: Create Your First Account

1. Open the app
2. Tap the **"Add Account"** button
3. Fill in:
   - Account name (e.g., "Personal Wallet")
   - Account type (Personal, Business, Family, Savings)
   - Initial balance (optional)
4. Tap **"Save"**

### Step 2: Add Your First Transaction

1. Tap the **floating "+" button**
2. Select transaction type (Income or Expense)
3. Fill in:
   - Amount
   - Category
   - Date/Time
   - Note (optional)
4. Tap **"Save"**

### Step 3: Enable SMS Auto-Detection (Optional)

1. Go to **Settings**
2. Enable **"SMS Sync"**
3. Grant SMS permission
4. The app will automatically detect bank transactions from SMS!

---

## 🎯 Key Features to Try

### ✅ Multi-Account Management

- Create separate accounts for personal, business, and family finances
- Track balance for each account independently
- Transfer money between accounts

### ✅ Automatic SMS Detection

- Automatically reads Iranian bank SMS messages
- Extracts amount, account, and balance
- Ignores transactions below 300,000 Rials
- Supports 10+ major Iranian banks

### ✅ Smart Analytics

- Expense breakdown by category (pie chart)
- Spending trends over time (line chart)
- Monthly/weekly/daily spending averages
- Account balance history

### ✅ Persian Support

- Full RTL layout support
- Jalali calendar
- Persian number formatting
- Bilingual (Persian/English)

---

## 🏦 Supported Banks

The SMS parser automatically detects transactions from:

- بانک ملی (Bank Melli)
- بانک صادرات (Bank Saderat)
- بانک ملت (Bank Mellat)
- بانک پاسارگاد (Bank Pasargad)
- بانک تجارت (Bank Tejarat)
- بانک سپه (Bank Sepah)
- بانک پارسیان (Bank Parsian)
- بانک سامان (Bank Saman)
- And more...

---

## 💡 Pro Tips

### Tip 1: Categorize Your Expenses

Use categories to understand where your money goes:

- 🍔 Food & Drinks
- 🚗 Transport
- 🛍️ Shopping
- 🎬 Entertainment
- 🏥 Health
- 📚 Education
- 📄 Bills
- And more...

### Tip 2: Add Notes

Add notes to transactions for better tracking:

- "Grocery shopping at Hyperstar"
- "Monthly rent payment"
- "Birthday gift for mom"

### Tip 3: Attach Receipts

Take photos of receipts and attach them to transactions for record-keeping.

### Tip 4: Review Monthly Reports

Check your monthly report to:

- See spending patterns
- Identify areas to save
- Track financial goals

### Tip 5: Set Budget Limits (Coming Soon)

Plan your monthly spending by category to stay on track.

---

## 🔒 Privacy & Security

- ✅ **100% Offline** - All data stored locally on your device
- ✅ **No Cloud Sync** - Your financial data never leaves your phone
- ✅ **Optional Biometric Lock** - Secure the app with fingerprint/face
- ✅ **SMS Permission** - Only used for reading bank SMS (never shared)

---

## 🆘 Troubleshooting

### SMS Not Being Detected?

1. Check SMS permission is granted
2. Make sure SMS contains amount and bank name
3. Transaction must be above 300,000 Rials
4. Try manually adding the transaction

### App Crashes on Startup?

```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### Database Issues?

- Clear app data and restart
- Or reinstall the app (will lose data)

---

## 📚 Learn More

- [Architecture Overview](ARCHITECTURE.md)
- [Development Guide](DEVELOPMENT_GUIDE.md)
- [SMS Parser Examples](SMS_PARSER_EXAMPLES.md)

---

## 🚀 What's Next?

### Upcoming Features

- [ ] Budget planner with spending limits
- [ ] Recurring transactions
- [ ] Multi-currency support
- [ ] Export to PDF/Excel
- [ ] Cloud backup (optional)
- [ ] Widgets for quick access
- [ ] Smart spending insights

---

## 💬 Need Help?

- Check the documentation in `/docs`
- Review test examples in `/test`
- Open an issue on GitHub

---

## 🌟 Enjoy Managing Your Finances!

Made with ❤️ for Iranian users

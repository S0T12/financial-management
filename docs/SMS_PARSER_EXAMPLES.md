# SMS Parser Examples

This document contains examples of Iranian bank SMS messages and how they are parsed.

## Bank Melli (بانک ملی)

### Example 1: Expense Transaction

```
بانك ملي ايران
انتقال:1,209,000-
حساب:61006
مانده:71,144,085
0822-12:34
```

**Parsed Result:**

- Amount: 1,209,000 Rials
- Type: Expense
- Account: 61006
- Balance: 71,144,085 Rials
- Bank: بانک ملی
- Date/Time: August 22, 12:34

### Example 2: Income Transaction

```
بانك ملي ايران
واریز:2,500,000+
حساب:61006
مانده:73,644,085
0823-09:15
```

**Parsed Result:**

- Amount: 2,500,000 Rials
- Type: Income
- Account: 61006
- Balance: 73,644,085 Rials

## Bank Saderat (بانک صادرات)

```
بانک صادرات ایران
برداشت:450,000-
کارت:6037991234567890
مانده:3,250,000
1402/08/23-14:20
```

**Parsed Result:**

- Amount: 450,000 Rials
- Type: Expense
- Account: 6037991234567890
- Balance: 3,250,000 Rials
- Bank: بانک صادرات

## Bank Mellat (بانک ملت)

```
بانک ملت
خرید:125,000-
کارت:6104
مانده:1,875,000
```

**Parsed Result:**

- Amount: 125,000 Rials
- Type: Expense
- Account: 6104
- Balance: 1,875,000 Rials
- Bank: بانک ملت

## Minimum Transaction Amount

Transactions below **300,000 Rials** are ignored by auto-detection and must be added manually. This prevents cluttering the transaction history with small purchases.

## Supported Banks

- بانک ملی (Bank Melli)
- بانک صادرات (Bank Saderat)
- بانک ملت (Bank Mellat)
- بانک پاسارگاد (Bank Pasargad)
- بانک تجارت (Bank Tejarat)
- بانک سپه (Bank Sepah)
- بانک پارسیان (Bank Parsian)
- بانک کشاورزی (Bank Keshavarzi)
- بانک مسکن (Bank Maskan)
- بانک سامان (Bank Saman)

## Persian Digit Support

The SMS parser handles both English and Persian digits:

- English: 0123456789
- Persian: ۰۱۲۳۴۵۶۷۸۹

## Transaction Type Detection

### Expense Indicators:

- Keywords: انتقال, برداشت, خرید, پرداخت
- Minus sign after amount: `1,209,000-`

### Income Indicators:

- Keywords: واریز, افزایش
- Plus sign after amount: `2,500,000+`

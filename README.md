# EventCircle ⭕️

**EventCircle** is a high-transparency event management platform designed to simplify complex community and professional gatherings. From small local meetups to large-scale festivals, EventCircle provides the tools to manage logistics, finances, and communication with absolute clarity.

---

## 💎 Core Pillars

### 🚀 Blueprint Engine (Templates)
Standardize your events using verified blueprints. 
*   **Versioned Blueprints**: Every design iteration is tracked (V1, V2...).
*   **Unique Template Codes**: 7-character alphanumeric codes (e.g., `#XJ39K4L`) for easy sharing.
*   **Pre-configured Logistics**: Blueprints come with suggested tasks, vendors, budgets, and roles tailor-made for specific categories (like Ganesh Puja or Corporate Events).

### 📊 Financial Transparency
Real-time financial accountability for every stakeholder.
*   **Budgeting vs Expenses**: Automated tracking of planned vs actual costs.
*   **Dynamic Performance Cards**: Instant visual alerts if you're nearing or exceeding your budget.
*   **Contribution Models**: Support for Fixed, Voluntary, Tier-based, and even "No Contribution Needed" modes.

### 🛠 Modular Logistics
One app for every management need:
*   **Tasks & Procurement**: Real-time checklists and inventory tracking.
*   **Vendor Management**: Centralized records for suppliers and venue coordinators.
*   **Role-Based Access Control (RBAC)**: Custom permissions for Finance Managers, Volunteers, and Guest Coordinators.
*   **Ticketing & Scanning**: QR-based attendee management.

---

## 🛠 Tech Stack

*   **UI/Core**: Flutter (Dart)
*   **State**: Riverpod (with Code Generation)
*   **Database**: Cloud Firestore
*   **Auth**: Firebase Authentication
*   **Storage**: Firebase Storage
*   **Routing**: GoRouter

---

## 👩‍💻 For Developers

### Prerequisites
*   Flutter SDK (^3.11.4)
*   Firebase Project (Web/Android/iOS configurations)

### Initial Setup
1. Clone the repo:
   ```bash
   git clone https://github.com/mahatosoftware/EventCircle.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the generator:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Start development:
   ```bash
   flutter run
   ```

---

## ⚖️ License
Distributed under the Apache License 2.0. See `LICENSE` for more information.

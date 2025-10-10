# Marketplace Calculator

Marketplace Calculator is a simple Flutter web app for estimating the final price of products posted to popular Indonesian marketplaces, such as Tokopedia/TikTok Shop and Shopee. With constantly raising fees, it's important that sellers price their items correctly to avoid further loss.

This project was created primarily with learning [Flutter](https://github.com/flutter/flutter) and [Riverpod](https://github.com/rrousselGit/riverpod) in mind.

🔗 **Live page:** [![Github Page](https://img.shields.io/website?label=Page&logo=github&up_message=online&down_message=offline&url=https%3A%2F%2Freinhart-wilson.github.io%2Fmp-fee-calculator%2F)](https://reinhart-wilson.github.io/mp-fee-calculator/)

---

## ✨ Features

- Choose a marketplace (e.g., Tokopedia, Shopee, etc.)
- Select a category via:
  - Cascading dropdowns, or  
  - A searchable category list that automatically fills the dropdowns
- Fees can be toggled freely
- Calculation modes:
  - Net → Gross: estimate how much to list to achieve a net price  
  - Gross → Net calculate how much you’ll actually earn
- Real-time updates — calculations react instantly to any input or selection change
- Runs entirely on the client side

---

## 🧠 How it works

- The app reads fee and category data from JSON under `/assets/data/`.
- Fees and categories are represented as nested objects (`CategoryNode`).
- The calculator supports both **flat fees** and **multiplier-based fees**.
- For gross calculation, a **binary search** is used to find the correct price that yields the desired net value — efficient, flexible, and avoids hardcoding special limits.

---

## 🚀 Tech Stack

- [Flutter](https://github.com/flutter/flutter)
- [Riverpod](https://github.com/rrousselGit/riverpod)

---

## 🧩 Planned Improvements

- **Fee group exclusivity** — certain fees belonging to the same group (e.g., *Star* vs *Non-Star* on Shopee) will automatically deselect each other when selected.  
- **Automatically checks fees** - mandatory fees will be automatically selected upon load.
- **Mall/Official Store support** — not currently supported, since it requires reworking how fee data is structured and processed.

---

## Screenshots
![calculation_result](https://github.com/reinhart-wilson/mp-fee-calculator/blob/main/assets/screenshots/original.png)

---

## 🏗 Setup & Run Locally

```bash
# Clone the repo
git clone https://github.com/reinhart-wilson/mp-fee-calculator.git
cd mp-fee-calculator

# Get dependencies
flutter pub get

# Run the web app
flutter run -d chrome


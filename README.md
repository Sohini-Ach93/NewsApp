# 📰 NewsApp

A SwiftUI-based iOS application that fetches and displays top US news headlines using [NewsAPI.org](https://newsapi.org/). It also integrates internal endpoints to show likes and comments per article, allows offline reading via caching, and supports bookmarking articles.

---

## ✅ Features

- Fetches top headlines from NewsAPI (US region)
- Displays likes ❤️ and comments 💬 via internal endpoints
- Allows bookmarking articles with persistent storage
- Supports offline reading via local JSON caching
- Async image loading with placeholder fallback
- Clean SwiftUI UI using MVVM architecture
- Scalable project structure for future enhancements

---

## 📁 Project Structure
NewsApp/
├── App/                    # App entry point
├── Models/                # Data models like Article
├── Networking/            # APIClient, Endpoints
├── ViewModels/            # Business logic & state
├── Views/                 # SwiftUI views & cells
├── Utilities/             # Helpers (e.g., ImageLoader, Cache)
├── Resources/             # Constants, Assets
├── Tests/                 # Unit & UI Tests

---

## 🧠 How It Works

### 🗞 Top Headlines

- Uses [NewsAPI.org](https://newsapi.org) to fetch the top headlines in the US.
- Each news item includes a title, description, author, image URL, and article URL.

---

### ❤️ Likes & 💬 Comments

- Each article's ID is derived from its URL by removing the scheme and replacing `/` with `-`.

- - Two internal endpoints fetch like and comment counts:
- `GET /likes/{articleID}`
- `GET /comments/{articleID}`

- These counts are displayed in the article cell.

---

### 💾 Offline Caching

- Articles are saved to a local JSON file in the app's document directory after fetching from the API.
- If the app is launched without internet, the cached articles are shown instead.
- The app gracefully falls back to cache when offline.

---

### 🔖 Bookmarking

- Articles can be bookmarked by tapping the 🔖 icon in each cell.
- Bookmarked articles are stored persistently using a local file (`bookmarks.json`) in the app's cache directory.
- The icon updates instantly to reflect the bookmark status.
- In future, a Bookmarks tab can show saved articles.

---

## 🛠 Tech Stack

- **Language:** Swift 5
- **UI Framework:** SwiftUI
- **Architecture:** MVVM (Model-View-ViewModel)
- **Networking:** URLSession, Codable
- **Persistence:** FileManager (JSON caching)
- **Image Loading:** Async image loader with caching
- **Testing:** XCTest (unit & UI testing support)

---

## 🧰 Setup Instructions

1. **Clone the repository:**
 ```bash
 git clone https://github.com/Sohini-Ach93/NewsApp.git
 cd NewsApp

# Saffara Sports iOS App

[![Swift](https://img.shields.io/badge/Swift-6.0+-orange?logo=swift&logoColor=white)](https://developer.apple.com/swift/)
[![Platform](https://img.shields.io/badge/Platform-iOS%2015.0+-black?logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20MVP-purple)](#architecture--patterns)
[![UI Framework](https://img.shields.io/badge/UI%20Framework-UIKit-blue?logo=apple&logoColor=white)](#technical-skills--stack)
[![Local Storage](https://img.shields.io/badge/Storage-Core%20Data-red)](#caching--local-storage)

Saffara is a feature-rich, high-performance iOS application dedicated to sports enthusiasts. It delivers live sports data, league updates, upcoming fixtures, and match results seamlessly. Built with high maintainability and scalability in mind, the project strictly adheres to **Clean Architecture** principles combined with the **MVP (Model-View-Presenter)** design pattern.

---

## 🚀 Technical Skills & Stack

* **Language:** Swift 5+
* **UI Framework:** UIKit (Programmatic UI / Storyboards)
* **Architecture & Patterns:** Clean Architecture, MVP (Model-View-Presenter), Repository Pattern, Dependency Injection (DI)
* **Asynchronous & Reactive Programming:** Delegation Patterns, Closures, Completion Handlers
* **Data & Networking:** REST APIs integration, JSON Parsing, Offline-First Architecture (Caching Mechanism)
* **Local Database:** Core Data (Persistence, CRUD operations, offline availability)
* **Localization:** Dynamic Support for Arabic and English layouts (LTR / RTL switching)
* **Theming:** Full Adaptive Dark Mode / Light Mode support

---

## 🛠 Dependencies & Frameworks

The project utilizes industry-standard libraries to ensure clean code execution, robust networking, and smooth user experiences:

* **Alamofire:** Used to manage elegant HTTP networking requests and handle API operations gracefully.
* **Kingfisher:** A powerful, pure-Swift library for downloading and caching images from the web asynchronously.
* **Lottie:** Used to render rich, interactive vector animations (such as loading states and splash experiences).
* **Swinject:** A lightweight dependency injection framework for Swift to achieve pure decoupling across modules.

---

## 📐 Architecture & Patterns

The application is structured around **Clean Architecture**, completely decoupling business logic from UI rendering and framework dependencies:

1. **Domain Layer:** Contains core business rules, entity models, and Use Cases / Interactors. It is completely independent of any external frameworks.
2. **Data Layer:** Implements Repository interfaces defined by the Domain layer. It coordinates data fetching strategies between the Remote API and Local Storage.
3. **Presentation Layer (MVP):** - **View:** Responsible for displaying data and forwarding user interactions to the Presenter.
* **Presenter:** Contains presentation logic, handles user events, fetches data via use cases, and instructs the view on what to render.



### Caching & Local Storage

The app implements a robust **Offline-First / Caching Mechanism**. When requesting data from the network API, successful responses are securely cached locally inside **Core Data**. If network connectivity is unavailable, the repository automatically falls back to local storage, ensuring an uninterrupted user experience.

---

## 📸 Screenshots & Previews

---

## 🛠️ Installation & Setup

1. **Clone the repository:**
```bash
git clone https://github.com/ITI-IOS-Sports-App-MVP/Saffara_IOS_Swift_App.git

```


2. **Navigate to the project folder:**
```bash
cd Saffara_IOS_Swift_App

```


3. **Configure your API Key:**
This project uses an `.xcconfig` file to manage sensitive API keys securely. You will need to create one to run the app.
* Open the project in Xcode.
* Right-click on the root project folder in the Project Navigator and select **New File...**
* Search for and select **Configuration Settings File** and click Next.
* Save the file as `Config.xcconfig` in the root directory.
* Open `Config.xcconfig` and add your API key like this:
```text
API_KEY = Your_Actual_API_Key_Here

```


* *Note: Ensure that `Config.xcconfig` is added to your `.gitignore` file so you do not accidentally expose your personal API key.*


4. **Open the project workspace:**
Open `Saffara.xcworkspace` (or `Saffara.xcodeproj` depending on your setup) in Xcode.
5. **Run the app:**
* Select an iOS Simulator or connected physical device running iOS 15.0+ from the device dropdown.
* Press `Cmd + R` to build and run the application.
Press Cmd + R to build and run the application.

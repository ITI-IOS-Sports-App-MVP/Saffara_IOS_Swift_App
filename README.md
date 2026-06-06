# Saffara Sports iOS App

[![Swift](https://img.shields.io/badge/Swift-6.0+-orange?logo=swift&logoColor=white)](https://developer.apple.com/swift/)
[![Platform](https://img.shields.io/badge/Platform-iOS%2015.0+-black?logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20%2B%20MVP-purple)](#architecture--patterns)
[![UI Framework](https://img.shields.io/badge/UI%20Framework-UIKit-blue?logo=apple&logoColor=white)](#technical-skills--stack)
[![Local Storage](https://img.shields.io/badge/Storage-Core%20Data-red)](#caching--local-storage)

Saffara is a feature-rich, high-performance iOS application dedicated to sports enthusiasts. It delivers live sports data, league updates, upcoming fixtures, and match results seamlessly. Built with high maintainability and scalability in mind, the project strictly adheres to **Clean Architecture** principles combined with the **MVP (Model-View-Presenter)** design pattern.

---

## 🚀 Technical Skills & Stack

- **Language:** Swift 5+
- **UI Framework:** UIKit (Programmatic UI / Storyboards)
- **Architecture & Patterns:** Clean Architecture, MVP (Model-View-Presenter), Repository Pattern, Dependency Injection (DI)
- **Asynchronous & Reactive Programming:** Delegation Patterns, Closures, Completion Handlers
- **Data & Networking:** REST APIs integration, JSON Parsing, Offline-First Architecture (Caching Mechanism)
- **Local Database:** Core Data (Persistence, CRUD operations, offline availability)
- **Localization:** Dynamic Support for Arabic and English layouts (LTR / RTL switching)
- **Theming:** Full Adaptive Dark Mode / Light Mode support

---

## 🛠 Dependencies & Frameworks

The project utilizes industry-standard libraries to ensure clean code execution, robust networking, and smooth user experiences:

![Alamofire](https://img.shields.io/badge/Alamofire-Networking-red?logo=alamofire)
![Kingfisher](https://img.shields.io/badge/Kingfisher-Image--Caching-orange)
![Lottie](https://img.shields.io/badge/Lottie-Animations-brightgreen)
![Swinject](https://img.shields.io/badge/Swinject-Dependency--Injection-blue)

- **Alamofire:** Used to manage elegant HTTP networking requests and handle API operations gracefully.
- **Kingfisher:** A powerful, pure-Swift library for downloading and caching images from the web asynchronously.
- **Lottie:** Used to render rich, interactive vector animations (such as loading states and splash experiences).
- **Swinject:** A lightweight dependency injection framework for Swift to achieve pure decoupling across modules.

---

## 📐 Architecture & Patterns

The application is structured around **Clean Architecture**, completely decoupling business logic from UI rendering and framework dependencies:

1. **Domain Layer:** Contains core business rules, entity models, and Use Cases / Interactors. It is completely independent of any external frameworks.
2. **Data Layer:** Implements Repository interfaces defined by the Domain layer. It coordinates data fetching strategies between the Remote API and Local Storage.
3. **Presentation Layer (MVP):** - **View:** Responsible for displaying data and forwarding user interactions to the Presenter.
   - **Presenter:** Contains presentation logic, handles user events, fetches data via use cases, and instructs the view on what to render.

### Caching & Local Storage
The app implements a robust **Offline-First / Caching Mechanism**. When requesting data from the network API, successful responses are securely cached locally inside **Core Data**. If network connectivity is unavailable, the repository automatically falls back to local storage, ensuring an uninterrupted user experience.

---

## 📸 Screenshots & Previews

<table width="100%">
  <tr>
    <td align="center" width="33%">
      <img width="100%" src="https://github.com/user-attachments/assets/ebcd6b94-9c12-4ec0-8e88-9aa7d6f1d7c6" /><br/>
      <sub><b>Splash Screen</b></sub>
    </td>
    <td align="center" width="33%">
      <img width="100%" src="https://github.com/user-attachments/assets/c3e27a47-ae20-4908-b083-366700f61acb" /><br/>
      <sub><b>Splash Video</b></sub>
    </td>
    <td align="center" width="33%">
      <img width="100%" src="https://github.com/user-attachments/assets/8224a42a-71b7-4244-8186-3d62ca111e4b" /><br/>
      <sub><b>Home Screen</b></sub>
    </td>
  </tr>
  
  <tr>
    <td align="center" width="33%">
   <img width="1206" height="2622" alt="leagues screen" src="https://github.com/user-attachments/assets/59947f5b-5799-4661-aad5-2b482d0786e7" /><br/>
      <sub><b>Leagues Screen</b></sub>
    </td>
    <td align="center" width="33%">
      <img width="100%"src="https://github.com/user-attachments/assets/ba789641-7657-45aa-bf97-f0558606f45d" /><br/>
      <sub><b>Favorite Screen</b></sub>
    </td>
    <td align="center" width="33%">
      <img width="100%" src="https://github.com/user-attachments/assets/000503ce-6011-4375-a06b-e1376b491baf" /><br/>
      <sub><b>Settings (EN - Dark)</b></sub>
    </td>
  </tr>
  
  <tr>
    <td align="center" width="33%">
      <img width="100%" src="https://github.com/user-attachments/assets/d8b8698c-da9a-4f2a-8874-7422ba823424"/> <br/>
      <sub><b>Settings (AR - Light)</b></sub>
    </td>
    <td align="center" width="33%">
      <img width="100%"src="https://github.com/user-attachments/assets/bde01a28-bc06-46fc-8974-54ba1cb5aacc" /> <br/>
      <sub><b>League Details (No Results)</b></sub>
    </td>
    <td align="center" width="33%">
      <img width="100%" src="https://github.com/user-attachments/assets/7013283c-84c0-4cee-b3ec-9b8486fceddc" /> <br/>
      <sub><b>League Details (No Upcoming 1)</b></sub>
    </td>
  </tr>
  <tr>
    <td align="center" width="33%"></td>
    <td align="center" width="33%">
      <img width="100%" src="https://github.com/user-attachments/assets/0a5979fc-0443-4ed3-b997-16cecdd4419c" /> <br/>
      <sub><b>League Details (No Upcoming 2)</b></sub>
    </td>
    <td align="center" width="33%"></td>
  </tr>
</table>

---

## 🛠️ Installation & Setup

1. Clone the repository:
   ```bash
   git clone [https://github.com/ITI-IOS-Sports-App-MVP/Saffara_IOS_Swift_App.git](https://github.com/ITI-IOS-Sports-App-MVP/Saffara_IOS_Swift_App.git)
Open the project root folder:

Bash
cd Saffara_IOS_Swift_App
Open Saffara.xcworkspace (or Saffara.xcodeproj depending on your dependency management layout) in Xcode.

Select an iOS Simulator or connected physical device running iOS 15.0+.

Press Cmd + R to build and run the application.

# ☕ Coffee House Mobile App

A mobile application for managing and operating a coffee shop, built with **Flutter** and powered by a **SQL-based database system**.  
The app helps streamline daily operations such as order management, menu handling, and sales tracking.

---

## 📱 Features

- 📋 View coffee menu & categories
- 🛒 Create and manage orders
- 💰 Calculate total bills automatically
- 🧾 Order history tracking
- 📊 Sales statistics (daily / monthly)
- 👤 Staff login & role-based access
- 🔄 Sync data with SQL database

---

## 🛠 Tech Stack

### Frontend
- **Flutter**
- **Dart**
- State Management: *(Bloc / Provider / Riverpod)*

### Backend & Database
- **SQL Database** (SQL Server / MySQL)
- **SQL Manager** for database administration
- REST API for client–server communication

---

## 🗂 Project Structure

```text
├───core
│   └───constants
└───features
    ├───auth
    │   └───presentation
    │       └───screens
    ├───banner
    │   ├───data
    │   │   ├───datasources
    │   │   │   └───remote
    │   │   ├───models
    │   │   └───repositories
    │   ├───domain
    │   │   ├───entities
    │   │   ├───repositories
    │   │   └───usecases
    │   └───presentation
    │       ├───state
    │       └───widgets
    ├───category
    │   ├───data
    │   │   ├───datasources
    │   │   │   └───remote
    │   │   ├───models
    │   │   └───repositories
    │   ├───domain
    │   │   ├───entities
    │   │   ├───repositories
    │   │   └───usecases
    │   └───presentation
    │       ├───state
    │       └───widgets
    ├───exploreTopic
    │   ├───data
    │   │   ├───datasources
    │   │   │   └───remote
    │   │   ├───models
    │   │   └───repositories
    │   ├───domain
    │   │   ├───entities
    │   │   ├───repositories
    │   │   └───usecases
    │   └───presentation
    │       ├───state
    │       └───widgets
    ├───home
    │   ├───data
    │   │   └───repositories
    │   ├───domain
    │   │   ├───entities
    │   │   ├───repositories
    │   │   └───usecases
    │   └───presentation
    │       ├───controllers
    │       ├───screens
    │       ├───state
    │       └───widgets
    ├───order
    │   ├───data
    │   │   ├───datasources
    │   │   │   └───remote
    │   │   ├───models
    │   │   └───repositories
    │   ├───domain
    │   │   ├───entities
    │   │   ├───repositories
    │   │   └───usecases
    │   └───presentation
    │       └───state
    ├───Other_option
    │   ├───data
    │   ├───domain
    │   └───presentation
    ├───product
    │   ├───data
    │   │   ├───datasources
    │   │   │   └───remote
    │   │   ├───models
    │   │   └───repositories
    │   ├───domain
    │   │   ├───entities
    │   │   ├───repositories
    │   │   └───usecases
    │   └───presentation
    │       ├───state
    │       ├───utils
    │       └───widgets
    ├───promotion
    │   ├───data
    │   │   ├───datasources
    │   │   │   └───remote
    │   │   ├───models
    │   │   └───repositories
    │   ├───domain
    │   │   ├───entities
    │   │   ├───repositories
    │   │   └───usecases
    │   └───presentation
    │       ├───state
    │       └───widgets
    ├───store
    │   ├───domain
    │   │   ├───entities
    │   │   ├───repositories
    │   │   ├───usecases
    │   │   └───values_object
    │   └───presentation
    │       ├───state
    │       ├───utils
    │       └───widgets
    └───user
# El Buhonero 📱

A modern iOS e-commerce application built with UIKit and SwiftUI, featuring QR code scanning, multi-store product browsing, and secure payment processing.

## 🚀 Features

### Core Functionality
- **Multi-Store Support**: Browse products from two different APIs (Fake Store API & Platzi Fake Store API)
- **QR Code Scanning**: Scan QR codes to quickly access product details and make purchases
- **Product Browsing**: Beautiful product catalog with categories and search functionality
- **Secure Payments**: Integrated payment processing with test card support
- **Purchase History**: Complete transaction history with SwiftUI interface
- **Country Selection**: Choose between different store regions (Isla de Man & Kiribati)

### User Experience
- **Dark Theme**: Modern dark UI design throughout the app
- **Smooth Navigation**: Coordinator pattern for clean navigation flow
- **Responsive Design**: Optimized for all iOS devices
- **Offline Support**: Cached product data and persistent purchase history

## 🏗️ Architecture

### Design Patterns
- **MVVM**: Model-View-ViewModel architecture for clean separation of concerns
- **Coordinator Pattern**: Centralized navigation management
- **Singleton Pattern**: Shared data management (DataManager, OrderManager)
- **Protocol-Oriented**: Extensive use of protocols for loose coupling

### Project Structure
```
El Buhonero/
├── Core/
│   ├── Networking/          # API integration and data models
│   ├── Shared Protocols/    # Core protocols and data management
│   ├── Utils/              # Utility classes (QR parsing, payments)
│   └── Shared Views/       # Reusable UI components
├── Features/
│   ├── Custom LaunchScreen/ # App launch experience
│   ├── LoginScreen/        # User authentication
│   ├── SelectCountryScreen/ # Store selection
│   ├── HomeScreen/         # Main product catalog
│   ├── QRScanScreen/       # QR code scanning
│   ├── ProductDetailScreen/ # Product information
│   ├── PaymentScreen/      # Payment processing
│   └── PurchaseHistory/    # Transaction history (SwiftUI)
└── Assets/                 # Images, icons, and resources
```

## 🛠️ Technical Stack

### Dependencies
- **Alamofire**: HTTP networking and API calls
- **Kingfisher**: Image loading and caching
- **Lottie**: Animated loading states
- **AVFoundation**: QR code scanning capabilities

### iOS Requirements
- **Minimum iOS Version**: 17.0
- **Target iOS Version**: 17.0+
- **Device Support**: iPhone and iPad
- **Architecture**: ARM64

## 📱 App Flow

### 1. Launch & Authentication
```
Custom LaunchScreen → LoginScreen → SelectCountryScreen → HomeScreen
```

### 2. Product Browsing
- **HomeScreen**: Browse products by category with banner carousel
- **Product Details**: Tap any product to view details and purchase
- **QR Scanning**: Use bottom navigation to scan QR codes

### 3. Purchase Flow
```
Product Detail → Payment Screen → Order Confirmation → HomeScreen
```

### 4. Purchase History
- Access via bottom navigation clock icon
- View all completed transactions
- See product images, prices, and order details

## 🔧 Setup & Installation

### Prerequisites
- Xcode 15.0+
- iOS 17.0+ device or simulator
- CocoaPods

### Installation Steps
1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd El-Buhonero
   ```

2. **Install dependencies**
   ```bash
   cd "El Buhonero"
   pod install
   ```

3. **Open workspace**
   ```bash
   open "El Buhonero.xcworkspace"
   ```

4. **Build and run**
   - Select your target device/simulator
   - Press `Cmd + R` to build and run

## 🧪 Testing

### Test Card Details
For testing the payment system, use these credentials:
- **Card Number**: `4111 1111 1111 1111`
- **Cardholder Name**: Any name (e.g., "John Doe")
- **CVV**: `123`
- **Expiry Date**: `12/25`

### QR Code Testing
QR codes should contain JSON data in this format:
```json
{
  "country": "A",
  "productId": 1
}
```

## 📊 Data Sources

### Store A (Isla de Man)
- **API**: Fake Store API
- **Products**: Electronics, Jewelry, Men's & Women's Clothing
- **Features**: Product ratings and reviews

### Store B (Kiribati)
- **API**: Platzi Fake Store API
- **Products**: Various categories with multiple images
- **Features**: Enhanced product metadata

## 🔐 Security Features

- **Secure Payment Processing**: Test payment system with validation
- **Card Data Protection**: Only last 4 digits stored
- **Order Number Generation**: Unique timestamp-based order IDs
- **Data Persistence**: Secure local storage with UserDefaults

## 🎨 UI/UX Features

### Design System
- **Color Scheme**: Dark theme with accent colors
- **Typography**: System fonts with proper hierarchy
- **Spacing**: Consistent 8pt grid system
- **Animations**: Smooth transitions and loading states

### Navigation
- **Bottom Navigation**: QR Scan, Purchase History, Logout
- **Coordinator Pattern**: Clean navigation management
- **Back Navigation**: Proper navigation stack handling

## 📈 Performance

### Optimizations
- **Image Caching**: Kingfisher for efficient image loading
- **Lazy Loading**: Collection view with lazy loading
- **Memory Management**: Proper ARC and weak references
- **Network Caching**: Alamofire request caching

## 🔄 State Management

### Data Flow
1. **DataManager**: Centralized app state and user preferences
2. **ViewModels**: Business logic and data transformation
3. **Coordinators**: Navigation and screen coordination
4. **OrderManager**: Purchase history and transaction data

## 🚀 Future Enhancements

### Planned Features
- [ ] Push notifications for order updates
- [ ] User profiles and preferences
- [ ] Wishlist functionality
- [ ] Product reviews and ratings
- [ ] Advanced search and filtering
- [ ] Offline mode with Core Data
- [ ] Apple Pay integration
- [ ] Social sharing features

## 🤝 Contributing

### Development Guidelines
- Follow MVVM architecture patterns
- Use SwiftLint for code style consistency
- Write unit tests for business logic
- Document public APIs and complex methods
- Follow iOS Human Interface Guidelines

### Code Style
- **Swift**: Latest Swift syntax and features
- **Naming**: Descriptive names following Apple conventions
- **Comments**: Clear documentation for complex logic
- **Structure**: Organized file and folder structure

## 📄 License

This project is proprietary software. All rights reserved.

## 👨‍💻 Development Team

- **Lead Developer**: Andrés Fonseca
- **Architecture**: MVVM + Coordinator Pattern
- **UI Framework**: UIKit + SwiftUI
- **Networking**: Alamofire
- **Image Loading**: Kingfisher

---

**El Buhonero** - Your modern shopping companion 📱✨
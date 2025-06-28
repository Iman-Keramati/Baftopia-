# Baftopia - Where Every Stitch Tells a Story

A Flutter application for managing knitting projects and categories with a beautiful Persian UI.

## 🚀 Features

- **Category Management**: Create, edit, and delete categories with images
- **Product Management**: Add, edit, and delete knitting projects
- **Persian UI**: Full Persian language support with RTL layout
- **Image Upload**: Upload images to Supabase storage
- **Date Picker**: Persian (Jalali) date picker integration
- **Real-time Updates**: Automatic UI updates when data changes
- **Responsive Design**: Works on all screen sizes

## 🛠️ Optimizations & Best Practices

### 1. **Code Organization**

- **Core Directory**: Centralized constants, theme, and utilities
- **Separation of Concerns**: Models, providers, services, and widgets are properly separated
- **Consistent Naming**: Following Dart naming conventions

### 2. **Performance Optimizations**

- **Provider Invalidation**: Efficient state management with Riverpod
- **Image Optimization**: Proper image loading with placeholders and error handling
- **Lazy Loading**: Images load only when needed
- **Memory Management**: Proper disposal of controllers and resources

### 3. **UI/UX Improvements**

- **Better Persian Font**: Vazirmatn font for improved Persian text rendering
- **Consistent Spacing**: Using centralized spacing constants
- **Theme System**: Centralized theme configuration
- **Loading States**: Proper loading indicators throughout the app
- **Error Handling**: User-friendly error messages

### 4. **Data Management**

- **Sorting**: Newest items appear at the top of lists
- **Real-time Updates**: UI updates automatically when data changes
- **Validation**: Comprehensive form validation
- **Error Recovery**: Graceful error handling and recovery

### 5. **Security & Best Practices**

- **Environment Variables**: Supabase credentials properly configured
- **Input Validation**: Server-side and client-side validation
- **Error Logging**: Proper error logging and debugging
- **Code Documentation**: Comprehensive code comments

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants.dart      # App constants and text
│   ├── theme.dart          # Theme configuration
│   └── utils.dart          # Utility functions
├── data/
│   ├── category_data.dart  # Category service
│   └── product_data.dart   # Product service
├── models/
│   ├── category.dart       # Category model
│   └── product.dart        # Product model
├── provider/
│   ├── category_provider.dart  # Category state management
│   └── product_provider.dart   # Product state management
├── screens/
│   ├── categories.dart     # Categories list screen
│   ├── category_detail.dart # Category detail screen
│   ├── product_detail.dart # Product detail screen
│   └── welcome.dart        # Welcome screen
├── utils/
│   ├── delete_category.dart # Category deletion utility
│   └── delete_product.dart  # Product deletion utility
├── widgets/
│   ├── add_category.dart   # Add/edit category widget
│   ├── add_product.dart    # Add/edit product widget
│   ├── category_item.dart  # Category list item
│   ├── floating_button.dart # Floating action button
│   ├── image_input.dart    # Image picker widget
│   ├── persian_date_picker.dart # Persian date picker
│   └── product_item.dart   # Product list item
└── main.dart              # App entry point
```

## 🎨 Design System

### Colors

- **Primary**: `#D8A7B1` (Rose blush)
- **Secondary**: `#F7D6C3` (Peach whisper)
- **Background**: `#FBEAE5` (Creamy white)
- **Surface**: `#FFEDE7` (Pastel blush)
- **Text**: `#5E4A47` (Warm brown)

### Typography

- **Persian Font**: Vazirmatn (Regular, Medium, Bold, Light)
- **English Font**: Poppins
- **Consistent Text Sizes**: 12px, 16px, 20px, 24px, 32px

### Spacing

- **Small**: 8px
- **Medium**: 16px
- **Large**: 24px

### Border Radius

- **Small**: 8px
- **Medium**: 16px
- **Large**: 24px

## 🔧 Setup Instructions

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd baftopia
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Add Vazirmatn font files**

   - Download Vazirmatn font files from [Google Fonts](https://fonts.google.com/specimen/Vazirmatn)
   - Place them in `assets/fonts/` directory:
     - `Vazirmatn-Regular.ttf`
     - `Vazirmatn-Medium.ttf`
     - `Vazirmatn-Bold.ttf`
     - `Vazirmatn-Light.ttf`

4. **Configure Supabase**

   - Update Supabase URL and anon key in `lib/main.dart`
   - Set up storage buckets for images

5. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Features in Detail

### Category Management

- Create categories with title and image
- Edit existing categories
- Delete categories (with confirmation)
- Categories sorted by creation time (newest first)

### Product Management

- Add products with comprehensive details
- Edit existing products
- Delete products (with confirmation)
- Products sorted by date (newest first)
- Image upload and management

### UI Features

- RTL layout for Persian text
- Smooth animations and transitions
- Loading states and error handling
- Responsive design
- Beautiful Persian typography

## 🚀 Performance Features

- **Efficient State Management**: Using Riverpod for optimal performance
- **Image Optimization**: Proper image caching and loading
- **Memory Management**: Proper resource disposal
- **Lazy Loading**: Images and data load on demand
- **Real-time Updates**: Automatic UI refresh when data changes

## 🔒 Security Features

- **Input Validation**: Comprehensive form validation
- **Error Handling**: Graceful error recovery
- **Secure Storage**: Proper image storage with Supabase
- **Data Integrity**: Proper data validation and sanitization

## 📈 Future Enhancements

- [ ] Dark mode support
- [ ] Offline functionality
- [ ] Search and filtering
- [ ] User authentication
- [ ] Social sharing
- [ ] Export/import functionality
- [ ] Advanced analytics
- [ ] Push notifications

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Vazirmatn font by [Vazirmatn](https://github.com/aminabedi68/Vazirmatn)
- Supabase for backend services
- Flutter team for the amazing framework
- Persian community for inspiration and support

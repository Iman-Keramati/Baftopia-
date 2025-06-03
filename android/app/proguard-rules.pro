# Flutter & Dart
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.app.** { *; }

# MainActivity
-keep class com.keramati.baftopia.MainActivity { *; }

# Prevent obfuscation of generated plugin registrant
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# Google Fonts
-keep class com.google.fonts.** { *; }

# Transparent Image
-keep class transparent_image.** { *; }

# Jalali Date Picker & Shamsi Date
-keep class ir.** { *; }

# Image Picker
-keep class io.flutter.plugins.imagepicker.** { *; }
-dontwarn io.flutter.plugins.imagepicker.**

# Riverpod
-keep class **riverpod** { *; }

# Supabase
-keep class io.supabase.** { *; }
-keep class org.postgrest.** { *; }
-keep class io.github.jan.supabase.** { *; }
-dontwarn io.github.jan.supabase.**

# UUID
-keep class java.util.UUID { *; }

# General keep rules
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn javax.annotation.**
-dontwarn kotlin.**
-dontwarn kotlinx.coroutines.**

# Preserve annotations
-keepattributes *Annotation*,Signature,InnerClasses,EnclosingMethod

# Optional
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable

-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

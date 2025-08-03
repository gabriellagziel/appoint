# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Google Maps
-keep class com.google.android.gms.maps.** { *; }

# Keep Play Core classes
-keep class com.google.android.play.core.** { *; }

# Keep important classes
-keep class com.appoint.app.** { *; }

# Remove debug information
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable,*Annotation*

# Optimize
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification

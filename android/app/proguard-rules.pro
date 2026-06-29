# Flutter engine
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class **.GeneratedPluginRegistrant { *; }
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
-keepattributes EnclosingMethod
-keepattributes SourceFile,LineNumberTable

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**

# Kotlin
-dontwarn kotlin.**
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-keepclassmembers class kotlin.Metadata { public <methods>; }
-keepclassmembers class **$WhenMappings { <fields>; }

# Coroutines
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-keepclassmembernames class kotlinx.** { volatile <fields>; }

# Desugaring
-keep class j$.** { *; }
-dontwarn j$.**

-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

//create the file inside android/app and add the lines
#############################################
# ✅ Flutter Core Rules
#############################################
# Keep all Flutter classes
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Keep Flutter entry points
-keep class * extends io.flutter.app.FlutterApplication
-keep class * extends io.flutter.embedding.android.FlutterActivity
-keep class * extends io.flutter.embedding.android.FlutterFragmentActivity
-keep class * extends io.flutter.plugin.common.MethodChannel
-keep class * extends io.flutter.plugin.common.EventChannel

#############################################
# ✅ Razorpay SDK
#############################################
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

#############################################
# ✅ Kotlin Metadata
#############################################
-keep class kotlin.Metadata { *; }

#############################################
# ✅ Annotations
#############################################
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }

#############################################
# ✅ Java Desugaring (java.time.*)
#############################################
-dontwarn java.time.**
-dontwarn j$.**

#############################################
# ✅ Firebase (Messaging, Analytics, etc.)
#############################################
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

#############################################
# ✅ GSON / JSON Serialization
#############################################
-keep class com.google.gson.** { *; }
-dontwarn com.google.gson.**
-keepattributes Signature
-keepattributes *Annotation*
-keep class sun.misc.Unsafe { *; }

#############################################
# ✅ Flutter Local Notifications Plugin
#############################################
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

#############################################
# ✅ AndroidX + Jetpack Safe Defaults
#############################################
-dontwarn androidx.lifecycle.**
-keep class androidx.lifecycle.DefaultLifecycleObserver
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

#############################################
# ✅ Prevent common reflection-related stripping
#############################################
-keepattributes InnerClasses,EnclosingMethod,Signature,RuntimeVisibleAnnotations,RuntimeVisibleParameterAnnotations


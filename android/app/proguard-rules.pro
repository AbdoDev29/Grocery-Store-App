# Flutter Play Store Split
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Stripe Push Provisioning
-keep class com.stripe.android.pushProvisioning.** { *; }
-dontwarn com.stripe.android.pushProvisioning.**
-keep class com.reactnativestripesdk.** { *; }
-dontwarn com.reactnativestripesdk.**

# Firebase
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Flutter
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Stripe
-keep class com.stripe.** { *; }
-dontwarn com.stripe.**
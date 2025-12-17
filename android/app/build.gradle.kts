import com.android.build.gradle.internal.cxx.configure.gradleLocalProperties


plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.shop"
    compileSdk = 36

    defaultConfig {
        applicationId = "com.example.shop"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = 1 // اضبط حسب مشروعك
        versionName = "1.0" // اضبط حسب مشروعك
    }

    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            // عطّل التصغير مؤقتًا عشان R8 ما يشتغلش
            isMinifyEnabled = true
            isShrinkResources = true

            // إمضاء مؤقت بالـ debug علشان build يشتغل
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    packagingOptions {
        resources {
            excludes += setOf(
                "META-INF/LICENSE.txt",
                "META-INF/DEPENDENCIES",
                "META-INF/NOTICE.txt",
                "META-INF/LICENSE"
            )
        }
    }
}

dependencies {
    implementation("com.google.android.material:material:1.12.0")
    implementation(platform("com.google.firebase:firebase-bom:34.4.0"))
    implementation("com.google.firebase:firebase-analytics")
}
 
flutter {
    source = "../.."
}

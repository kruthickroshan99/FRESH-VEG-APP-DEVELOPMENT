plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.fresh_veg"
    compileSdk = 34  // ✅ Match with your SDK version
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17  // ✅ Updated to Java 17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"  // ✅ Match with Java version
    }

    defaultConfig {
        applicationId = "com.example.fresh_veg"
        minSdk = flutter.minSdkVersion  // ✅ Required for Firebase
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // For testing/debug builds
            signingConfig = signingConfigs.getByName("debug")
            
            // Optimization settings
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BOM - manages all Firebase library versions
    implementation(platform("com.google.firebase:firebase-bom:33.7.0"))
    implementation("com.google.firebase:firebase-auth-ktx")
    implementation("com.google.firebase:firebase-firestore-ktx")
    
    // Multidex support for large apps
    implementation("androidx.multidex:multidex:2.0.1")
}

// ✅ MUST be at the bottom
apply(plugin = "com.google.gms.google-services")

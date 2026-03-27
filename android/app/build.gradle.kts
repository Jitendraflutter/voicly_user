plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.voicly.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.voicly.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

    }
    packaging {
        jniLibs {
            excludes += setOf(
                "**/libagora_ai_denoise_extension.so",
                "**/libagora_ai_echo_cancellation_extension.so",
                "**/libagora_video_process_extension.so",
                "**/libagora_segmentation_extension.so",
                "**/libagora_clear_vision_extension.so",
                "**/libagora_super_resolution_extension.so",
                "**/libagora_spatial_audio_extension.so",
                "**/libagora_audio_beauty_extension.so",
                "**/libagora_face_detection_extension.so",
                "**/libagora_content_inspect_extension.so",
                "**/libagora_screen_capture_extension.so"
            )
        }
    }
    buildTypes {
        getByName("release") {
            // ADD THIS EXACT LINE:
            signingConfig = signingConfigs.getByName("debug")

            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}
dependencies {
    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.8.0"))
    implementation("com.google.firebase:firebase-analytics")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("com.google.firebase:firebase-functions")
}
import com.android.build.gradle.internal.cxx.configure.gradleLocalProperties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.ssafy.kkuk_kkuk"
    compileSdk = flutter.compileSdkVersion
    //ndkVersion = flutter.ndkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.ssafy.kkuk_kkuk"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // kakao app key 설정
        val properties = gradleLocalProperties(rootProject.projectDir, providers)
        manifestPlaceholders["KAKAO_APP_KEY"] = properties.getProperty("kakao.app.key", "")
    }

    buildTypes {
     release {
         // TODO: Add your own signing config for the release build.
         // Signing with the debug keys for now, so `flutter run --release` works.
         signingConfig = signingConfigs.getByName("debug")

         // R8 코드 축소 및 난독화 활성화 (Kotlin 문법)
         isMinifyEnabled = true
         // 리소스 축소 활성화 (Kotlin 문법)
         isShrinkResources = true
         // ProGuard 파일 지정 (Kotlin 문법 - 함수 호출)
         proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
     }
  }
}

dependencies {
    implementation("com.google.mlkit:text-recognition-korean:16.0.0")
}

flutter {
    source = "../.."
}

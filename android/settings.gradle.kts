pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "9.1.0" apply false
    id("org.jetbrains.kotlin.android") version "2.4.0" apply false
}

// Flutter plugins still declare their own buildscript classpath (old AGP /
// Kotlin). Keep them on the app versions so Gradle does not download extras.
gradle.beforeProject {
    if (this == rootProject) return@beforeProject
    buildscript.configurations.named("classpath").configure {
        resolutionStrategy.eachDependency {
            if (requested.group == "com.android.tools.build" && requested.name == "gradle") {
                useVersion("9.1.0")
            }
            if (requested.group == "org.jetbrains.kotlin" &&
                requested.name in listOf("kotlin-gradle-plugin", "kotlin-gradle-plugin-api")
            ) {
                useVersion("2.4.0")
            }
        }
    }
}

include(":app")

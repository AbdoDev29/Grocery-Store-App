plugins {
    // تطبيق جميع الإضافات الضرورية
    // id("com.android.application")
    // id("com.google.gms.google-services") // تأكد من تفعيل هذا في ملف app-level لاحقا
    // id("kotlin-android")
    // id("dev.flutter.flutter-gradle-plugin") // إذا تستخدم Flutter بكوتلن
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

#!/bin/bash
# ==========================================
# PUBLIC BUILDER - BUILD ENTRYPOINT
# ==========================================
# This script is executed automatically by the builder on `ubuntu-latest`.
# Standard tools (curl, wget, jq, zip, tar, git, gcc, clang, python, go, rust) are pre-installed.
#
# IMPORTANT RULES:
# 1. Be careful NOT to echo passwords or secrets to stdout.
# 2. Assume your current working directory is the root of your repository.
# 3. Everything placed inside the directory indicated by your payload's `artifact_path`
#    (default: 'dist') will be bundled and released.
# ==========================================

# 🛑 Fail explicitly if any command fails
set -e

echo "Starting build process..."

# ==========================================
# EXAMPLE 1: Android Gradle Build
# If your payload has "build_type": "android-gradle", Java 17 is already configured.
# ==========================================
# echo "Building Android APK..."
# chmod +x ./gradlew
# ./gradlew assembleRelease
#
# # Move output to artifact path to be bundled
# mkdir -p dist
# cp app/build/outputs/apk/release/*.apk dist/


# ==========================================
# EXAMPLE 2: Node.js / React / Next.js
# If your payload has "build_type": "node", Node.js is already configured.
# ==========================================
# echo "Installing dependencies..."
# npm ci
#
# echo "Building web app..."
# npm run build
# 
# # Default artifact path is usually "dist" or "out" for web apps.


# ==========================================
# EXAMPLE 3: C/C++ NDK Library Build
# If your payload has "build_type": "ndk-cmake", NDK is linked in $ANDROID_NDK_HOME.
# ==========================================
# echo "Building NDK library..."
# mkdir -p build && cd build
# cmake -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_HOME/build/cmake/android.toolchain.cmake \
#       -DANDROID_ABI=arm64-v8a ..
# make
# cd ..
#
# mkdir -p dist
# cp build/*.so dist/


# ==========================================
# EXAMPLE 4: Custom / Everything Else
# If your payload has "build_type": "custom", you must install tools manually here.
# ==========================================
# echo "Installing custom dependencies..."
# sudo apt-get update && sudo apt-get install -y some-random-tool
# some-random-tool --build .


echo "Build complete! Artifacts are ready in the artifact_path directory."

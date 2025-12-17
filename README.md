# 🔍 Advanced Search Bar (Flutter)

A reusable **Advanced Search Bar widget for Flutter** with built-in:

- 🔍 Text search with debounce  
- 🎤 Voice search (Speech-to-Text)  
- 📋 Auto suggestions  
- 🌐 Internet availability check  
- 🔐 Runtime microphone permission handling  

Designed to be **simple, clean, and production-ready**.

---

## ✨ Features

- **Debounce built-in** (500ms delay)
- **Voice search support**
- **Mic ON / OFF toggle**
- **Suggestion dropdown**
- **Internet check before voice search**
- **Reusable & customizable widget**

---

## 🎤 Mic Icon Behavior

| State | Icon |
|------|------|
Mic OFF (default) | `Icons.mic_off` |
Mic ON (listening) | `Icons.mic` |

- App starts with **mic OFF**
- Tap mic → starts listening
- Tap again → stops listening

---

## ✨ Preview



https://github.com/user-attachments/assets/201b2bbd-3fcf-4f8e-a69a-90ba7c200922






---

## ✨ Installation
Add this to your package's pubspec.yaml file:
```
dependencies:
  flutter:
    sdk: flutter
  speech_to_text: 6.3.0
  permission_handler: ^11.3.1

```
from git:
```
dependencies:
  advanced_search_bar:
    git:
      url: https://github.com/yourusername/advanced_search_bar.git
```
##4️⃣ Android Permission Setup

- Add microphone permission in
android/app/src/main/AndroidManifest.xml:
```
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
```
Then Run:
```
flutter pub get
```
## 📁 Folder Structure
```
advanced_search_bar/
│
├── lib/
│   └── advanced_search_bar.dart
│
├── example/
│   └── main.dart
│
├── pubspec.yaml
└── README.md
  ```
## 🚀 Usage
```
import 'package:flutter/material.dart';
import 'package:advanced_search_bar/advanced_search_bar.dart';

class SearchDemoScreen extends StatefulWidget {
  const SearchDemoScreen({super.key});

  @override
  State<SearchDemoScreen> createState() => _SearchDemoScreenState();
}

class _SearchDemoScreenState extends State<SearchDemoScreen> {
  final List<String> products = [
    "iPhone 15",
    "Samsung Galaxy S24",
    "Google Pixel 8",
    "OnePlus 12",
    "MacBook Air",
    "Dell XPS",
    "Asus ROG",
  ];

  List<String> results = [];

  void _search(String query) {
    setState(() {
      results = products
          .where(
            (item) => item.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Advanced Search Demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 🔍 Advanced Search Bar
            AdvancedSearchBar(
              suggestions: products,
              onSearch: _search,
            ),

            const SizedBox(height: 20),

            /// 📦 Search Results
            Expanded(
              child: results.isEmpty
                  ? const Center(
                      child: Text(
                        "Type or use voice search 🎤",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.shopping_bag),
                          title: Text(results[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
```
## 📜 License
MIT License
```
Copyright (c) 2025 Excelsior Technologies

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all  
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED **"AS IS"**, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
```


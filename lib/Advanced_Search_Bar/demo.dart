import 'package:flutter/material.dart';
import 'advanced_search_bar.dart';

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
          .where((item) =>
          item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Advanced Search Demo")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AdvancedSearchBar(
              suggestions: products,
              onSearch: _search,
            ),

            const SizedBox(height: 20),

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
                    leading:
                    const Icon(Icons.shopping_bag),
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

import 'package:flutter/material.dart';
import '../widgets/category_grid.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Categories"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: CategoryGrid(),
        ),
      ),
    );
  }
}
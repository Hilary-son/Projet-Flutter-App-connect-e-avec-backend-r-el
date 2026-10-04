import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers.dart';
import 'features/auth/presentation/profile_page.dart';
import 'features/posts/presentation/posts_page.dart';
import 'features/products/presentation/products_page.dart';
import 'features/recipes/presentation/recipes_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _index = 0;
  static const _titles = ['Produits', 'Recettes', 'Posts', 'Profil'];
  static const _pages = [
    ProductsPage(),
    RecipesPage(),
    PostsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(connectivityProvider).value ?? true;
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index])),
      body: Column(children: [
        if (!online)
          Container(
            width: double.infinity,
            color: Colors.red.shade700,
            padding: const EdgeInsets.all(6),
            child: const Text('Mode hors-ligne',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white)),
          ),
        Expanded(child: _pages[_index]),
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.shopping_bag), label: 'Produits'),
          NavigationDestination(icon: Icon(Icons.restaurant), label: 'Recettes'),
          NavigationDestination(icon: Icon(Icons.article), label: 'Posts'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

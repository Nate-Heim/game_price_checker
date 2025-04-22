import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/api_service.dart';
import '../widgets/game_card.dart';
import '../services/firestore_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> games = [];
  String _sortBy = 'Price';

  void _searchGames() async {
    final result = await ApiService.fetchGames(_controller.text);
    setState(() {
      games = result;
      _sortGames();
    });
  }

  void _sortGames() {
    if (_sortBy == 'Price') {
      games.sort(
        (a, b) =>
            double.parse(a['cheapest']).compareTo(double.parse(b['cheapest'])),
      );
    } else if (_sortBy == 'Title') {
      games.sort((a, b) => a['external'].compareTo(b['external']));
    }
  }

  Widget _wishlistCountIcon() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreService.getWishlist(),
      builder: (context, snapshot) {
        final count = snapshot.data?.docs.length ?? 0;
        return Row(
          children: [
            const Icon(Icons.favorite),
            const SizedBox(width: 4),
            Text('$count'),
          ],
        );
      },
    );
  }

  Widget _sortDropdown() {
    return Row(
      children: [
        const Text('Sort by: '),
        const SizedBox(width: 8),
        DropdownButton<String>(
          value: _sortBy,
          items:
              ['Price', 'Title'].map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: (value) {
            setState(() {
              _sortBy = value!;
              _sortGames();
            });
          },
        ),
      ],
    );
  }

  void _showSurpriseDeal() async {
    try {
      final res = await ApiService.fetchDeals();

      if (res.isEmpty) return;

      final random = (res..shuffle()).first;

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text(random['title'] ?? 'Mystery Deal'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    random['thumb'],
                    width: 150,
                    height: 100,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported),
                  ),
                  const SizedBox(height: 10),
                  Text('Sale Price: \$${random['salePrice']}'),
                  Text('Normal Price: \$${random['normalPrice']}'),
                  if (random['storeID'] != null)
                    Text('Store ID: ${random['storeID']}'),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Close'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load deal')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Price Checker'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: _wishlistCountIcon(),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Wishlist'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/wishlist');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search a game',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchGames,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: _showSurpriseDeal,
                icon: const Icon(Icons.card_giftcard),
                label: const Text('Deal of the Moment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: _sortDropdown(),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child:
                  games.isEmpty
                      ? const Center(
                        key: ValueKey('empty'),
                        child: Text('No games found'),
                      )
                      : ListView(
                        key: ValueKey<String>(_controller.text),
                        children:
                            games.map((game) => GameCard(game: game)).toList(),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}

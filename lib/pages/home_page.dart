import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/game_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> games = [];

  void _searchGames() async {
    final result = await ApiService.fetchGames(_controller.text);
    setState(() {
      games = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Game Price Checker')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search a game',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchGames,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                return GameCard(game: games[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

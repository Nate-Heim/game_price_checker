import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class GameCard extends StatelessWidget {
  final dynamic game;

  const GameCard({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Image.network(
          game['thumb'],
          width: 50,
          errorBuilder: (context, error, stackTrace) => Icon(Icons.videogame_asset),
        ),
        title: Text(game['external']),
        subtitle: Text('Cheapest: \$${game['cheapest']}'),
        trailing: IconButton(
          icon: Icon(Icons.favorite_border),
          onPressed: () {
            FirestoreService.addToWishlist(game['external'], game['cheapest']);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Added to wishlist')),
            );
          },
        ),
      ),
    );
  }
}

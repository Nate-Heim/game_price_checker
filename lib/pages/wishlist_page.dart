import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class WishlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Wishlist')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirestoreService.getWishlist(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Error loading wishlist'));
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

          final items = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text(item['title']),
                subtitle: Text('\$${item['price']}'),
              );
            },
          );
        },
      ),
    );
  }
}

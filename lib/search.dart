import 'package:flutter/material.dart';
import 'chatListBuilder.dart';

class MySearchDelegate extends SearchDelegate<dynamic> {
  final List<dynamic> items;

  MySearchDelegate({required this.items});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = "";
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<dynamic> searchRes = items
        .where((item) =>
            (item.userName.toString() + item.lastMessage.toString())
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
    return chatListBuilder(searchRes);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
              title: Text(items[index].userName),
              onTap: () {
                query = items[index].userName;
                showResults(context);
              });
        });
  }
}

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

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
    return ListView.builder(
        itemCount: searchRes.length,
        itemBuilder: (context, index) {
          return ListTile(
              onTap: () {},
              leading: searchRes[index].userAvatar == null
                  ? Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: <Color>[
                            Color((math.Random().nextDouble() * 0xFFFFFF)
                                    .toInt())
                                .withOpacity(1.0),
                            Colors.white,
                          ],
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.transparent,
                        child: Text(searchRes[index].userName.toString()[0]),
                      ),
                    )
                  : CircleAvatar(
                      foregroundImage: searchRes[index].userAvatar == null
                          ? null
                          : NetworkImage(
                              "assets/avatars/${searchRes[index].userAvatar}"),
                      radius: 28,
                    ),
              title: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(searchRes[index].userName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              subtitle: Text(searchRes[index].lastMessage,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16)),
              trailing: SizedBox(
                  width: 80,
                  height: 90,
                  child: Column(
                    children: <Widget>[
                      DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(searchRes[index].date, isUtc: true)) ==
                              DateFormat.yMMMd().format(DateTime.now())
                          ? Container(
                              alignment: Alignment.topRight,
                              child: Text(DateFormat.Hm().format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      searchRes[index].date,
                                      isUtc: true))))
                          : (DateTime.now().difference(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          searchRes[index].date,
                                          isUtc: true)) <
                                  const Duration(days: 6)
                              ? Container(
                                  alignment: Alignment.topRight,
                                  margin: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                                  child:
                                      Text(DateFormat.E("ru_RU").format(DateTime.fromMillisecondsSinceEpoch(searchRes[index].date, isUtc: true))))
                              : Container(alignment: Alignment.topRight, child: Text(DateFormat.MMMd("ru_RU").format(DateTime.fromMillisecondsSinceEpoch(searchRes[index].date))))),
                      const Spacer(),
                      searchRes[index].countUnreadMessages == 0
                          ? const Icon(null)
                          : Container(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor:
                                      const Color.fromARGB(255, 55, 177, 60),
                                  child: Text(
                                    searchRes[index]
                                        .countUnreadMessages
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ))),
                    ],
                  )));
        });
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

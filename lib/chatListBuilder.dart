import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

ListView chatListBuilder(items) {
  return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
            onTap: () {},
            leading: items[index].userAvatar == null
                ? Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: <Color>[
                          Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                              .withOpacity(1.0),
                          Colors.white,
                        ],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.transparent,
                      child: Text(items[index].userName.toString()[0]),
                    ),
                  )
                : CircleAvatar(
                    foregroundImage: items[index].userAvatar == null
                        ? null
                        : NetworkImage(
                            "assets/avatars/${items[index].userAvatar}"),
                    radius: 28,
                  ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(items[index].userName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            subtitle: Text(items[index].lastMessage,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16)),
            trailing: SizedBox(
                width: 80,
                height: 90,
                child: Column(
                  children: <Widget>[
                    DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(items[index].date, isUtc: true)) ==
                            DateFormat.yMMMd().format(DateTime.now())
                        ? Container(
                            alignment: Alignment.topRight,
                            child: Text(DateFormat.Hm().format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    items[index].date,
                                    isUtc: true))))
                        : (DateTime.now().difference(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        items[index].date,
                                        isUtc: true)) <
                                const Duration(days: 6)
                            ? Container(
                                alignment: Alignment.topRight,
                                margin: const EdgeInsets.fromLTRB(0, 0, 2, 0),
                                child:
                                    Text(DateFormat.E("ru_RU").format(DateTime.fromMillisecondsSinceEpoch(items[index].date, isUtc: true))))
                            : Container(alignment: Alignment.topRight, child: Text(DateFormat.MMMd("ru_RU").format(DateTime.fromMillisecondsSinceEpoch(items[index].date))))),
                    const Spacer(),
                    items[index].countUnreadMessages == 0
                        ? const Icon(null)
                        : Container(
                            alignment: Alignment.bottomRight,
                            child: CircleAvatar(
                                radius: 12,
                                backgroundColor:
                                    const Color.fromARGB(255, 55, 177, 60),
                                child: Text(
                                  items[index].countUnreadMessages.toString(),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ))),
                  ],
                )));
      });
}

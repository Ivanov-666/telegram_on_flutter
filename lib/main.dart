import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;
import 'search.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting("ru_RU");
  runApp(const MyApp());
}

class Chat {
  final String userName;
  final String? lastMessage;
  final int? date;
  final String? userAvatar;
  final int? countUnreadMessages;

  Chat(this.userName, this.lastMessage, this.date, this.userAvatar,
      this.countUnreadMessages);

  Chat.fromJson(Map<String, dynamic> json)
      : userName = json['userName'],
        lastMessage = json['lastMessage'],
        date = json['date'],
        userAvatar = json['userAvatar'],
        countUnreadMessages = json['countUnreadMessages'];

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'lastMessage': lastMessage,
        'date': date,
        'userAvatar': userAvatar,
        'countUnreadMessages': countUnreadMessages,
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Telegram'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> items = [];
  bool avatarError = false;

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('bootcamp.json');
    final data = await json.decode(response)["data"];
    var chats = [];
    for (final item in data) {
      if (item["lastMessage"] != null) {
        final Chat person = Chat.fromJson(item);
        chats.add(person);
      }
    }
    setState(() {
      items = chats;
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color(0xff55879F),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(items: items),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color:  Color(0xff55879F),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage("assets/avatars/2.jpg"),
                      radius: 34,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Fedor Ivanov',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                            SizedBox(height: 5),
                            Text('+7 (996) 000-00-00',
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white60,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
                title: const Text("Создать группу"),
                leading: const Icon(Icons.group_outlined),
                onTap: () {}),
            ListTile(
                title: const Text("Контакты"),
                leading: const Icon(Icons.person_outline_rounded),
                onTap: () {}),
            ListTile(
                title: const Text("Звонки"),
                leading: const Icon(Icons.call_outlined),
                onTap: () {}),
            ListTile(
                title: const Text("Люди рядом"),
                leading: const Icon(Icons.accessibility_new_sharp),
                onTap: () {}),
            ListTile(
                title: const Text("Избранное"),
                leading: const Icon(Icons.bookmark_border_rounded),
                onTap: () {}),
            ListTile(
                title: const Text("Настройки"),
                leading: const Icon(Icons.settings_outlined),
                onTap: () {}),
            const Divider(
              height: 10,
              color: Colors.black12,
              thickness: 1,
            ),
            ListTile(
                title: const Text("Пригласить друзей"),
                leading: const Icon(Icons.group),
                onTap: () {}),
            ListTile(
                title: const Text("Возможности Telegram"),
                leading: const Icon(Icons.question_mark_rounded),
                onTap: () {}),
          ],
        ),
      ),
      body: ListView.builder(
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
                                    child: Text(DateFormat.E("ru_RU").format(DateTime.fromMillisecondsSinceEpoch(items[index].date, isUtc: true))))
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
                                      items[index]
                                          .countUnreadMessages
                                          .toString(),
                                      style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ))),
                      ],
                    )));
          }),
    );
  }
}

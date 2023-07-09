import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'search.dart';
import 'chatListBuilder.dart';
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

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/data/bootcamp.json');
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
                  color: Color(0xff55879F),
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
        body: chatListBuilder(items));
  }
}

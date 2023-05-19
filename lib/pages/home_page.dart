import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/lecture.dart';
import '../pages/course_page.dart';
import '../pages/search_page.dart';
import '../pages/user_page.dart';
import '../services/info_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int screenIndex = 2;
  late bool showNavigationDrawer;

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
    scaffoldKey.currentState!.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final user = context.read<InfoService>().user;
    final currentLectures = user.myTimetableLectures
        .where((lecture) => lecture.year == 2023 && lecture.semester == 1)
        .toList();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: colorScheme.surfaceVariant,
      appBar: AppBar(
        centerTitle: true,
        title: screenIndex < 2
            ? Image.asset('assets/logo.png', height: 27)
            : Text(
                currentLectures[screenIndex - 2].title,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
        flexibleSpace: SafeArea(
          child: Container(
            color: colorScheme.primary,
            height: 5,
          ),
        ),
        actions: [
          if (screenIndex > 1)
            FilledButton(
              style: const ButtonStyle(
                padding: MaterialStatePropertyAll(EdgeInsets.zero),
              ),
              onPressed: () {},
              child: const Row(
                children: [
                  Icon(Icons.calendar_today, size: 16),
                  SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down, size: 16)
                ],
              ),
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: screenIndex == 0
          ? const UserPage()
          : screenIndex == 1
              ? const SearchPage()
              : const CoursePage(),
      drawer: NavigationDrawer(
        onDestinationSelected: handleScreenChanged,
        selectedIndex: screenIndex,
        children: <Widget>[
          NavigationDrawerDestination(
            label: Text("${user.lastName} ${user.firstName}"),
            icon: const Icon(Icons.abc),
          ),
          const NavigationDrawerDestination(
            label: Text("족보 열람"),
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 0, 28, 0),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              '수강중인 과목',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ...currentLectures.map(
            (Lecture lecture) {
              return NavigationDrawerDestination(
                label: Text(lecture.title),
                icon: const Icon(Icons.class_outlined),
                selectedIcon: const Icon(Icons.class_),
              );
            },
          ),
        ],
      ),
    );
  }
}

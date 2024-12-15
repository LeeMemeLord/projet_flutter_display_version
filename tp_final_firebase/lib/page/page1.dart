import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_final_firebase/page/teacher_class_management_page.dart';
import 'package:tp_final_firebase/widget/calendrier_widget.dart';
import 'package:tp_final_firebase/widget/widget_recherche.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/provider_calendrier.dart';
import '../providers/provider_classe.dart';
import '../providers/provider_user_acftif.dart';
import '../widget/user_info_widget.dart';
import 'class_gestion_page.dart';

class PageProfile extends StatefulWidget {
  const PageProfile({Key? key}) : super(key: key);

  @override
  _PageProfileState createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  int _selectedIndex = 0; // Index sélectionné dans BottomNavigationBar

  @override
  void initState() {
    super.initState();
    final calendarProvider =
        Provider.of<ProviderCalendar>(context, listen: false);
    calendarProvider.fetchCalendarInfo();

    final userInfo = Provider.of<ProviderUserinfo>(context, listen: false);
    userInfo.fetchUserInfo();

    final classProvider = Provider.of<ProviderClasse>(context, listen: false);
    classProvider.fetchAllClasses();
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<ProviderUserinfo>(context);
    final calendarProvider = Provider.of<ProviderCalendar>(context);

    return Scaffold(
        appBar: AppBar(
          actions: [
            DropdownButton<String>(
              icon: const Icon(Icons.more_vert),
              items: const [
                DropdownMenuItem(
                  value: "logout",
                  child: Row(
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text("Logout"),
                    ],
                  ),
                ),
              ],
              onChanged: (item) {
                if (item == "logout") {
                  userInfo.clearUserInfo();
                  FirebaseAuth.instance.signOut();
                }
              },
            ),
          ],
          title: const Text("Menu"),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            const InfoUserWidget(),
            CalendarWidget(
              calendar: calendarProvider.calender,
            ),
            (userInfo.userInfo["type_user"] == "Admin" ||
                    userInfo.userInfo["type_user"] == "prof")
                ? SearchWidget(
                    userInfo: userInfo.userInfo,
                  )
                : const Center(child: Text("Vous n'êtes pas admin")),
            (userInfo.userInfo["type_user"] == "Admin")
                ? const ClassManagementPage()
                : (userInfo.userInfo["type_user"] == "prof")
                    ? TeacherClassManagementPage(
                        userInfo: userInfo.userInfo,
                      )
                    : const Center(child: Text("Vous n'êtes pas admin")),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: AppLocalizations.of(context)!.bottomNavigationProfile,
              backgroundColor: Colors.amber,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today),
              label: AppLocalizations.of(context)!.bottomNavigationCalendar,
              backgroundColor: Colors.amber,
            ),
            if (userInfo.userInfo["type_user"] == "Admin" ||
                userInfo.userInfo["type_user"] == "prof")
              BottomNavigationBarItem(
                icon: const Icon(Icons.search),
                label: AppLocalizations.of(context)!.bottomNavigationSearch,
                backgroundColor: Colors.amber,
              ),
            if (userInfo.userInfo["type_user"] == "Admin" ||
                userInfo.userInfo["type_user"] == "prof")
              BottomNavigationBarItem(
                icon: const Icon(Icons.group),
                label: AppLocalizations.of(context)!
                    .bottomNavigationClassManagement,
                backgroundColor: Colors.amber,
              ),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ));
  }
}

// ignore_for_file: prefer_const_constructors, dead_code

import 'package:dr_mohamed_app/constants/color.dart';
import 'package:dr_mohamed_app/constants/icons.dart';
import 'package:dr_mohamed_app/constants/size.dart';
import 'package:dr_mohamed_app/provider/user_provider.dart';
import 'package:dr_mohamed_app/screens/featuerd_screen.dart';
import 'package:dr_mohamed_app/screens/upload_video.dart';
import 'package:dr_mohamed_app/screens/user/all_user.dart';
import 'package:dr_mohamed_app/screens/user/sign_up.dart';
import 'package:dr_mohamed_app/screens/wishlist_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _selectedIndex = 0;

  getDataFromDB() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  void initState() {
    super.initState();
    getDataFromDB();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    FeaturedScreen(),
    Wishlist(),
  ];
  @override
  Widget build(BuildContext context) {
    bool isAdminUser = false;

    if (FirebaseAuth.instance.currentUser!.email ==
        'abdelhameedmuhammad2@gmail.com') {
      isAdminUser = true;
    }
    return Scaffold(
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            isAdminUser
                ? Column(
                    children: [
                      UserAccountsDrawerHeader(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/icons/background.jpg"),
                                fit: BoxFit.cover),
                          ),
                          // currentAccountPicture: const GetUserImg(),
                          accountName: Text('dsfsd',
                              //currentUser.displayName!,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255))),
                          accountEmail: Text("mandomeko@gmail.com"
                              // currentUser.email!
                              )),
                      ListTile(
                          title: const Text("Add User"),
                          leading: const Icon(Icons.add),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()),
                            );
                          }),
                      ListTile(
                          title: const Text("All Users"),
                          leading: const Icon(Icons.people),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  AllUser()),
                            );
                          }),
                      ListTile(
                          title: const Text("Upload Video"),
                          leading: const Icon(Icons.upload),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const VideoSelector(),
                                ));
                          }),
                      ListTile(
                          title: const Text("About"),
                          leading: const Icon(Icons.help_center),
                          onTap: () {}),
                      ListTile(
                          title: const Text("Logout"),
                          leading: const Icon(Icons.exit_to_app),
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                          }),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 4, vertical: 250),
                    child: Text("Available For Admin Only",
                        style: TextStyle(
                            fontSize: 18,
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold)),
                  ),
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: const Text("Developed by ELBeaky © 2023",
                  style: TextStyle(fontSize: 16)),
            )
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: kPrimaryColor,
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                icLearning,
                height: kBottomNavigationBarItemSize,
              ),
              icon: Image.asset(
                icLearningOutlined,
                height: kBottomNavigationBarItemSize,
              ),
              label: "My Learning",
            ),
            BottomNavigationBarItem(
              activeIcon: Image.asset(
                icWishlist,
                height: kBottomNavigationBarItemSize,
              ),
              icon: Image.asset(
                icWishlistOutlined,
                height: kBottomNavigationBarItemSize,
              ),
              label: "Wishlist",
            ),
            // BottomNavigationBarItem(
            //   activeIcon: Image.asset(
            //     icSetting,
            //     height: kBottomNavigationBarItemSize,
            //   ),
            //   icon: Image.asset(
            //     icSettingOutlined,
            //     height: kBottomNavigationBarItemSize,
            //   ),
            //   label: "Settings",
            // )
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          }),
    );
  }
}

/*
Scaffold(
            backgroundColor: kPrimaryColor,
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () async {
                      await AuthUser().logOut();
                    },
                    icon: const Icon(
                      Icons.logout,
                    )),
              ],
              backgroundColor: kPrimaryColor,
              title: const Text("SD"),
            ),
            body: const Center(
              child: Text("This Page For Admin Only",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ),
          )

*/
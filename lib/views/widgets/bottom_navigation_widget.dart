import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:repo/controllers/app_controller.dart';
import 'package:repo/views/screens/edit_profile_screen.dart';

import '../../core/shared/assets.dart';
import '../../core/shared/colors.dart';
import '../../core/utils/formatting.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';

class BottomNavRepo extends StatefulWidget {
  const BottomNavRepo({super.key});

  @override
  State<BottomNavRepo> createState() => _BottomNavRepoState();
}

class _BottomNavRepoState extends State<BottomNavRepo> {
  final appController = Get.put(AppController());
  int selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    _homeScreenNavigatorKey,
    _profileScreenNavigatorKey
  ];

  Future<bool> _systemBackButtonPressed() {
    if (_navigatorKeys[selectedIndex].currentState!.canPop()) {
      _navigatorKeys[selectedIndex]
          .currentState!
          .pop(_navigatorKeys[selectedIndex].currentState);
      return Future(
        () => false,
      );
    } else {
      SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
      return Future(
        () => true,
      );
    }
  }

  static const List<Widget> _widgetOptions = [
    HomeNavigator(),
    ProfileNavigator(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _systemBackButtonPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: hexToColor(ColorsRepo.primaryColor),
          items: [
            BottomNavigationBarItem(
              icon: selectedIndex == 0
                  ? SvgPicture.asset(AssetsRepo.iconBerandaSelected)
                  : SvgPicture.asset(AssetsRepo.iconBerandaUnselected),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: selectedIndex == 1
                  ? SvgPicture.asset(AssetsRepo.iconProfilSelected)
                  : SvgPicture.asset(AssetsRepo.iconProfilUnselected),
              label: 'Profil',
            ),
          ],
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.white,
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
              if (index == selectedIndex) {
                if (HomeScreen.scrollController.hasClients) {
                  HomeScreen.scrollController.animateTo(
                    0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
              }
            });
          },
        ),
        body: Center(
          child: _widgetOptions.elementAt(selectedIndex),
        ),
      ),
    );
  }
}

class ProfileNavigator extends StatefulWidget {
  const ProfileNavigator({super.key});

  @override
  State<ProfileNavigator> createState() => _ProfileNavigatorState();
}

GlobalKey<NavigatorState> _profileScreenNavigatorKey =
    GlobalKey<NavigatorState>();

class _ProfileNavigatorState extends State<ProfileNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _profileScreenNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            switch (settings.name) {
              case '/':
                return const ProfileScreen();
              case '/ubahProfil':
                return const EditProfileScreen();
              case '/ubahPassword':
                return const ChangePasswordScreen();
              default:
                return const ProfileScreen();
            }
          },
        );
      },
    );
  }
}

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({super.key});

  @override
  State<HomeNavigator> createState() => _HomeNavigatorState();
}

GlobalKey<NavigatorState> _homeScreenNavigatorKey = GlobalKey<NavigatorState>();

class _HomeNavigatorState extends State<HomeNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _homeScreenNavigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            switch (settings.name) {
              case '/':
                return const HomeScreen();
              default:
                return const HomeScreen();
            }
          },
        );
      },
    );
  }
}

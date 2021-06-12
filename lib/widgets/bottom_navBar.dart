import 'package:flutter/material.dart';
import 'package:lets_exchange/const/const.dart';
import 'package:lets_exchange/screens/biding_screen.dart';
import 'package:lets_exchange/screens/favourite_screen.dart';
import 'package:lets_exchange/screens/home_screen.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(34.0, 0.0, 34.0, 14.0),
        child: Container(
          decoration: BoxDecoration(
            color: Constant.navColor.withOpacity(0.9),
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
            border: Border.all(color: Colors.black87, width: 1.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            ),
            child: BottomNavigationBar(
              backgroundColor: Constant.navColor.withOpacity(0.1),
              elevation: 0.0,
              // iconSize: 30,
              selectedFontSize: 12,
              unselectedFontSize: 10,
              selectedLabelStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
              selectedItemColor: Colors.black,
              currentIndex: selectedIdx,
              onTap: (int index) {
                setState(() {
                  selectedIdx = index;
                });
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  activeIcon: Icon(
                    Icons.home,
                    size: 35,
                  ),
                  title: Text('Home'),
                  // title: SizedBox(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  activeIcon: Icon(
                    Icons.favorite,
                    size: 35,
                  ),
                  title: Text('Favourite'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart),
                  activeIcon: Icon(
                    Icons.bar_chart,
                    size: 35,
                  ),
                  title: Text('Bids'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: selectedIdx,
        children: [
          HomeScreen(),
          FavouriteScreen(),
          BiddingScreen(),
        ],
      ),
    );
  }
}

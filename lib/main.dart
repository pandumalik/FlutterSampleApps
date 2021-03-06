// import 'package:flutter/material.dart';
// import 'package:flutter_app/screen/Cart.dart';
// import 'package:flutter_app/screen/GridMenu.dart';
//
// void main() => runApp(MyApp());
//
// /// This is the main application widget.
// class MyApp extends StatelessWidget {
//   static const String _title = 'Flutter Code Sample';
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       home: MyStatefulWidget(),
//     );
//   }
// }
//
// /// This is the stateful widget that the main application instantiates.
// class MyStatefulWidget extends StatefulWidget {
//   MyStatefulWidget({Key key}) : super(key: key);
//
//   @override
//   _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
// }
//
// /// This is the private State class that goes with MyStatefulWidget.
// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   int _selectedIndex = 0;
//   static List<Widget> _widgetOptions = <Widget>[HomeCatalog(), Cart()];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Shop App Sample'),
//       ),
//       body: IndexedStack(
//         children: [
//           Center(
//             child: _widgetOptions.elementAt(_selectedIndex),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add_shopping_cart),
//             label: 'Cart',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.amber[800],
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import "./database/ScopeManage.dart";
import './screen/Home.dart';
import './screen/Details.dart';
import './screen/Cart.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  AppModel appModel = AppModel();

  final routes = <String, WidgetBuilder>{
    Home.route: (BuildContext context) => Home(),
    Details.route: (BuildContext context) => Details(),
    Cart.route: (BuildContext context) => Cart()
  };

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel<AppModel>(
      model: appModel,
      child: MaterialApp(
        home: Home(
          appModel: appModel,
        ),
        routes: routes,
        theme: ThemeData(primaryColor: Colors.white),
      ),
    );
  }
}

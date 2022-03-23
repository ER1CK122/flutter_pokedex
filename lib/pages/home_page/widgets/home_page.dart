import 'package:flutter/material.dart';
import 'package:pokedex/consts/consts_app.dart';
import 'package:pokedex/pages/home_page/widgets/app_bar_home.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double statusWidth = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: -(450 / 3.4),
            left: screenWidth - (450 / 1.6),
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                ConstApp.blackPokeball,
                height: 450,
                width: 450,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                height: statusWidth,
              ),
              const AppBarHome(),
            ],
          )
        ],
      ),
    );
  }
}

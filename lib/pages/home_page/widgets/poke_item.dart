// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/consts/consts_api.dart';

import '../../../consts/consts_app.dart';

class PokeItem extends StatelessWidget {
  final String? name;
  final int? index;
  final Color? color;
  final String? num;
  final List<String>? types;

  Widget setTipos() {
    List<Widget> lista = [];
    types?.forEach((nome) {
      lista.add(
        Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(80, 255, 255, 255)),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(
                  nome.trim(),
                  style: const TextStyle(
                      fontFamily: 'Google',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            )
          ],
        ),
      );
    });
    return Column(
      children: lista,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  const PokeItem(
      {Key? key,
      required this.name,
      this.index,
      this.color,
      required this.num,
      this.types})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Stack(
            // alignment: Alignment.bottomRight,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      name!,
                      style: const TextStyle(
                        fontFamily: 'Google',
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: setTipos(),
                  ),
                ],
              ),
              Positioned(
                top: 29,
                right: -78,
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    ConstApp.whitePokeball,
                    height: 150,
                  ),
                ),
              ),
              Positioned(
                top: 55,
                right: 2,
                child: CachedNetworkImage(
                  height: 100,
                  width: 105,
                  placeholder: (context, url) => Container(
                    color: Colors.transparent,
                  ),
                  imageUrl:
                      'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/$num.png',
                ),
              )
            ],
          ),
        ),
        decoration: BoxDecoration(
          color: ConstsAPI.getColorType(type: types![0]),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
      ),
    );
  }
}

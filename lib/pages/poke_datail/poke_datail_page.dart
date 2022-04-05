// ignore_for_file: import_of_legacy_library_into_null_safe, unused_local_variable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/stores/pokeapi_store.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
// import 'package:simple_animations/simple_animations.dart';
import '../../consts/consts_app.dart';

class PokeDatailPage extends StatefulWidget {
  final int index;
  final String name;

  const PokeDatailPage({Key? key, required this.index, required this.name})
      : super(key: key);

  @override
  State<PokeDatailPage> createState() => _PokeDatailPageState();
}

class _PokeDatailPageState extends State<PokeDatailPage> {
  PageController? _pageController;
  Pokemon? _pokemon;
  PokeApiStore? _pokemonStore;
  double? _progress;
  double? _multiple;
  double? _opacity;
  double? _opacityTitleAppBar;
  // MultiTween? _animation;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    _pokemonStore = GetIt.instance<PokeApiStore>();
    _pokemon = _pokemonStore!.pokemonAtual;
    /*_animation = MultiTween(
        tween: Tween(begin: 0.0, end: 6.0),
        curve: (Curves.linear), // define tween
        duration: const Duration(seconds: 5), // define duration
        builder: (context, child, value) {
          return Container(
            color: value, // use animated value
            width: 100,
            height: 100,
          );
        });*/
    _progress = 0;
    _multiple = 1;
    _opacity = 1;
    _opacityTitleAppBar = 1;
  }

  double internal(double lower, double upper, double progress) {
    assert(lower < upper);

    if (progress > upper) return 1.0;
    if (progress < lower) return 0.0;

    return ((progress - lower) / (upper - lower)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Observer(builder: (context) {
              return Column(
                children: <Widget>[
                  AppBar(
                    title: Text(
                      _pokemon!.name ?? '',
                      style: const TextStyle(
                        fontFamily: 'Google',
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: _pokemonStore!.corPokemon,
                    leading: Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: _opacityTitleAppBar! >= 0.2 ? 0.2 : 0.0,
                            child: Image.asset(
                              ConstApp.whitePokeball,
                              height: 100,
                            ),
                          ),
                          IconButton(
                            alignment: Alignment.bottomCenter,
                            icon: const Icon(Icons.favorite_border),
                            onPressed: () {
                              Navigator.defaultRouteName;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  setTipos(_pokemonStore!.pokemonAtual!.type!)
                ],
              );
            }),
          ),
          body: Stack(
            children: <Widget>[
              Observer(builder: (context) {
                return Container(color: _pokemonStore!.corPokemon);
              }),
              Container(height: MediaQuery.of(context).size.height / 3),
              SlidingSheet(
                listener: (state) {
                  setState(() {
                    _progress = state.progress;
                    _multiple = 1 - internal(0.0, 0.7, _progress!);
                    _opacity = _multiple;
                    _opacityTitleAppBar =
                        _multiple = internal(0.55, 0.8, _progress!);
                  });
                },
                elevation: 0,
                cornerRadius: 30,
                snapSpec: const SnapSpec(
                  snap: true,
                  snappings: [0.6, 0.98],
                  positioning: SnapPositioning.relativeToAvailableSpace,
                ),
                builder: (context, state) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                  );
                },
              ),
              Opacity(
                opacity: _opacity!,
                child: Padding(
                  padding: EdgeInsets.only(top: 135 - _progress! * 50),
                  child: SizedBox(
                    height: 300,
                    width: 600,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        _pokemonStore!.setPokemonAtual(index: index);
                      },
                      itemCount: _pokemonStore!.autogenerated!.pokemon?.length,
                      itemBuilder: (BuildContext context, int count) {
                        Pokemon _pokeItem =
                            _pokemonStore!.getPokemon(index: count);
                        return Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Hero(
                              tag: count.toString(),
                              child: Opacity(
                                opacity: 0.2,
                                child: Image.asset(
                                  ConstApp.whitePokeball,
                                  height: 300,
                                  width: 700,
                                ),
                              ),
                            ),
                            CachedNetworkImage(
                              height: 250,
                              width: 160,
                              placeholder: (context, url) => Container(
                                color: Colors.transparent,
                              ),
                              imageUrl:
                                  'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/${_pokeItem.num}.png',
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget setTipos(List<String> types) {
    List<Widget> lista = [];
    for (var nome in types) {
      lista.add(
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Container(
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(80, 255, 255, 255)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
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
            ),
            const SizedBox(
              width: 5,
            )
          ],
        ),
      );
    }
    return Row(
      children: lista,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}

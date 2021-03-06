// ignore_for_file: import_of_legacy_library_into_null_safe, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/consts/consts_app.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/pages/home_page/widgets/app_bar_home.dart';
import 'package:pokedex/pages/home_page/widgets/poke_item.dart';
import 'package:pokedex/pages/poke_datail/poke_datail_page.dart';
import 'package:pokedex/stores/pokeapi_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PokeApiStore? _pokemonStore;

  @override
  void initState() {
    super.initState();
    _pokemonStore = GetIt.instance<PokeApiStore>();
    if (_pokemonStore!.autogenerated == null) {
      _pokemonStore!.fetchPokemonList();
    }
  }

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
            top: -(450 / 2.6),
            left: screenWidth - (450 / 1.3),
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                ConstApp.blackPokeball,
                height: 550,
                width: 550,
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                height: statusWidth,
              ),
              const AppBarHome(),
              Expanded(
                child: Observer(
                    name: "ListaHomePage",
                    builder: (BuildContext context) {
                      Autogenerated? _autogenerated =
                          _pokemonStore!.autogenerated;
                      return (_autogenerated != null)
                          ? AnimationLimiter(
                              child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(12),
                                addAutomaticKeepAlives: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: _pokemonStore!
                                    .autogenerated!.pokemon?.length,
                                itemBuilder: (context, index) {
                                  Pokemon pokemon =
                                      _pokemonStore!.getPokemon(index: index);
                                  return AnimationConfiguration.staggeredGrid(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    columnCount: 2,
                                    child: ScaleAnimation(
                                      child: GestureDetector(
                                        child: PokeItem(
                                          types: pokemon.type,
                                          index: index,
                                          name: pokemon.name,
                                          num: pokemon.num,
                                        ),
                                        onTap: () {
                                          _pokemonStore!
                                              .setPokemonAtual(index: index);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        PokeDatailPage(
                                                  index: index,
                                                  name: '',
                                                ),
                                                fullscreenDialog: true,
                                              ));
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : const Center(
                              child: CircularProgressIndicator(),
                            );
                    }),
              ),
            ],
          )
        ],
      ),
    );
  }
}

// ignore_for_file: import_of_legacy_library_into_null_safe, avoid_web_libraries_in_flutter, unnecessary_new
// @dart=2.9
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:pokedex/consts/consts_api.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:http/http.dart' as http;
part 'pokeapi_store.g.dart';

class PokeApiStore = _PokeApiStoreBase with _$PokeApiStore;

abstract class _PokeApiStoreBase with Store {
  @observable
  Autogenerated autogenerated;

  @action
  fetchPokemonList() {
    autogenerated = null;
    loadAutogenerated().then((pokeList) {
      autogenerated = pokeList;
    });
  }

  @action
  getPokemon({int index}) {
    return autogenerated.pokemon[index];
  }

  @action
  Widget getimage({String numero}) {
    return CachedNetworkImage(
      placeholder: (context, url) => new Container(
        color: Colors.transparent,
      ),
      imageUrl:
          'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/$numero.png',
    );
  }

  Future<Autogenerated> loadAutogenerated() async {
    try {
      final response = await http.get(ConstsAPI.pokeapiURl);
      var decodeJson = jsonDecode(response.body);
      return Autogenerated.fromJson(decodeJson);
    } catch (error, stacktrace) {
      // ignore: avoid_print
      print("Error ao carregar lista" + stacktrace.toString());
      return null;
    }
  }
}

import 'package:flutter/material.dart';

class PokemonTypeColors {
  static const Color bug = Color(0xFFA7B723);
  static const Color dark = Color(0xFF75574C);
  static const Color dragon = Color(0xFF7037FF);
  static const Color electric = Color(0xFFF9CF30);
  static const Color fairy = Color(0xFFE69EAC);
  static const Color fighting = Color(0xFFC12239);
  static const Color fire = Color(0xFFF57D31);
  static const Color flying = Color(0xFFA891EC);
  static const Color ghost = Color(0xFF70559B);
  static const Color normal = Color(0xFFAAA67F);
  static const Color grass = Color(0xFF74CB48);
  static const Color ground = Color(0xFFDEC16B);
  static const Color ice = Color(0xFF9AD6DF);
  static const Color poison = Color(0xFFA43E9E);
  static const Color psychic = Color(0xFFFB5584);
  static const Color rock = Color(0xFFB69E31);
  static const Color steel = Color(0xFFB7B9D0);
  static const Color water = Color(0xFF6493EB);

  static Color getColor(String typeName) {
    switch (typeName.toLowerCase()) {
      case 'bug':
        return bug;
      case 'dark':
        return dark;
      case 'dragon':
        return dragon;
      case 'electric':
        return electric;
      case 'fairy':
        return fairy;
      case 'fighting':
        return fighting;
      case 'fire':
        return fire;
      case 'flying':
        return flying;
      case 'ghost':
        return ghost;
      case 'normal':
        return normal;
      case 'grass':
        return grass;
      case 'ground':
        return ground;
      case 'ice':
        return ice;
      case 'poison':
        return poison;
      case 'psychic':
        return psychic;
      case 'rock':
        return rock;
      case 'steel':
        return steel;
      case 'water':
        return water;
      default:
        return psychic;
    }
  }
}

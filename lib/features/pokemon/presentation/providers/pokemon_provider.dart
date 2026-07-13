import 'dart:developer';

import 'package:flutter/material.dart';
import '../../domain/entities/pokemon_detail_entity.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../domain/usecases/get_pokemones_usecases.dart';
import '../../domain/usecases/get_pokemon_detail_usecase.dart';

enum PokemonOrder { number, name }

class PokemonProvider with ChangeNotifier {
  final GetPokemonsUseCase _getPokemonsUseCase;
  final GetPokemonDetailUseCase _getPokemonDetailUseCase;

  PokemonProvider({
    required GetPokemonsUseCase getPokemonsUseCase,
    required GetPokemonDetailUseCase getPokemonDetailUseCase,
  }) : _getPokemonsUseCase = getPokemonsUseCase,
       _getPokemonDetailUseCase = getPokemonDetailUseCase;

  PokemonEntity? _pokemonEntity;
  bool _isLoading = false;
  String _errorMessage = '';
  bool _isLoadingPage = false;
  PokemonOrder _currentOrder = PokemonOrder.number;
  String _searchQuery = '';

  PokemonEntity? get pokemonEntity {
    if (_pokemonEntity == null) return null;

    // Búsqueda por nombre
    List<PokemonResultEntity> filteredResults = _pokemonEntity!.results;
    if (_searchQuery.isNotEmpty) {
      filteredResults = filteredResults
          .where(
            (pokemon) =>
                pokemon.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    // Ordenamiento por # o nombre
    if (_currentOrder == PokemonOrder.name) {
      filteredResults.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    } else {
      filteredResults.sort((a, b) => a.pokemonId.compareTo(b.pokemonId));
    }
    return PokemonEntity(
      count: _pokemonEntity!.count,
      next: _pokemonEntity!.next,
      previous: _pokemonEntity!.previous,
      results: filteredResults,
    );
  }

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isLoadingPage => _isLoadingPage;
  PokemonOrder get currentOrder => _currentOrder;
  String get searchQuery => _searchQuery;

  int _currentOffset = 0;
  final int _limit = 20;

  Future<void> loadPokemons() async {
    _isLoading = true;
    _errorMessage = '';
    _currentOffset = 0;
    notifyListeners();

    try {
      // _pokemonEntity = await _getPokemonsUseCase();
      _pokemonEntity = await _getPokemonsUseCase(
        offset: _currentOffset,
        limit: _limit,
      );
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNextPagePokemons() async {
    if (_isLoading || _isLoadingPage) return;

    _isLoadingPage = true;
    notifyListeners();

    try {
      final nextOffset = _currentOffset + _limit;

      // 2. Ejecutamos la petición al caso de uso pasándole el nuevo offset
      final newEntity = await _getPokemonsUseCase(
        offset: nextOffset,
        limit: _limit,
      );

      if (newEntity.results.isNotEmpty && _pokemonEntity != null) {
        final updatedResults = [
          ..._pokemonEntity!.results,
          ...newEntity.results,
        ];
        _pokemonEntity = PokemonEntity(
          count: newEntity.count,
          next: newEntity.next,
          previous: newEntity.previous,
          results: updatedResults,
        );
        _currentOffset = nextOffset;
      }
    } catch (e) {
      log('❌ Error obteniendo la siguiente página de pokemones: $e');
    } finally {
      _isLoadingPage = false;
      notifyListeners();
    }
  }

  void changeSort(PokemonOrder order) {
    if (_currentOrder == order) return;
    _currentOrder = order;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<PokemonDetailEntity> loadPokemonDetail(int id) async {
    try {
      return await _getPokemonDetailUseCase(id);
    } catch (e) {
      log('❌ Error obteniendo el detalle del pokemon: $e');
      rethrow;
    }
  }
}

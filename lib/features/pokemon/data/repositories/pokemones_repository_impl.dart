import 'package:tesys21_app_pokemon/features/pokemon/data/datasources/pokemones_datasource.dart';
import '../../domain/entities/pokemon_detail_entity.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;

  PokemonRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PokemonEntity> getPokemons({int offset = 0, int limit = 20}) async {
    try {
      final pokemonsModels = await remoteDataSource.getPokemonesFromApi(
        offset: offset,
        limit: limit,
      );
      return pokemonsModels;
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  @override
  Future<PokemonDetailEntity> getPokemonDetail(int id) async {
    try {
      final pokemonDetailModel = await remoteDataSource.getPokemonDetailFromApi(
        id,
      );
      return pokemonDetailModel;
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}

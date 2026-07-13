import '../entities/pokemon_detail_entity.dart';
import '../entities/pokemon_entity.dart';

abstract class PokemonRepository {
  /// Lista de [PokemonEntity].
  Future<PokemonEntity> getPokemons({int offset = 0, int limit = 20});

  /// Detalle de un [PokemonEntity].
  Future<PokemonDetailEntity> getPokemonDetail(int id);
}

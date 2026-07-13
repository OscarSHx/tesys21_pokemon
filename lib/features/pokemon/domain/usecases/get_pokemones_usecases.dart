import '../entities/pokemon_entity.dart';
import '../repositories/pokemon_repository.dart';

class GetPokemonsUseCase {
  final PokemonRepository repository;

  GetPokemonsUseCase(this.repository);

  Future<PokemonEntity> call({int offset = 0, int limit = 20}) async {
    return await repository.getPokemons(offset: offset, limit: limit);
  }
}

import '../entities/pokemon_detail_entity.dart';
import '../repositories/pokemon_repository.dart';

class GetPokemonDetailUseCase {
  final PokemonRepository repository;

  GetPokemonDetailUseCase(this.repository);

  Future<PokemonDetailEntity> call(int id) async {
    return await repository.getPokemonDetail(id);
  }
}

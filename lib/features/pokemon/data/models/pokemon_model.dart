import '../../domain/entities/pokemon_entity.dart';

class PokemonModel extends PokemonEntity {
  const PokemonModel({
    required super.count,
    required super.next,
    required super.previous,
    required List<PokemonResultModel> super.results,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      count: json['count'] as int,
      next: json['next'] ?? '',
      previous: json['previous'],
      results:
          (json['results'] as List<dynamic>?)
              ?.map(
                (item) =>
                    PokemonResultModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

class PokemonResultModel extends PokemonResultEntity {
  PokemonResultModel({
    required super.pokemonId,
    required super.name,
    required super.url,
    required super.imageUrl,
  });

  factory PokemonResultModel.fromJson(Map<String, dynamic> json) {
    final String url = json['url'] ?? '';

    final Uri uri = Uri.parse(url);
    final List<String> segments = uri.pathSegments;
    final String getPokemonId = segments.lastWhere(
      (s) => s.isNotEmpty,
      orElse: () => '1',
    );
    final int parsedPokemonId = int.tryParse(getPokemonId) ?? 1;

    return PokemonResultModel(
      pokemonId: parsedPokemonId,
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$getPokemonId.png',
    );
  }
}

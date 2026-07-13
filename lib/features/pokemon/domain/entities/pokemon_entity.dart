class PokemonEntity {
  final int count;
  final String next;
  final dynamic previous;
  final List<PokemonResultEntity> results;

  const PokemonEntity({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });
}

class PokemonResultEntity {
  final int pokemonId;
  String name;
  String url;
  final String imageUrl;

  PokemonResultEntity({
    required this.pokemonId,
    required this.name,
    required this.url,
    required this.imageUrl,
  });
}

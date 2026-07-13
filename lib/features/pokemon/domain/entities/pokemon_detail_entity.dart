class PokemonDetailEntity {
  final int id;
  final String name;
  final double weight;
  final double height;
  final List<String> types;
  final List<String> abilities;
  final Map<String, int> stats;
  final String description;

  const PokemonDetailEntity({
    required this.id,
    required this.name,
    required this.weight,
    required this.height,
    required this.types,
    required this.abilities,
    required this.stats,
    required this.description,
  });
}

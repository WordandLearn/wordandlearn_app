class Excerise {
  final bool isCompleted;

  Excerise({required this.isCompleted});
}

class Topic {
  final String name;
  final Excerise? excerise;

  Topic({
    this.excerise,
    required this.name,
  });
}

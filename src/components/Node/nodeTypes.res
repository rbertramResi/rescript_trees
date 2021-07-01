type rec node = {
  id: int,
  parent: option<int>,
  mutable children: array<node>,
}

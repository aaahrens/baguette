import 'package:baguette/baguette.dart';
import 'package:flutter/cupertino.dart';

const TurtleKey = ValueKey("turtle");
const DogKey = ValueKey("dog");
const CatKey = ValueKey("cat");

const AnimalKey = ValueKey("animal");

const DeskTopKey = ValueKey("desktop");
const DefaultKey = ValueKey("default");

final tabKeys = Set.of([TurtleKey, CatKey, DogKey]);

mixin WithDefaultKeys on BaguetteBase {
  @override
  Set<ValueKey> get valueKeys =>
      Set.of([DefaultKey, ...super.valueKeys.toList()]);
}

mixin AlwaysRender on BaguetteBase {
  @override
  bool get shouldRender => true;
}

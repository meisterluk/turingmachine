library turingmachine;

class State {
  final String name;
  static final Map<String, State> _existing = <String, State>{};
  
  /*const*/ factory State(String name) {
    if (_existing.containsKey(name))
      return _existing[name];
    else {
      final inst = new State._internal(name);
      _existing[name] = inst;
      return inst;
    }
  }
  bool operator==(State other) => (other.name == this.name);
  String toString() => this.name;
  
  static final State Start = /*const*/ new State("Start");
  static final State End = /*const*/ new State("End");

  State._internal(this.name);
}

State state(String state) {
  return new State(state);
}
library turingmachine;

import "movement.dart";
import "state.dart";
import "todo.dart";

class InstrTuple {
  Object get write => this._write;
  Movement get move => this._move;
  State get state => this._state;

  Object _write;
  Movement _move;
  State _state;

  InstrTuple(this._write, this._move, this._state);
  String toString() {
    return "{=> write ${_write}, move ${_move} and goto state ${_state}}";
  }
}

class Table {
  Map<Object, Map<State, InstrTuple>> table = new Map<Object, Map<State, InstrTuple>>();

  update(Object symbol, State from_state, Object write, Movement move, State to_state) {
    if (!table.containsKey(symbol))
      table[symbol] = new Map<State, InstrTuple>();
    table[symbol][from_state] = new InstrTuple(write, move, to_state);
  }

  bool isDefined(Object symbol, State state) {
    return table.containsKey(symbol) &&
        table[symbol].containsKey(state) &&
        table[symbol][state] != null;
  }

  /*InstrTuple operator[](Object symbol, State state) {
    return table[symbol][state];
  }*/

  Map<State, InstrTuple> operator[](Object symbol) {
    return table[symbol];
  }
  
  String toString() {
    return table.toString();
  }
}
library turingmachine;

import 'todo.dart';
import 'state.dart';
import 'tape.dart';
import 'table.dart';
import 'dart:html';

//typedef String State(String);

class Machine /*implements Iterable*/ {
  var step_id;
  var state;
  var tape;
  var table;

  bool _finished = false;
  bool get finished => this._final_states.contains(state) && _finished;
  bool set finished(bool v) { _finished = v; }
  
  MachineIterator get iterator => new MachineIterator(this);
  Set<State> _final_states = new Set<State>();

  @todo("meisterluk", "Implementation")
  init(State initial_state, Table tab, Tape t, [num step_id = 0]) {
    state = initial_state;
    table = tab;
    tape = t;
    this.step_id = step_id;
  }

  Object read() {
    return tape.read();
  }
  
  @todo("meisterluk", "Implementation. Go back steps steps")
  prev({int steps: 1}) {
    
  }
  
  @todo("meisterluk", "Implementation. Go forward steps steps")
  next({int steps: 1})
  {
    for (var i = 0; i < steps; i++)
    {
      var read_symbol = tape.read();
      InstrTuple instr = _lookup(read_symbol, state);
  
      // do it
      if (instr != null)
      {
        tape.write(instr.write);
        tape.move(instr.move);
        state = instr.state;
      } else {
        finished = true;
        break;
      }
    }
  }

  _lookup(Object symbol, State state) {
    Map<State, InstrTuple> l1;
    var l2;

    if (table[symbol] != null)
      l1 = table[symbol];
    else
      l1 = undefinedSymbol(symbol);

    if (l1 != null)
      l2 = l1[state];
    else
      l2 = undefinedState(state);

    if (l2 == false)
      return null;
    else
      return l2;
  }

  undefinedState(State state) {
    return false;
  }

  undefinedSymbol(Object symbol) {
    return null;
  }

  addFinalState(State s) {
    this._final_states.add(s);
  }

  addFinalStates(List<State> states) {
    this._final_states.addAll(states);
  }

  Set<State> debugSetOfStates() {
    // return the set of States
    return null;
  }
  
  Set<Object> debugAlphabet() {
    // retrieve the whole alphabet in use
    return null;
  }
}

class MachineIterator implements Iterator<Object> {
  Object _symbol;
  Object get current => _symbol;
  Machine _tm;
  num steps = 0;

  MachineIterator(this._tm);

  @todo("meisterluk", "Implementation")
  bool moveNext() {
    _tm.next();
    _symbol = _tm.read();
    steps += 1;
    if (_tm.finished)
      return true;
    else
      return false;
  }

  MachineIterator get iterator => this;
}
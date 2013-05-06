library turingmachine;

import 'todo.dart';
import 'dart:math';
import 'dart:mirrors';
import 'movement.dart';

class OutOfTapeException implements Exception {
  final Position position;
  const OutOfTapeException([this.position = null]);
  String toString() {
    if (position == null)
      return 'I ran outside the tape.';
    else
      return 'Position ${position.index} is outside of tape';
  }
}

class Position {
  final num index;
  static final Map<num, Position> _existing = new Map<num, Position>();
  
  /*const*/ factory Position(num index) {
    if (_existing.containsKey(index))
      return _existing[index];
    else {
      final inst = new Position._internal(index);
      _existing[index] = inst;
      return inst;
    }
  }
  bool operator==(Position other) => (other.index == this.index);
  Position operator+(num offset) => new Position(this.index + offset);
  Position operator-(num offset) => new Position(this.index - offset);
  String toString() => this.index.toString();

  Position._internal(this.index);
}

Position position(num index) => new Position(index);

@todo("meisterluk", "Needs a history support. For example for -5 steps")
class Tape {
  List<num> tape;
  num default_value;
  num offset;
  Position cursor;

  num get length => tape.length;

  //
  // all new values get `default_value`
  // If length == 0, get me an empty tape.
  // If length > 1,
  //     create a tape with `length` values
  //
  Tape([num _length = 0, num _default_value = 0])
  {
    assert(_length >= 0);
    tape = new List<num>();
    offset = 0;
    default_value = _default_value;

    if (_length > 0)
    {
      cursor = new Position((_length / 2).round() - 1);
      for (var i = 0; i < _length; i++)
        tape.add(_default_value);
    } else {
      cursor = new Position(0);
    }

    assert(_length == length);
  }
  
  _indexCheck(Position pos) {
    var index = _getIndex(pos);
    if (index < 0 || index >= length)
      throw new OutOfTapeException(new Position(index));
  }
  
  _getIndex([Position pos = null]) {
    pos = (pos == null ? cursor : pos);
    return pos.index + offset;
  }

  clone() {
    // http://code.google.com/p/dart/issues/detail?id=3367
    Tape clone = new Tape(length, default_value);
    clone.tape = tape;
    clone.offset = offset;
    clone.cursor = cursor;
    return clone;
  }
  
  @todo("meisterluk", "Move to a new position")
  moveTo(Position goto) {
    _indexCheck(goto);
    cursor = goto;
  }

  @todo("meisterluk", "Read value at position")
  num read([Position pos = null]) {
    num index = _getIndex(pos);
    _indexCheck(new Position(index));
    return tape[index];
  }
  
  @todo("meisterluk", "Write value at position")
  write(num value, [Position pos = null]) {
    num index = _getIndex(pos);
    tape[index] = value; 
  }
  
  @todo("meisterluk", "Return left-most (lowest) position")
  Position get begin {
    return new Position(-offset);
  }

  @todo("meisterluk", "Return right-most (highest) position")
  Position get end {
    return new Position(length - offset);
  }
  
  @todo("meisterluk", "Go one position left")
  left() {
    assert(offset >= 0);

    cursor = cursor - 1;
    if (_getIndex() < 0) {
      tape.insert(0, default_value);
      offset += 1;
    }
  }

  @todo("meisterluk", "Go one position right")
  right() {
    assert(offset >= 0);

    cursor = cursor + 1;
    if (_getIndex() >= length) {
      tape.add(default_value);
    }
  }
  
  @todo("meisterluk", "Move")
  move(Movement mov) {
    if (mov == Movement.R) {
      right();
    } else if (mov == Movement.L) {
      left();
    } else if (mov == Movement.H || mov == Movement.S) {
      // nothing.
    }
  }
  
  Tape operator>>(num movement) {
    for (var i = 0; i < num.abs(movement); i++)
      movement.isNegative ? left() : right();
    return this;
  }
  Tape operator<<(num movement) {
    for (var i = 0; i < num.abs(movement); i++)
      movement.isNegative ? right() : left();
    return this;
  }
  
  @todo("meisterluk", "Return the position")
  Position position() { return cursor; }
  
  String toString() {
    Iterable lst = tape.map((v) => v.toString());
    return lst.join(",");
  }
}

class TapeIterator<Position> implements Iterator<Position> {
  Position _current;
  Position get current => _current; 
  num _position = 0;
  Tape _tape;
  
  TapeIterator(this._tape);
  bool moveNext() {
    var new_pos = _position + 1;
    if (new_pos < _tape.length) {
      _current = _tape.read(new_pos);
      _position = new_pos;
      return true;
    }
    _position = _tape.length;
    _current = null;
    return false;
  }
}
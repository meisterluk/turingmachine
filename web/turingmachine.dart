import 'machine.dart';
import 'state.dart';
import 'table.dart';
import 'tape.dart';
import 'movement.dart';

const app_name = "turingmachine";
const app_version = "0.1.0-beta";
const app_author = "Lukas Prokop <admin@lukas-prokop.at>";

void main() {
  // Get a turingmachine instance
  Machine tm = new Machine();

  // Define a transition table
  Table tab = new Table();
  tab.update(0, State.Start, 1, Movement.L, State.End);
  tab.update(1, State.Start, 0, Movement.L, State.End);

  // Define an empty tape
  Tape tape = new Tape(2);

  // Initialize turing machine
  tm.init(State.Start, tab, tape);
  tm.addFinalState(State.End);

  assert(identical(state("Z1"), state("Z1")));
  assert(identical(state("HW"), state("HW")));

  // Iterate until some final state is reached
  for (var symbol in tm.iterator) {
    print(symbol.toString() + "\n");
  }
  print(tape.toString());
  print(tm.state);

  print("Done.");
}
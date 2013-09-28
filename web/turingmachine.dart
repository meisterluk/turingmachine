library turingmachine;

import 'dart:collection';
import 'dart:html';

part 'lib/machine/machine.dart';
part 'lib/machine/movement.dart';
part 'lib/machine/state.dart';
part 'lib/machine/table.dart';
part 'lib/machine/tape.dart';
part 'lib/metadata/todo.dart';
part 'lib/ui/ui.dart';

const app_name = "turingmachine";
const app_version = "0.1.0-beta";
const app_author = "Lukas Prokop <admin@lukas-prokop.at>";

Application app = new Application(app_name, app_version, app_author);

void main()
{
  app.run();
}
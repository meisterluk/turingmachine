library turingmachine;

class Movement {
  final String mov;
  const Movement(this.mov);
  String toString() => this.mov[0];
  
  static final Movement L = const Movement("Left");
  static final Movement R = const Movement("Right");
  static final Movement H = const Movement("Halt");
  static final Movement S = const Movement("Stop");
}
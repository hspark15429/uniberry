import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // new
import 'dart:math' as math;

void main() {
  runApp(InheritedParent());
}

/// This is the [StatefulWidget] that will rebuild the [InheritedWidget].
class InheritedParent extends StatefulWidget {
  const InheritedParent({super.key});

  @override
  State<InheritedParent> createState() => _InheritedParentState();
}

class _InheritedParentState extends State<InheritedParent> {
  @override
  Widget build(BuildContext context) {
    return Inherited(
      /// Pass the random color to the [InheritedWidget].
      color: _getRandomColor(),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// The inherited child is constant.
            const InheritedChild(),
            FloatingActionButton(
              /// We call setState, so the entire subtree should be rebuilt...
              /// but what about 'const InheritedChild()'?
              onPressed: () => setState(() {}),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  /// This method will return a random color.
  Color _getRandomColor() {
    return Colors.primaries[math.Random().nextInt(Colors.primaries.length)];
  }
}

/// The widget that provides a [Color] to its descendants through the context.
class Inherited extends InheritedWidget {
  const Inherited({
    super.key,
    required this.color,
    required super.child,
  });

  final Color color;

  static Inherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Inherited>();
  }

  @override
  bool updateShouldNotify(Inherited oldWidget) {
    /// Change this to see the behavior.
    return true;
  }
}

class InheritedChild extends StatefulWidget {
  const InheritedChild({super.key});

  @override
  State<InheritedChild> createState() => _InheritedChildState();
}

class _InheritedChildState extends State<InheritedChild> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128.0,
      height: 128.0,

      /// Access the color specified in 'Inherited'.
      color: Inherited.of(context)?.color,
    );
  }
}

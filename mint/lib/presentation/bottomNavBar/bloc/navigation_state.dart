abstract class NavigationState {}

class NavigationChange extends NavigationState {
  final int index;

  NavigationChange({required this.index}); 
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
abstract class NavigationEvent {}

class NavigationTo extends NavigationEvent {
  final int index;

  NavigationTo({required this.index});
}

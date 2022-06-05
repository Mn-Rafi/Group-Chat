part of 'showspinner_cubit.dart';

@immutable
abstract class ShowspinnerState extends Equatable {}

class ShowspinnerInitial extends ShowspinnerState {
  final bool showSpinner;
  ShowspinnerInitial({
    required this.showSpinner,
  });

  @override
  List<Object?> get props => [showSpinner];
}

class ClearTextState extends ShowspinnerState {
  final TextEditingController textEditingController;
  ClearTextState({
    required this.textEditingController,
  });

  @override
  List<Object?> get props => [textEditingController];
}

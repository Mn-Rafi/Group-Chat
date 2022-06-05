import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

part 'showspinner_state.dart';

class ShowspinnerCubit extends Cubit<ShowspinnerState> {
  ShowspinnerCubit() : super(ShowspinnerInitial(showSpinner: false));

  bool showSpinner(bool showSpinner) {
    emit(ShowspinnerInitial(showSpinner: showSpinner));
    return showSpinner;
  }

  void clearTextField(TextEditingController controller) {
    controller.clear();
    emit(ClearTextState(textEditingController: controller));
  }
}

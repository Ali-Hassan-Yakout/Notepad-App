import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notepad/ui/app_manager/app_manager_state.dart';

class AppManagerCubit extends Cubit<AppManagerState> {
  AppManagerCubit() : super(AppManagerInitial());

  void onToggleChange(){
    emit(ToggleChange());
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_code_event.dart';
part 'auth_code_state.dart';

class AuthCodeBloc extends Bloc<AuthCodeEvent, AuthCodeState> {
  AuthCodeBloc() : super(AuthCodeInitial()) {
    on<AuthCodeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

part of 'auth_code_bloc.dart';

enum AuthCodeStatus { loading, succeeded, failed }

abstract class AuthCodeState extends Equatable {
  const AuthCodeState();

  @override
  List<Object> get props => [];
}

class AuthCodeInitial extends AuthCodeState {}

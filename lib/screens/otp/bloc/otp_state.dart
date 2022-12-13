part of 'otp_bloc.dart';

abstract class OtpState extends Equatable {
  const OtpState();
  
}

class OtpInitial extends OtpState {
    @override
  List<Object> get props => [];
}

class UserRegisteredState extends OtpState {
  final token;
  const UserRegisteredState(this.token);

  @override
  List<Object> get props => [token];
}

class LoggedInState extends OtpState {

  final token, talent;
  const LoggedInState(this.token, this.talent);

  @override
  List<Object> get props => [token];
}

class UserUpdatedState extends OtpState {
  final status;
  const UserUpdatedState(this.status);

  @override
  List<Object> get props => [status];
}

class CompanyRegisteredState extends OtpState {
  final token;
  const CompanyRegisteredState(this.token);

  @override
  List<Object> get props => [token];
}

part of 'otp_bloc.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();
}

class RegisterUser extends OtpEvent {
  
  String name, username, mobile, email, dob, gender, locale, code;
  RegisterUser(this.username, this.name, this.mobile, this.email, this.dob, this.gender, this.locale, this.code);

  @override
  List<Object?> get props => [];
}

class LoginUserEvent extends OtpEvent {
  
  String username;
  LoginUserEvent(this.username);

  @override
  List<Object?> get props => [];
}

class UpdateUserNameEvent extends OtpEvent {
  String? token;
  String name;
  UpdateUserNameEvent(this.token, this.name);

  @override
  List<Object?> get props => [];
}

class UpdateUserEmailEvent extends OtpEvent {
  String? token;
  String email;
  UpdateUserEmailEvent(this.token, this.email);

  @override
  List<Object?> get props => [];
}

class UpdateUserMobileEvent extends OtpEvent {
  String? token;
  String mobile, code, locale;
  UpdateUserMobileEvent(this.token, this.code, this.mobile, this.locale);

  @override
  List<Object?> get props => [];
}

class CompanyRegister extends OtpEvent {
  
  String token, name, username, mobile, email, dob, gender, locale, code;
  CompanyRegister(this.token, this.username, this.name, this.mobile, this.email, this.dob, this.gender, this.locale, this.code);

  @override
  List<Object?> get props => [];
}

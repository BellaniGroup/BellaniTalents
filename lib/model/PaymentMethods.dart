import 'dart:convert';

PaymentMethods PaymentMethodsApiFromJson(String str) => PaymentMethods.fromJson(json.decode(str));
String PaymentMethodsApiToJson(PaymentMethods data) => json.encode(data.toJson());

class PaymentMethods
 {
  PaymentMethods({
    required this.bankingOptions,
    required this.status,
  });
  late final BankingOptions bankingOptions;
  late final String status;
  
  PaymentMethods.fromJson(Map<String, dynamic> json){
    bankingOptions = BankingOptions.fromJson(json['banking_options']);
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['banking_options'] = bankingOptions.toJson();
    _data['status'] = status;
    return _data;
  }
}

class BankingOptions {
  BankingOptions({
    required this.id,
    required this.countryCode,
    required this.accountNumber,
    required this.accountOwnerName,
    required this.accountType,
    required this.bankCode,
    required this.bankName,
    required this.bic,
    required this.branchCode,
    required this.branchName,
    required this.bsb,
    required this.cbu,
    required this.cci,
    required this.clabe,
    required this.iban,
    required this.ifsc,
    required this.institutionNumber,
    required this.routingNumber,
    required this.sortCode,
    required this.swift,
    required this.transitNumber,
  });
  late final String id;
  late final String countryCode;
  late final String accountNumber;
  late final String accountOwnerName;
  late final String accountType;
  late final String bankCode;
  late final String bankName;
  late final String bic;
  late final String branchCode;
  late final String branchName;
  late final String bsb;
  late final String cbu;
  late final String cci;
  late final String clabe;
  late final String iban;
  late final String ifsc;
  late final String institutionNumber;
  late final String routingNumber;
  late final String sortCode;
  late final String swift;
  late final String transitNumber;
  
  BankingOptions.fromJson(Map<String, dynamic> json){
    id = json['id'];
    countryCode = json['country_code'];
    accountNumber = json['account_number'];
    accountOwnerName = json['account_owner_name'];
    accountType = json['account_type'];
    bankCode = json['bank_code'];
    bankName = json['bank_name'];
    bic = json['bic'];
    branchCode = json['branch_code'];
    branchName = json['branch_name'];
    bsb = json['bsb'];
    cbu = json['cbu'];
    cci = json['cci'];
    clabe = json['clabe'];
    iban = json['iban'];
    ifsc = json['ifsc'];
    institutionNumber = json['institution_number'];
    routingNumber = json['routing_number'];
    sortCode = json['sort_code'];
    swift = json['swift'];
    transitNumber = json['transit_number'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['country_code'] = countryCode;
    _data['account_number'] = accountNumber;
    _data['account_owner_name'] = accountOwnerName;
    _data['account_type'] = accountType;
    _data['bank_code'] = bankCode;
    _data['bank_name'] = bankName;
    _data['bic'] = bic;
    _data['branch_code'] = branchCode;
    _data['branch_name'] = branchName;
    _data['bsb'] = bsb;
    _data['cbu'] = cbu;
    _data['cci'] = cci;
    _data['clabe'] = clabe;
    _data['iban'] = iban;
    _data['ifsc'] = ifsc;
    _data['institution_number'] = institutionNumber;
    _data['routing_number'] = routingNumber;
    _data['sort_code'] = sortCode;
    _data['swift'] = swift;
    _data['transit_number'] = transitNumber;
    return _data;
  }
}
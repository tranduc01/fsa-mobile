class Bank {
  int? id;
  String? name;
  String? code;
  String? bin;
  String? shortName;
  String? logo;
  int? transferSupported;
  int? lookupSupported;
  String? swiftCode;
  int? support;
  int? isTransfer;

  Bank({
    this.id,
    this.name,
    this.code,
    this.bin,
    this.shortName,
    this.logo,
    this.transferSupported,
    this.lookupSupported,
    this.swiftCode,
    this.support,
    this.isTransfer,
  });

  Bank.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    bin = json['bin'];
    shortName = json['short_name'];
    logo = json['logo'];
    transferSupported = json['transferSupported'];
    lookupSupported = json['lookupSupported'];
    swiftCode = json['swift_code'];
    support = json['support'];
    isTransfer = json['isTransfer'];
  }

  @override
  String toString() {
    return '$code - $shortName';
  }
}

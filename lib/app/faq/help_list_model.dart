class HelpListResponse {
  List<RentalFaqs> rentalFaqs;
  List<RentalFaqs> rentalStationFaqs;
  List<RentalFaqs> powerbankFaqs;
  String message;
  int status;
  List<RentalFaqs> paymentsFaqs;

  HelpListResponse(
      {this.rentalFaqs,
        this.rentalStationFaqs,
        this.powerbankFaqs,
        this.message,
        this.status,
        this.paymentsFaqs});

  HelpListResponse.fromJson(Map<String, dynamic> json) {
    if (json['rentalFaqs'] != null) {
      rentalFaqs = new List<RentalFaqs>();
      json['rentalFaqs'].forEach((v) {
        rentalFaqs.add(new RentalFaqs.fromJson(v));
      });
    }
    if (json['rentalStationFaqs'] != null) {
      rentalStationFaqs = new List<RentalFaqs>();
      json['rentalStationFaqs'].forEach((v) {
        rentalStationFaqs.add(new RentalFaqs.fromJson(v));
      });
    }
    if (json['powerbankFaqs'] != null) {
      powerbankFaqs = new List<RentalFaqs>();
      json['powerbankFaqs'].forEach((v) {
        powerbankFaqs.add(new RentalFaqs.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
    if (json['paymentsFaqs'] != null) {
      paymentsFaqs = new List<RentalFaqs>();
      json['paymentsFaqs'].forEach((v) {
        paymentsFaqs.add(new RentalFaqs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rentalFaqs != null) {
      data['rentalFaqs'] = this.rentalFaqs.map((v) => v.toJson()).toList();
    }
    if (this.rentalStationFaqs != null) {
      data['rentalStationFaqs'] =
          this.rentalStationFaqs.map((v) => v.toJson()).toList();
    }
    if (this.powerbankFaqs != null) {
      data['powerbankFaqs'] =
          this.powerbankFaqs.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.paymentsFaqs != null) {
      data['paymentsFaqs'] = this.paymentsFaqs.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RentalFaqs {
  String question;
  String answer;
  int id;
  String type;

  RentalFaqs({this.question, this.answer, this.id});

  RentalFaqs.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['id'] = this.id;
    return data;
  }
}
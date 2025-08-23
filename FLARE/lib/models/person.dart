class Person {

  // Unique ID...
  String? uid;

  // Personal Details...
  String? imageProfile;
  String? name;
  int? age;
  String? gender;
  String? email;
  String? password;
  String? phone;
  String? city;
  String? state;
  String? country;
  String? profileHeader;
  String? lookingForInAPartner;
  int? publishDateTime;

  // Appearance Details...
  String? height;
  String? weight;
  String? complexion;
  String? bodyType;

  // Life Style details...
  String? smoking;
  String? drinking;
  String? livingSituation;
  String? income;
  String? profession;
  String? maritalStatus;
  String? noOfChildren;
  String? typeOfRelationship;

  // Background Details...
  String? education;
  String? noOfLanguages;
  String? religion;
  String? nationality;
  String? ethnicity;

  // Constructor
  Person({
    this.uid,
    this.imageProfile,
    this.name,
    this.age,
    this.gender,
    this.email,
    this.password,
    this.phone,
    this.city,
    this.state,
    this.country,
    this.profileHeader,
    this.lookingForInAPartner,
    this.publishDateTime,
    this.height,
    this.weight,
    this.complexion,
    this.bodyType,
    this.smoking,
    this.drinking,
    this.livingSituation,
    this.income,
    this.profession,
    this.maritalStatus,
    this.noOfChildren,
    this.typeOfRelationship,
    this.education,
    this.noOfLanguages,
    this.religion,
    this.nationality,
    this.ethnicity,
  });

  static Person fromJson(Map<String, dynamic> json) => Person(

    // Unique ID...
    uid: json['uid'],

    // Personal Details...
    imageProfile: json['imageProfile'],
    name: json['name'],
    age: json['age'] != null ?
    (json['age'] is String ? int.tryParse(json['age']) : json['age']) : null,
    gender: json['gender'],
    email: json['email'],
    password: json['password'],
    phone: json['phone'],
    city: json['city'],
    state: json['state'],
    country: json['country'],
    profileHeader: json['profileHeader'],
    lookingForInAPartner: json['lookingForInAPartner'],
    // Safe publishDateTime conversion if it might also be a String
    publishDateTime: json['publishDateTime'] != null ?
    (json['publishDateTime'] is String ? int.tryParse(json['publishDateTime']) : json['publishDateTime']) : null,

    // Appearance Details...
    height: json['height'],
    weight: json['weight'],
    complexion: json['complexion'],
    bodyType: json['bodyType'],

    // Life Style details...
    smoking: json['smoking'],
    drinking: json['drinking'],
    livingSituation: json['livingSituation'],
    income: json['income'],
    profession: json['profession'],
    maritalStatus: json['maritalStatus'],
    noOfChildren: json['noOfChildren'],
    typeOfRelationship: json['typeOfRelationship'],

    // Background Details...
    education: json['education'],
    noOfLanguages: json['noOfLanguages'],
    religion: json['religion'],
    nationality: json['nationality'],
    ethnicity: json['ethnicity'],
  );
  Map<String, dynamic> toJson() => {

    // Unique ID...
    'uid': uid,

    // Personal Details...
    'imageProfile': imageProfile,
    'name': name,
    'age': age,
    'gender': gender,
    'email': email,
    'password': password,
    'phone': phone,
    'city': city,
    'state': state,
    'country': country,
    'profileHeader': profileHeader,
    'lookingForInAPartner': lookingForInAPartner,
    'publishDateTime': publishDateTime,

    // Appearance Details...
    'height': height,
    'weight': weight,
    'complexion': complexion,
    'bodyType': bodyType,

    // Life Style details...
    'smoking': smoking,
    'drinking': drinking,
    'livingSituation': livingSituation,
    'income': income,
    'profession': profession,
    'maritalStatus': maritalStatus,
    'noOfChildren': noOfChildren,
    'typeOfRelationship': typeOfRelationship,

    // Background Details...
    'education': education,
    'noOfLanguages': noOfLanguages,
    'religion': religion,
    'nationality': nationality,
    'ethnicity': ethnicity,
  };


}

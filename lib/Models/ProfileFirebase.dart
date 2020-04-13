import 'package:flutter/foundation.dart';

class ProContext {
  final String firstname;
  final String lastname;
  final String gender;
  final String birthday;
  final String nationaity;
  final String education;
  final String religion;
  final String marital;
  final String children;
  final String current;
  final String whatsapp;
  final String phone;
  final String jobtype;
  final String jobcapacity;
  final String contract;
  final String workskill;
  final String language;
  final List workexperiences;
  final String expectedsalary;
  final String employment;
  final String selfintroduction;
  final List imagelist;

  ProContext({
    this.firstname,
    this.lastname,
    this.gender,
    this.birthday,
    this.nationaity,
    this.education,
    this.religion,
    this.marital,
    this.children,
    this.current,
    this.whatsapp,
    this.phone,
    this.jobtype,
    this.jobcapacity,
    this.contract,
    this.workskill,
    this.language,
    this.workexperiences,
    this.expectedsalary,
    this.employment,
    this.selfintroduction,
    this.imagelist,
  });

  factory ProContext.fromMap(Map<String, dynamic> data, String documentId) =>
      ProContext(
        firstname: data["firstname"],
        lastname: data["lastname"],
        gender: data["gender"],
        birthday: data["birthday"],
        nationaity: data["nationaity"],
        education: data["education"],
        religion: data["religion"],
        marital: data["marital"],
        children: data["children"],
        current: data["current"],
        whatsapp: data["whatsapp"],
        phone: data["phone"],
        jobtype: data["jobtype"],
        jobcapacity: data["jobcapacity"],
        contract: data["contract"],
        workskill: data["workskill"],
        language: data["language"],
        workexperiences: data["workexperiences"],
        expectedsalary: data["expectedsalary"],
        employment:data["employment"],
        selfintroduction:data["selfintroduction"],
        imagelist:data["imagelist"],
      );

  Map<String, dynamic> toMap() => {
    "firstname":firstname,
    "lastname":lastname,
    "gender":gender,
    "birthday":birthday,
    "nationaity":nationaity,
    "education":education,
    "religion":religion,
    "marital":marital,
    "children":children,
    "current":current,
    "whatsapp":whatsapp,
    "phone":phone,
    "jobtype":jobtype,
    "jobcapacity":jobcapacity,
    "contract":contract,
    "workskill":workskill,
    "language":language,
    "workexperiences":workexperiences,
    "expectedsalary":expectedsalary,
    "employment":employment,
    "selfintroduction":selfintroduction,
    "imagelist":imagelist,
  };

}
import 'package:flutter/material.dart';

class ReminderModel {
  String id;
  String username;
  String type;
  String details;
  String location;
  DateTime date;

  ReminderModel({
    this.username,
    this.date,
    this.details,
    this.location,
    this.type,
    this.id
  });

}
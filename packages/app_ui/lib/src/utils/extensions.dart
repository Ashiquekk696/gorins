import 'package:flutter/material.dart';

extension SizedBoxExtension on double{
Widget get h => SizedBox(height: this,);
Widget get w =>SizedBox(width: this,);
}
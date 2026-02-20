import 'package:mp_calculator/utils/formatter.dart';

class UpdateModel {
  final String note;
  final DateTime date;

  const UpdateModel({required this.note, required this.date});

  factory UpdateModel.fromJson(Map<String, dynamic> json) {
    final parsedDate = json['date'].toString();
    final parsedNote = json['note'].toString();

    if (parsedNote.isEmpty || parsedDate.isEmpty) {
      throw Exception('Update note or date is null');
    }

    return UpdateModel(note: parsedNote, date: stringToDateTime(parsedDate, inputFormat: 'yyyy-MM-dd'));
  }
}

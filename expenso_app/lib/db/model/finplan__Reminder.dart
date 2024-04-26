// The model class to represent any reminder

class Reminder{

  String? taskId;
  String name;
  DateTime when;

  Reminder(this.name, this.when);

  Map<String, dynamic> toMap(){
    return {
      'name' : name,
      'when' : when.toString(),
    };
  }
}

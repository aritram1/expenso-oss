// The model class to represent any task

class Task{
       
  String id;
  String name;
  String detail;
  DateTime when;
  bool allDay;
  bool recurring;
  int priority;
  bool completed;

  Task({
    required this.name, 
    required this.when,
    this.detail = '', 
    this.recurring = false, 
    this.allDay = false,
    this.priority = 1,
    this.completed = false
  }): id = 'SMS${when.toString()}';

  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'name' : name,
      'detail' : detail,
      'when' : when.toString(),
      'allDay' : allDay,
      'recurring' : recurring,
      'priority' : priority,
      'completed' : completed,
    };
  }
}

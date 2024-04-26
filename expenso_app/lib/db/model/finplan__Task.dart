// The model class to represent any task

class Task{

  String name;
  String detail;
  DateTime when;
  // String when;
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
  });

  Map<String, dynamic> toMap(){
    return {
      'name' : name,
      'when' : when.toString(),
      'details' : detail,
      'priority' : priority,
      // 'recurring' : recurring,
      'allDay' : allDay,
      // 'completed' : false
    };
  }
}

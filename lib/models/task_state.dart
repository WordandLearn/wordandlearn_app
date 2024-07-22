enum TaskState { pending, progress, success, failure }

class TaskProgress {
  final TaskState state;
  final double? progress;
  final String? message;

  TaskProgress({required this.state, this.progress, this.message});

  factory TaskProgress.fromJson(Map<String, dynamic> json) {
    if (json["info"] != null) {
      return TaskProgress(
          state: _stateFromString(json["state"]),
          progress: json["info"]['progress'],
          message: json["info"]['message']);
    } else {
      return TaskProgress(state: _stateFromString(json["state"]));
    }
  }
  static TaskState _stateFromString(String state) {
    state = state.toLowerCase();
    switch (state) {
      case "pending":
        return TaskState.pending;
      case "progress":
        return TaskState.progress;
      case "success":
        return TaskState.success;
      case "failure":
        return TaskState.failure;
      default:
        return TaskState.pending;
    }
  }
}

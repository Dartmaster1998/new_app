
import 'package:quick_bid/core/enums/enums.dart';

class AppState<T> {
  final T? model;
  final StateStatus status;
  final String? error;

  AppState({this.model, required this.status, this.error});

  AppState.init() : model = null, status = StateStatus.init, error = null;

  AppState<T> copyWith({
    T? model,
    StateStatus? status,
    String? error,
  }) {
    return AppState(
      model: model ?? this.model,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
  factory AppState.loading() => AppState(status: StateStatus.loading);
  factory AppState.success(T model) => AppState(status: StateStatus.success, model: model);
  factory AppState.error({String? error}) => AppState(status: StateStatus.error, error: error);
}

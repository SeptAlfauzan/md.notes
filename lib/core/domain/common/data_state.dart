sealed class DataState<T> {
  final String? errMessage;
  final T? data;
  const DataState({this.data, this.errMessage});
}

class DataLoading<T> extends DataState<T> {
  const DataLoading();
}

class DataSuccess<T> extends DataState<T> {
  @override
  final T data;
  const DataSuccess({required this.data}) : super(data: data);
}

class DataFailed<T> extends DataState<T> {
  @override
  final String errMessage;

  DataFailed({required this.errMessage}) : super(errMessage: errMessage);
}

class DataEmpty<T> extends DataState<T> {
  const DataEmpty();
}

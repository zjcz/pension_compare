class FileHandlerException implements Exception {
  final String? msg;
  final Exception? innerException;

  const FileHandlerException([this.msg, this.innerException]);

  @override
  String toString() => msg ?? 'FileHandlerException';
}

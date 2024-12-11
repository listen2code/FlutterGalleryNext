extension ScopeExtension<T> on T {
  R? let<R>(R? Function(T) it) {
    return it.call(this);
  }

  T also(void Function(T) it) {
    it.call(this);
    return this;
  }
}

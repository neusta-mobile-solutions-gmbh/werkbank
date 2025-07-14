typedef ValueFormatter<T> = String Function(T value);

typedef DoubleFormatter = ValueFormatter<double>;
typedef IntFormatter = ValueFormatter<int>;

typedef DoubleEncoder<T> = double Function(T value);
typedef DoubleDecoder<T> = T Function(double d);

import 'package:bloc/bloc.dart';

class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0); // sest the default state to zero

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

void main(List<String> args) {
  final cubit = CounterCubit();
  print(cubit.state); //! should print 0 the default state
  cubit.increment();
  print(cubit.state); //! should print 1
  cubit.close(); // close the instance for good
}

import 'package:bloc_counter_app/cubit/counter_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CounterCubit', () {
    CounterCubit counterCubit = CounterCubit();
    setUp(() {
      counterCubit = CounterCubit();
    });

    tearDown(() {
      counterCubit.close();
    });
    test('initialState', () {
      expect(counterCubit.state,
          CounterState(counterValue: 0, wasIncremented: false));
    });

    test('increment', () {
      counterCubit.increment();
      expect(counterCubit.state,
          CounterState(counterValue: 1, wasIncremented: true));
    });

    test('decrement', () {
      counterCubit.decrement();
      expect(counterCubit.state,
          CounterState(counterValue: -1, wasIncremented: false));
    });

    blocTest(
      'The cubit should emit a CounterState(counterValue:1,  wasIncremented: true when cubit.increment() function is called)',
      build: () => counterCubit,
      act: (CounterCubit cubit) => cubit.increment(),
      expect: () => [
        CounterState(counterValue: 1, wasIncremented: true),
      ],
    );
  });
}

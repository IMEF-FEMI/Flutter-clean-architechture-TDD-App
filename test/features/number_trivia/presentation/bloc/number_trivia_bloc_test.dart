import 'package:clean_architecture_app/core/error/failures.dart';
import 'package:clean_architecture_app/core/usecases/usecase.dart';
import 'package:clean_architecture_app/core/util/input_converter.dart';
import 'package:clean_architecture_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_app/features/number_trivia/domain/usecases/get_concrete_number.dart';
import 'package:clean_architecture_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be empty', () {
    // assert
    expect(bloc.initialState, equals(Empty()));
  });

  group(
    'getTriviaForConreteNumber',
    () {
      final tNumberString = '1';
      final tNumberParsed = 1;
      final tNumberTrivia = NumberTrivia(number: 1, text: "test trivia");

      void setUpMockInputConverterSuccess() =>
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Right(tNumberParsed));
      test(
          'Should call the inputconverter to validate and convert the string to an unsigned inter',
          () async {
        // arrange
        setUpMockInputConverterSuccess();
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInteger(any));
        // assert
        verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
      });

      test('Should Emit [Error] when the input is invalid', () async {
        // arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        // assert later

        final expected = [
          Empty(),
          Error(message: INVALID_INPUT_FAILURE_MESSAGE),
        ];

        expectLater(bloc, emitsInOrder(expected));
      });

      test('Should get data for the conrete use case', () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));

        // assert
        verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed)));
      });

      test('Should emit [Loading, Loaded] when data is gotten successfully',
          () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];

        expectLater(bloc, emitsInOrder(expected));

        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
      });

      test('Should emit [Loading, Error] when getting data fails', () async {
        // arrange
        setUpMockInputConverterSuccess();
        when(mockGetConcreteNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];

        expectLater(bloc, emitsInOrder(expected));

        // act
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockGetConcreteNumberTrivia(any));
      });

      test(
        'Should emit [Loading, Error] with a proper message for the errort when getting data fails',
        () async {
          // arrange
          setUpMockInputConverterSuccess();
          when(mockGetConcreteNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));

          // assert later
          final expected = [
            Empty(),
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ];

          expectLater(bloc, emitsInOrder(expected));

          // act
          bloc.add(GetTriviaForConcreteNumber(tNumberString));
          await untilCalled(mockGetConcreteNumberTrivia(any));
        },
      );
    },
  );


 group(
    'getTriviaForConreteNumber',
    () {
      final tNumberTrivia = NumberTrivia(number: 1, text: "test trivia");

     
    
      test('Should get data for the random use case', () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));
        // act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));

        // assert
        verify(mockGetRandomNumberTrivia(NoParams()));
      });

      test('Should emit [Loading, Loaded] when data is gotten successfully',
          () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Right(tNumberTrivia));

        // assert later
        final expected = [
          Empty(),
          Loading(),
          Loaded(trivia: tNumberTrivia),
        ];

        expectLater(bloc, emitsInOrder(expected));

        // act
        bloc.add(GetTriviaForRandomNumber());
        await untilCalled(mockGetRandomNumberTrivia(any));
      });

      test('Should emit [Loading, Error] when getting data fails', () async {
        // arrange
        when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(ServerFailure()));

        // assert later
        final expected = [
          Empty(),
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];

        expectLater(bloc, emitsInOrder(expected));

        // act
        bloc.add(GetTriviaForRandomNumber());
      });

      test(
        'Should emit [Loading, Error] with a proper message for the errort when getting data fails',
        () async {
          // arrange
                when(mockGetRandomNumberTrivia(any))
            .thenAnswer((_) async => Left(CacheFailure()));
          // assert later
          final expected = [
            Empty(),
            Loading(),
            Error(message: CACHE_FAILURE_MESSAGE),
          ];

          expectLater(bloc, emitsInOrder(expected));

          // act
          bloc.add(GetTriviaForRandomNumber());
        },
      );
    },
  );
}

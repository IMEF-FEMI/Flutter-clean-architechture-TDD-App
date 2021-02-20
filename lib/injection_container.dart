import 'package:clean_architecture_app/core/network/network_info.dart';
import 'package:clean_architecture_app/core/util/input_converter.dart';
import 'package:clean_architecture_app/features/number_trivia/data/datasources/number_trivia_remote_data_sources.dart';
import 'package:clean_architecture_app/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_app/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_app/features/number_trivia/domain/usecases/get_concrete_number.dart';
import 'package:clean_architecture_app/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_app/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'features/number_trivia/data/datasources/number_trivia_local_data_sources.dart';

///service locator
final sl = GetIt.instance;


Future<void>  init() async {
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory(
    () => NumberTriviaBloc(
      concrete: sl(),
      inputConverter: sl(),
      random: sl(),
    ),
  );

  // use cases
  sl.registerLazySingleton(
    () => GetConcreteNumberTrivia(
      repository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => GetRandomNumberTrivia(
      repository: sl(),
    ),
  );

  // repository
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(
      client: sl(),
    ),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton(
    () => InputConverter(),
  );
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}

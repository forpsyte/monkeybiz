import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/features/firestore/data/datasources/document_local_data_source_interface.dart';
import 'core/features/firestore/data/datasources/document_local_data_soure.dart';
import 'core/features/firestore/data/datasources/document_remote_data_source.dart';
import 'core/features/firestore/data/datasources/document_remote_data_source_interface.dart';
import 'core/features/firestore/data/repositories/document_repository.dart';
import 'core/features/firestore/domain/repositories/document_repository_interface.dart';
import 'core/features/firestore/domain/usecases/get_document_by_id.dart';
import 'core/network/local_server.dart';
import 'core/network/local_server_interface.dart';
import 'core/network/network_info_interface.dart';
import 'core/network/network_info_mobile.dart';
import 'core/utils/url_builder.dart';
import 'core/utils/url_launcher.dart';
import 'features/authentication/data/datasources/access_token_local_data_source.dart';
import 'features/authentication/data/datasources/access_token_local_data_source_interface.dart';
import 'features/authentication/data/datasources/access_token_remote_data_source.dart';
import 'features/authentication/data/datasources/access_token_remote_data_source_interface.dart';
import 'features/authentication/data/repositories/access_token_repository.dart';
import 'features/authentication/domain/repositories/access_token_repository_interface.dart';
import 'features/authentication/domain/usecases/get_access_token.dart';
import 'features/authentication/domain/usecases/remove_access_token.dart';
import 'features/authentication/presentation/state/authentication_store.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Authentication

  // Stores
  sl.registerFactory(
    () => AuthenticationStore(
      loginAction: sl(),
      configAction: sl(),
      logoutAction: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAccessToken(sl()));
  sl.registerLazySingleton(() => RemoveAccessToken(sl()));

  // Repositories
  sl.registerLazySingleton<AccessTokenRepositoryInterface>(
    () => AccessTokenRepository(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AccessTokenRemoteDataSourceInterface>(
    () => AccessTokenRemoteDataSource(
      client: sl(),
      server: sl(),
      urlBuilder: sl(),
      urlLauncher: sl(),
    ),
  );

  sl.registerLazySingleton<AccessTokenLocalDataSourceInterface>(
    () => AccessTokenLocalDataSource(
      sharedPreferences: sl(),
    ),
  );

  // Utilities
  sl.registerLazySingleton(() => UrlBuilder());
  sl.registerLazySingleton(() => UrlLauncher());

  //! Core Features - Firestore

  // Use cases
  sl.registerLazySingleton(() => GetDocumentById(sl()));

  // Repositories
  sl.registerLazySingleton<DocumentRepositoryInterface>(
    () => DocumentRepository(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<DocumentRemoteDataSourceInterface>(
    () => DocumentRemoteDataSource(
      firestore: sl(),
      collection: 'config',
    ),
  );

  sl.registerLazySingleton<DocumentLocalDataSourceInterface>(
    () => DocumentLocalDataSource(
      sharedPreferences: sl(),
    ),
  );

  //! Core
  sl.registerLazySingleton<LocalServerInterface>(
    () => LocalServer(
      stream: sl(),
      httpServer: sl(),
    ),
  );

  sl.registerLazySingleton<NetworkInfoInterface>(() => NetworkInfoMobile(sl()));

  //! External
  final http.Client client = http.Client();
  final StreamController<Map<String, String>> stream = StreamController();
  final HttpServer server =
      await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  final sharedPreferences = await SharedPreferences.getInstance();
  final firestore = Firestore.instance;
  sl.registerLazySingleton(() => client);
  sl.registerLazySingleton(() => stream);
  sl.registerLazySingleton(() => server);
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => firestore);
  sl.registerLazySingleton(() => DataConnectionChecker());
}

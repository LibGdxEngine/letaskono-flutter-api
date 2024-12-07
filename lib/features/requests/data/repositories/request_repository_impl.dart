import '../../domain/entities/AcceptanceRequestEntity.dart';
import '../../domain/repositories/request_repository.dart';
import '../data_sources/requests_remote_data_source.dart';
import '../models/AcceptanceRequest.dart';

class RequestRepositoryImpl extends RequestRepository {
  final RequestsRemoteDataSource remoteDataSource;

  // Constructor with initializer list
  RequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AcceptanceRequestEntity>> fetchRequests({int page = 1}) async {
    // Fetch users from the remote data source
    final List<AcceptanceRequest> requests =
        await remoteDataSource.fetchRequests(page: page);

    // Map User models to UserEntity
    return requests.map((request) => _mapRequestToEntity(request)).toList();
  }

  AcceptanceRequestEntity _mapRequestToEntity(AcceptanceRequest request) {
    return AcceptanceRequestEntity(
      id: request.id,
      receiver: request.sender.code,
      sender: request.receiver.code,
      status: request.status,
      timestamp: request.timestamp,
      requestType: request.requestType,
    );
  }
}

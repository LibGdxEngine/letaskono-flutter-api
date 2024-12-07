
import '../entities/AcceptanceRequestEntity.dart';

abstract class RequestRepository {
  Future<List<AcceptanceRequestEntity>> fetchRequests({required int page});
}

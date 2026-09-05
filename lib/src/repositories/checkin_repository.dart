import '../datasources/checkin_datasource.dart';
import '../models/checkin.dart';

class CheckInRepository {
  final CheckInDataSource dataSource;

  CheckInRepository(this.dataSource);

  List<CheckIn> getCheckIns(String userId) {
    return dataSource.getCheckIns(userId);
  }

  CheckIn? getCheckIn(
      String habitId,
      String userId,
      DateTime date,
      ) {
    return dataSource.getCheckIn(
      habitId,
      userId,
      date,
    );
  }

  Future<void> addCheckIn(CheckIn checkIn) async {
    await dataSource.addCheckIn(checkIn);
  }

  Future<void> deleteCheckIn(String id) async {
    await dataSource.deleteCheckIn(id);
  }
}
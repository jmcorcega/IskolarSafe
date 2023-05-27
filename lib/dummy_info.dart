import 'package:iskolarsafe/college_data.dart';
import 'package:iskolarsafe/models/user_model.dart';

class DummyInfo {
  static final IskolarInfo fakeInfo1 = IskolarInfo(
    status: IskolarHealthStatus.healthy,
    firstName: "John Vincent",
    lastName: "Corcega",
    userName: "jmcorcega",
    studentNumber: "2021-04240",
    course: "BS Computer Science",
    college: CollegeData.colleges[1],
    condition: [],
    allergies: [],
  );
  static final IskolarInfo fakeInfo2 = IskolarInfo(
    status: IskolarHealthStatus.healthy,
    firstName: "May Rafael",
    lastName: "Laban",
    userName: "mrlaban",
    studentNumber: "0000-00000",
    course: "BS Computer Science",
    college: CollegeData.colleges[1],
    condition: [],
    allergies: [],
  );
  static final IskolarInfo fakeInfo3 = IskolarInfo(
    status: IskolarHealthStatus.quarantined,
    firstName: "Kimberly",
    lastName: "Bandillo",
    userName: "kmbandillo",
    studentNumber: "0000-00000",
    course: "BS Computer Science",
    college: CollegeData.colleges[1],
    condition: [],
    allergies: [],
  );
  static final IskolarInfo fakeInfo4 = IskolarInfo(
    status: IskolarHealthStatus.monitored,
    firstName: "Kenzo",
    lastName: "Fabregas",
    userName: "akfabregas",
    studentNumber: "0000-00000",
    course: "BS Computer Science",
    college: CollegeData.colleges[1],
    condition: [],
    allergies: [],
  );

  static List<IskolarInfo> fakeInfoList = [
    fakeInfo1,
    fakeInfo2,
    fakeInfo3,
    fakeInfo4
  ];
}

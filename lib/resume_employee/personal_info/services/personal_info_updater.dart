import 'package:job_me/_shared/api/entities/api_request.dart';
import 'package:job_me/_shared/api/entities/api_response.dart';
import 'package:job_me/_shared/api/exceptions/api_exception.dart';
import 'package:job_me/_shared/api/services/api/api.dart';
import 'package:job_me/_shared/exceptions/unknown_exception.dart';
import 'package:job_me/resume_employee/personal_info/models/personal_info_data.dart';
import 'package:job_me/resume_employee/personal_info/constants/personal_info_urls.dart';
import 'package:job_me/user/_user_core/models/user.dart';
import 'package:job_me/user/_user_core/repositories/user_repository.dart';
import 'package:http/http.dart' as http;

class PersonalInfoUpdater {
  final API _networkAdapter = API();
  bool isLoading = false;

  PersonalInfoUpdater();

  Future<User> update(PersonalInfoData personalInfoData) async {
    isLoading = true;
    var url = PersonalInfoUrls.updatePersonalInfo();
    var apiRequest = APIRequest(url);
    var map = personalInfoData.toJson();

    if (personalInfoData.imageFile != null) {
      var photo = personalInfoData.imageFile!;
      var photoToUpload = await http.MultipartFile.fromPath('photo', photo.name, filename: photo.name);
      map['photo'] = photoToUpload;
    }
    apiRequest.addParameters(map);
    try {
      var apiResponse = await _networkAdapter.postWithFormData(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException {
      isLoading = false;
      rethrow;
    }
  }

  Future<User> _processResponse(APIResponse apiResponse) async {
    if (apiResponse.data['Result'] == null) {
      throw UnknownException();
    }
    var map = apiResponse.data['Result'];
    map['token'] = UserRepository().getUser().token;
    return User.fromJson(map);
  }
}

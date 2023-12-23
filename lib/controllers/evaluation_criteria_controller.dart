import 'dart:convert';

import 'package:get/get.dart';

import '../configs.dart';
import '../models/expertise_request/evaluation_criteria.dart';
import '../models/response_model.dart';

class EvaluationCriteriaController extends GetxController {
  var evaluationCriterias = <EvaluationCriteria>[].obs;
  var evaluationCriteria = EvaluationCriteria().obs;
  var isLoading = false.obs;
  var isCreateSuccess = false.obs;
  var isDeleteSuccess = false.obs;
  var isUpdateSuccess = false.obs;
  var isError = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<List<EvaluationCriteria>> fetchEvaluationCriterias() async {
    isLoading(true);
    var url = '$BASE_URL/evaluation-criteria';

    var response = await GetConnect().get(url);

    if (response.bodyString != null) {
      ResponseModel responseModel =
          ResponseModel.fromJson(jsonDecode(response.bodyString!));

      if (response.statusCode == 200) {
        isLoading(false);
        isError(false);
        return evaluationCriterias.value = (responseModel.data as List)
            .map((e) => EvaluationCriteria.fromJson(e))
            .toList();
      } else {
        isLoading(false);
        isError(true);
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${responseModel.message}');
        throw Exception('Failed to load evaluation criterias');
      }
    } else {
      isLoading(false);
      isError(true);
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load evaluation criterias');
    }
  }

  Future<EvaluationCriteria> fetchEvaluationCriteria(int id) async {
    isLoading(true);
    var url = '$BASE_URL/evaluation-criteria/$id';

    var response = await GetConnect().get(url);

    if (response.bodyString != null) {
      ResponseModel responseModel =
          ResponseModel.fromJson(jsonDecode(response.bodyString!));

      if (response.statusCode == 200) {
        isLoading(false);
        isError(false);
        return evaluationCriteria.value =
            EvaluationCriteria.fromJson(responseModel.data);
      } else {
        isLoading(false);
        isError(true);
        print('Request failed with status: ${response.statusCode}');
        print('Request failed with status: ${responseModel.message}');
        throw Exception('Failed to load evaluation criteria');
      }
    } else {
      isLoading(false);
      isError(true);
      print('Request failed with status: ${response.statusCode}');
      throw Exception('Failed to load evaluation criteria');
    }
  }
}

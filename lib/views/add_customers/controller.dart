import 'dart:io';

import 'package:apploan/core/core.dart';
import 'package:apploan/models/models.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCustomersController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final TextEditingController dateOfBirth = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController gisCode = TextEditingController();
  final TextEditingController province = TextEditingController();
  final TextEditingController district = TextEditingController();
  final TextEditingController commune = TextEditingController();
  final TextEditingController village = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isLoading_district = false.obs;
  final RxBool isLoading_commune = false.obs;
  final RxBool isLoading_village = false.obs;

  // List<DistrictModel> districtList = [];
  // List<ProvinceModel> ProvinceList = [];
  // List<CommuneModel> CommuneList = [];
  // List<VillageModel> VillageList = [];
  final RxList<DistrictModel> districtList = <DistrictModel>[].obs;
  final RxList<ProvinceModel> ProvinceList = <ProvinceModel>[].obs;
  final RxList<CommuneModel> CommuneList = <CommuneModel>[].obs;
  final RxList<VillageModel> VillageList = <VillageModel>[].obs;
  final Rx<String?> selectedCustomer = Rx<String?>(null);
  final List<String> genderItems = ['Female', 'Male'];

  ProvinceModel? ProvinceSelected;
  DistrictModel? DistrictSelected;
  CommuneModel? CommuneSelected;
  VillageModel? VillageSelected;

  // String? selectedCustomer;
  // final List<IdNameModel> customerItems = [
  //   IdNameModel(id: 1, name: 'Female'),
  //   IdNameModel(id: 2, name: 'Male'),
  // ];
  void selectGender(String value) {
    selectedCustomer.value = value;
  }

  @override
  void onInit() async {
    await fetchProvince();
    super.onInit();
  }

  // show branch_id for login
  Future<int?> getbranchId() async {
    int? branchId = await SharedPreferencesManager.getIntValue('branch_id');
    return branchId;
  }

  // show user_id from login
  Future<int?> getUserId() async {
    int? user_id = await SharedPreferencesManager.getIntValue('user_id');
    return user_id;
  }

  // Future<void> fetchProvince() async {
  //   try {
  //     isLoading.value = true;
  //     String endPoint = EndPoints.getprovince;
  //     final res = await Get.find<ApiService>().get(
  //       endPoint,
  //       isShowLoading: false,
  //     );
  //     final data = getPropertyFromJson(res.data, 'data');
  //     ProvinceList = List.from(
  //       (data as List).map((e) => ProvinceModel.fromJson(e)),
  //     );
  //   } catch (e) {
  //     if (isClosed) {
  //       return;
  //     }
  //     ExceptionHandler.handleException(e);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  Future<void> fetchProvince() async {
    try {
      isLoading.value = true;
      final res = await Get.find<ApiService>().get(
        EndPoints.getprovince,
        isShowLoading: false,
      );
      final data = getPropertyFromJson(res.data, 'data');
      ProvinceList.value = List.from(
        (data as List).map((e) => ProvinceModel.fromJson(e)),
      );
    } catch (e) {
      if (isClosed) return;
      ExceptionHandler.handleException(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Future<void> fetchDistrict(int? id) async {
  //   try {
  //     isLoading_district.value = true;
  //     final Map<String, dynamic> params = {'id': id};
  //     String endPoint = EndPoints.getdistrict;
  //     final res = await Get.find<ApiService>().get(
  //       endPoint,
  //       queryParameters: params,
  //       isShowLoading: false,
  //     );

  //     final data = getPropertyFromJson(res.data, 'data');
  //     districtList = List.from(
  //       (data as List).map((e) => DistrictModel.fromJson(e)),
  //     );
  //   } catch (e) {
  //     if (isClosed) {
  //       return;
  //     }
  //     ExceptionHandler.handleException(e);
  //   } finally {
  //     isLoading_district.value = false;
  //   }
  // }
  Future<void> fetchDistrict(int? id) async {
    try {
      isLoading_district.value = true;
      districtList.clear(); // clear old data when province changes
      CommuneList.clear();
      VillageList.clear();
      final res = await Get.find<ApiService>().get(
        '${EndPoints.getdistrict}/$id',
        isShowLoading: false,
      );
      final data = getPropertyFromJson(res.data, 'data');
      districtList.value = List.from(
        (data as List).map((e) => DistrictModel.fromJson(e)),
      );
    } catch (e) {
      if (isClosed) return;
      ExceptionHandler.handleException(e);
    } finally {
      isLoading_district.value = false;
    }
  }

  // Future<void> fetchCommune(int? id) async {
  //   try {
  //     isLoading_commune.value = true;
  //     final Map<String, dynamic> params = {'id': id};
  //     String endPoint = EndPoints.getcommune;
  //     final res = await Get.find<ApiService>().get(
  //       endPoint,
  //       queryParameters: params,
  //       isShowLoading: false,
  //     );

  //     final data = getPropertyFromJson(res.data, 'data');
  //     CommuneList = List.from(
  //       (data as List).map((e) => CommuneModel.fromJson(e)),
  //     );
  //   } catch (e) {
  //     if (isClosed) {
  //       return;
  //     }
  //     ExceptionHandler.handleException(e);
  //   } finally {
  //     isLoading_commune.value = false;
  //   }
  // }
  Future<void> fetchCommune(int? id) async {
    try {
      isLoading_commune.value = true;
      CommuneList.clear();
      VillageList.clear();
      final res = await Get.find<ApiService>().get(
        '${EndPoints.getcommune}/$id',
        isShowLoading: false,
      );
      final data = getPropertyFromJson(res.data, 'data');
      CommuneList.value = List.from(
        (data as List).map((e) => CommuneModel.fromJson(e)),
      );
    } catch (e) {
      if (isClosed) return;
      ExceptionHandler.handleException(e);
    } finally {
      isLoading_commune.value = false;
    }
  }

  // Future<void> fetchVillage(int? id) async {
  //   try {
  //     isLoading_village.value = true;
  //     final Map<String, dynamic> params = {'id': id};

  //     String endPoint = EndPoints.getvillage;
  //     final res = await Get.find<ApiService>().get(
  //       endPoint,
  //       queryParameters: params,
  //       isShowLoading: false,
  //     );

  //     final data = getPropertyFromJson(res.data, 'data');
  //     // VillageList = List.from(
  //     //   (data as List).map((e) => VillageModel.fromJson(e)),
  //     // );
  //   } catch (e) {
  //     if (isClosed) {
  //       return;
  //     }
  //     ExceptionHandler.handleException(e);
  //   } finally {
  //     isLoading_village.value = false;
  //   }
  // }
  Future<void> fetchVillage(int? id) async {
    try {
      isLoading_village.value = true;
      VillageList.clear();
      final res = await Get.find<ApiService>().get(
        '${EndPoints.getvillage}/$id',
        isShowLoading: false,
      );
      final data = getPropertyFromJson(res.data, 'data');
      VillageList.value = List.from(
        (data as List).map((e) => VillageModel.fromJson(e)),
      );
    } catch (e) {
      if (isClosed) return;
      ExceptionHandler.handleException(e);
    } finally {
      isLoading_village.value = false;
    }
  }

  DatePicker getDatePicker() {
    final DateTime now = DateTime.now();

    // Parse initial date or use current date if text is empty
    final DateTime initialDate =
        dateOfBirth.text.isEmpty
            ? now
            : DateTime.tryParse(dateOfBirth.text) ?? now;

    final DatePicker startPicker = DatePicker(
      controller: dateOfBirth,
      initialDate: initialDate,
      minDate: DateTime(now.year - 90),
      maxDate: DateTime(now.year + 1),
      minYear: now.year,
      maxYear: now.year + 200,
    );

    return startPicker;
  }

  String formatCurrency(String amount) {
    // ignore: unnecessary_null_comparison
    return amount != null
        ? '${NumberFormat.currency(locale: 'en_US', symbol: '').format(double.parse(amount))}'
            .replaceAll('.00', '')
        : 'N/A';
  }

  void onProvinceChanged(ProvinceModel? selectedClient) {
    ProvinceSelected = selectedClient;
  }

  void onDistrictChanged(DistrictModel? selectedClient) {
    DistrictSelected = selectedClient;
  }

  void onCommuneChanged(CommuneModel? selectedClient) {
    CommuneSelected = selectedClient;
  }

  void onVillageChanged(VillageModel? selectedClient) {
    VillageSelected = selectedClient;
  }

  Future<void> submitBooking() async {
    try {
      int? branchId = await getbranchId();
      int? userId = await getUserId();
      dio.FormData formData = dio.FormData.fromMap({
        // This static because of feature removed
        'first_name': firstName.text,
        'last_name': lastName.text,
        'gender': selectedCustomer.value,
        'dob': dateOfBirth.text,
        'mobile': phoneNumber.text,
        'gis_code': gisCode.text,
        'province_id': ProvinceSelected?.id,
        'district_id': DistrictSelected?.id,
        'commune_id': CommuneSelected?.id,
        'village_id': VillageSelected?.id,
        'branch_id': branchId,
        'user_id': userId,
      });

      await Get.find<ApiService>().post(
        EndPoints.clientStore,
        formData,
        isShowLoading: true,
      );

      DialogManager.showDialog(
        title: LocaleKeys.successfully.tr,
        subTitle: LocaleKeys.youHaveSuccessfullyCreated.tr,
        onPressed: () => Get.back(),
      );
    } catch (e) {
      if (isClosed) {
        return;
      }
      ExceptionHandler.handleException(e);
    }
  }

  final RxList<File> imageFiles = RxList<File>([File('')]);
  final int totalImage = 5;
  bool isNoMoreUpload() {
    return imageFiles.length == totalImage + 1; // 1 is for placeholder image
  }
}

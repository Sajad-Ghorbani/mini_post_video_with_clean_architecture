import 'package:get/get.dart';
import 'package:mini_post_video/app/main_feature/domain/entities/meta_data_entity.dart';
import 'package:mini_post_video/app/main_feature/domain/entities/video_entity.dart';
import 'package:mini_post_video/app/main_feature/domain/use_cases/get_all_video_use_case.dart';
import 'package:mini_post_video/app/main_feature/domain/use_cases/get_video_use_case.dart';

class MainController extends GetxController {
  final GetAllVideoUseCase _getAllVideoUseCase;
  final GetVideoUseCase _getVideoUseCase;

  MainController(this._getAllVideoUseCase, this._getVideoUseCase);

  bool showLoading = false;
  int page = 1;
  List<VideoEntity> videos = [];
  MetaDataEntity? metaData;

  @override
  void onInit() {
    super.onInit();
    getAllVideo();
  }

  Future getAllVideo([int? page]) async {
    videos.clear();
    showLoading = true;
    update();
    var response = await _getAllVideoUseCase.execute(page);
    if (response.data == null) {
      Get.snackbar('Error', response.error!);
    } //
    else {
      metaData = response.data!.metaData;
      await Future.forEach(response.data!.videos, (element) async {
        VideoEntity? video = await getVideo(element.id!);
        if (video != null) {
          videos.add(video);
        }
      });
    }
    showLoading = false;
    update();
  }

  Future<VideoEntity?> getVideo(int id) async {
    var response = await _getVideoUseCase.execute(id);
    return response.data;
  }

  void goToPrePage() async {
    if (page > 1) {
      page -= 1;
      getAllVideo(page);
    }
  }

  void goToNextPage() async {
    page += 1;
    print(page);
    getAllVideo(page);
  }
}

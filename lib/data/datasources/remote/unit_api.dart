import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/general/unit_model.dart';

part 'unit_api.g.dart';

@RestApi()
abstract class UnitApi {
  factory UnitApi(Dio dio, {String? baseUrl}) = _UnitApi;

  @GET('/units')
  Future<List<UnitModel>> getAllUnits();

  @GET('/units/{id}')
  Future<UnitModel> getUnitById(@Path('id') String id);

  @GET('/units/search')
  Future<List<UnitModel>> searchUnits(@Query('query') String query);

  @POST('/units')
  Future<UnitModel> createUnit(@Body() UnitModel unit);

  @PUT('/units/{id}')
  Future<UnitModel> updateUnit(@Path('id') String id, @Body() UnitModel unit);

  @DELETE('/units/{id}')
  Future<void> deleteUnit(@Path('id') String id);
}
import 'package:caspian_owner/core/domain/person.dart';
import 'package:caspian_owner/core/domain/place.dart';
import 'package:caspian_owner/features/home/application/home_controller.dart';
import 'package:caspian_owner/features/requests/domain/goods_request.dart';

/// Stand-in data whose shapes the loading skeleton draws. Never shown as
/// text: Skeletonizer replaces every glyph with a grey block.
HomeData homePlaceholder() {
  final request = GoodsRequest(
    id: 'skeleton',
    number: 0,
    createdAt: DateTime(2026),
    requester: const Person(code: '-', nameFa: 'نام درخواست‌کننده'),
    place: const ConsumptionPlace(locationCode: '-', floorCode: '-'),
    lines: const [
      RequestLine(
        itemCode: '-',
        itemNameFa: 'نام کالای درخواستی',
        qty: 10,
        unitFa: 'عدد',
        stockNow: 0,
        usedLast30d: 0,
      ),
    ],
    status: RequestStatus.pending,
    escalated: true,
  );
  return HomeData(pendingCount: 3, latest: [request, request, request]);
}

class CommonResponse<T> {
  final List<T> data;
  final PaginationMeta pagination;

  CommonResponse({required this.data, required this.pagination});
}

class PaginationMeta {
  final int currentPage;
  final int perPage;
  final int totalItems;
  final int totalPages;

  PaginationMeta({
    required this.currentPage,
    required this.perPage,
    required this.totalItems,
    required this.totalPages,
  });
}

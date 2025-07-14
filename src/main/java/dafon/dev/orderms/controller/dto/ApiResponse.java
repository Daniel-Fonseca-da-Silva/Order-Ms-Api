package dafon.dev.orderms.controller.dto;

import java.util.*;

public record ApiResponse<T>(Map<String, Object> summary, List<T> data, PaginationResponse pagination) {

}

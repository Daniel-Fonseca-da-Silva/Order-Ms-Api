package dafon.dev.orderms.listener.dto;

import java.math.BigDecimal;

public record OrderItemEvent(String product, Integer quantity, BigDecimal price) {
}
